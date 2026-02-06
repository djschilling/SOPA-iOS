import Foundation
import SpriteKit

protocol JustPlaySceneObserver: AnyObject {
    func updateJustPlayScene(remainingTime: Int)
}

protocol TimeBasedGameService {
    func getRemainingTime() -> Int
    func start()
    func stop()
    func isRunning() -> Bool
    func attach(observer: JustPlaySceneObserver)
    func detach(observer: JustPlaySceneObserver)
}

private class WeakJustPlayObserver {
    weak var value: JustPlaySceneObserver?

    init(value: JustPlaySceneObserver) {
        self.value = value
    }
}

class TimeBasedGameServiceImpl: TimeBasedGameService {
    private var remainingTime: Int
    private var timer: Timer?
    private var observers: [WeakJustPlayObserver] = []

    init(remainingTime: Int) {
        self.remainingTime = max(0, remainingTime)
    }

    func getRemainingTime() -> Int {
        return remainingTime
    }

    func isRunning() -> Bool {
        return timer != nil
    }

    func start() {
        guard timer == nil, remainingTime > 0 else {
            notifyObservers()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] currentTimer in
            guard let strongSelf = self else {
                currentTimer.invalidate()
                return
            }

            strongSelf.remainingTime -= 1
            if strongSelf.remainingTime <= 0 {
                strongSelf.remainingTime = 0
                strongSelf.stop()
            }
            strongSelf.notifyObservers()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func attach(observer: JustPlaySceneObserver) {
        observers.append(WeakJustPlayObserver(value: observer))
    }

    func detach(observer: JustPlaySceneObserver) {
        observers.removeAll { $0.value === observer || $0.value == nil }
    }

    private func notifyObservers() {
        observers = observers.filter { $0.value != nil }
        for observer in observers {
            observer.value?.updateJustPlayScene(remainingTime: remainingTime)
        }
    }
}

struct JustPlayLevel {
    let leftTime: Int
    let level: Level
}

struct JustPlayLevelResult {
    let leftTime: Int
    let moves: Int
    let minLevelMoves: Int
}

struct JustPlayResult {
    let levelCount: Int
    let leftTime: Int
    let extraTime: Int
    let lastScore: Int
    let score: Int
}

private struct LevelSetting {
    let size: Int
    let moves: Int
    let extraTime: Int
    let maxScore: Int
    let minTubes: Int
    let maxTubes: Int
}

protocol JustPlayService {
    func calculateResult(justPlayLevelResult: JustPlayLevelResult) -> JustPlayResult
    func getNextLevel() -> JustPlayLevel
}

class JustPlayServiceImpl: JustPlayService {
    private var levelCount: Int = 1
    private let levelCreator: LevelCreator = LevelCreator()
    private var leftTime: Int = 10
    private var lastScore: Int = 0

    private let difficultyGameSize = [5, 5, 5, 5, 5, 6, 6, 6, 6]
    private let difficultyMoves = [2, 2, 2, 3, 3, 3, 3, 3, 3]
    private let difficultyTime = [5, 5, 7, 8, 8, 10, 8, 6, 6]
    private let difficultyScore = [5, 10, 20, 50, 200, 1000, 2000, 4000, 8000]
    private let difficultyTubesMin = [3, 3, 4, 3, 5, 6, 8, 8, 10]
    private let difficultyTubesMax = [3, 4, 9, 5, 9, 10, 12, 12, 16]

    func calculateResult(justPlayLevelResult: JustPlayLevelResult) -> JustPlayResult {
        let levelSetting = getCurrentLevelSetting()

        leftTime = calculateLeftTime(leftTime: justPlayLevelResult.leftTime, extraTime: levelSetting.extraTime)
        let extraTime = calculateExtraTime(leftTime: justPlayLevelResult.leftTime, extraTime: levelSetting.extraTime)

        let currentScore = calculateNewScore(justPlayLevelResult: justPlayLevelResult, levelSetting: levelSetting)
        let justPlayResult = JustPlayResult(levelCount: levelCount, leftTime: justPlayLevelResult.leftTime, extraTime: extraTime, lastScore: lastScore, score: currentScore)

        lastScore = currentScore
        levelCount += 1

        return justPlayResult
    }

    func getNextLevel() -> JustPlayLevel {
        let currentLevelSetting = getCurrentLevelSetting()
        let level = levelCreator.generateLevel(size: currentLevelSetting.size, moves: currentLevelSetting.moves, minTubes: currentLevelSetting.minTubes, maxTubes: currentLevelSetting.maxTubes)
        level.id = levelCount
        return JustPlayLevel(leftTime: leftTime, level: level)
    }

    private func getCurrentLevelSetting() -> LevelSetting {
        if levelCount <= 2 {
            return buildLevelSetting(difficulty: 0)
        } else if levelCount <= 5 {
            return buildLevelSetting(difficulty: 1)
        } else if levelCount <= 10 {
            return buildLevelSetting(difficulty: 2)
        } else if levelCount <= 20 {
            return buildLevelSetting(difficulty: 3)
        } else if levelCount <= 25 {
            return buildLevelSetting(difficulty: 4)
        } else if levelCount <= 30 {
            return buildLevelSetting(difficulty: 5)
        } else if levelCount <= 35 {
            return buildLevelSetting(difficulty: 5)
        } else if levelCount <= 40 {
            return buildLevelSetting(difficulty: 6)
        } else {
            return buildLevelSetting(difficulty: 7)
        }
    }

    private func buildLevelSetting(difficulty: Int) -> LevelSetting {
        return LevelSetting(
            size: difficultyGameSize[difficulty],
            moves: difficultyMoves[difficulty],
            extraTime: difficultyTime[difficulty],
            maxScore: difficultyScore[difficulty],
            minTubes: difficultyTubesMin[difficulty],
            maxTubes: difficultyTubesMax[difficulty]
        )
    }

    private func calculateLeftTime(leftTime: Int, extraTime: Int) -> Int {
        let calculatedTime = extraTime + leftTime
        return min(35, calculatedTime)
    }

    private func calculateExtraTime(leftTime: Int, extraTime: Int) -> Int {
        let calculatedLeftTime = calculateLeftTime(leftTime: leftTime, extraTime: extraTime)
        if calculatedLeftTime == 35 {
            return 35 - leftTime
        }
        return extraTime
    }

    private func calculateNewScore(justPlayLevelResult: JustPlayLevelResult, levelSetting: LevelSetting) -> Int {
        if justPlayLevelResult.leftTime == -1 {
            return lastScore
        }

        let movesToMinMovesRatio = Double(justPlayLevelResult.minLevelMoves) / Double(max(1, justPlayLevelResult.moves))
        let additionalScore = Double(levelSetting.maxScore) * movesToMinMovesRatio

        return lastScore + Int(additionalScore)
    }
}

class JustPlayGameScene: GameScene, JustPlaySceneObserver {
    private let justPlayService: JustPlayService
    private let timeBasedGameService: TimeBasedGameService
    private let levelBackup: Level

    private var leaveScene = false
    private var restartButton: SpriteButton?
    private var levelChoiceButton: SpriteButton?
    private var leftTimeNode = SKLabelNode(fontNamed: "Optima-Bold")
    private var warningOverlay: SKSpriteNode?

    init(size: CGSize, proportionSet: ProportionSet, justPlayLevel: JustPlayLevel, justPlayService: JustPlayService, timeBasedGameService: TimeBasedGameService) {
        self.levelBackup = Level(level: justPlayLevel.level)
        self.justPlayService = justPlayService
        self.timeBasedGameService = timeBasedGameService
        super.init(size: size, proportionSet: proportionSet, level: justPlayLevel.level)

        addTimerLabels()
        addWarningOverlay()
        timeBasedGameService.attach(observer: self)
        leftTimeNode.text = String(timeBasedGameService.getRemainingTime())

        if !timeBasedGameService.isRunning() {
            timeBasedGameService.start()
        }

        if timeBasedGameService.getRemainingTime() == 0 {
            if gameService.solvedPuzzle() {
                onSolvedGame()
            } else {
                onLostGame()
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(from view: SKView) {
        super.willMove(from: view)
        timeBasedGameService.detach(observer: self)
    }

    override func addButtons() {
        restartButton = SpriteButton(imageNamed: "restart", onClick: restartLevel)
        restartButton!.size.height = proportionSet.buttonSize()
        restartButton!.size.width = proportionSet.buttonSize()
        restartButton!.position = proportionSet.restartButtonPos()
        addChild(restartButton!)

        levelChoiceButton = SpriteButton(imageNamed: "LevelChoice", onClick: loadStartMenuScene)
        levelChoiceButton!.size.height = proportionSet.levelChoiceSize()
        levelChoiceButton!.size.width = proportionSet.levelChoiceSize()
        levelChoiceButton!.position = proportionSet.levelChoicePos()
        addChild(levelChoiceButton!)
    }

    private func addTimerLabels() {
        let leftTimeLabel = SKLabelNode(fontNamed: fontName)
        leftTimeLabel.text = "Left Time"
        leftTimeLabel.horizontalAlignmentMode = .left
        leftTimeLabel.verticalAlignmentMode = .top
        leftTimeLabel.position = CGPoint(x: proportionSet.movesFontSize() * -2.6, y: proportionSet.movesFontSize() * 1.4)
        leftTimeLabel.fontSize = proportionSet.movesFontSize()
        leftTimeLabel.fontColor = fontColor
        movesLabels.addChild(leftTimeLabel)

        leftTimeNode.horizontalAlignmentMode = .right
        leftTimeNode.verticalAlignmentMode = .top
        leftTimeNode.position = CGPoint(x: proportionSet.movesFontSize() * 2.7, y: proportionSet.movesFontSize() * 1.4)
        leftTimeNode.fontSize = proportionSet.movesFontSize()
        leftTimeNode.fontColor = fontColor
        movesLabels.addChild(leftTimeNode)
    }

    private func addWarningOverlay() {
        let overlay = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.width))
        overlay.position = CGPoint(x: size.width / 2.0, y: size.height * 0.8 - size.width / 2.0)
        overlay.zPosition = -1
        overlay.alpha = 0.0
        addChild(overlay)
        warningOverlay = overlay
    }

    private func restartLevel() {
        leaveScene = true
        timeBasedGameService.detach(observer: self)
        let restartLevel = JustPlayLevel(leftTime: timeBasedGameService.getRemainingTime(), level: levelBackup)
        ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromJustPlayScene(timeBasedGameService: timeBasedGameService, justPlayLevel: restartLevel)
    }

    private func loadStartMenuScene() {
        leaveScene = true
        timeBasedGameService.stop()
        ResourcesManager.getInstance().storyService?.loadStartMenuScene()
    }

    override func onSolvedGame() {
        if leaveScene {
            return
        }
        leaveScene = true
        levelSolved = true
        timeBasedGameService.stop()

        restartButton?.isUserInteractionEnabled = false
        levelChoiceButton?.isUserInteractionEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let result = JustPlayLevelResult(
                leftTime: self.timeBasedGameService.getRemainingTime(),
                moves: self.gameService.getLevel().movesCounter,
                minLevelMoves: self.gameService.getLevel().minimumMovesToSolve ?? self.gameService.getLevel().movesCounter
            )
            ResourcesManager.getInstance().storyService?.loadJustPlayScoreSceneFromJustPlayScene(justPlayLevelResult: result)
        }
    }

    private func onLostGame() {
        if leaveScene {
            return
        }
        leaveScene = true
        restartButton?.isUserInteractionEnabled = false
        levelChoiceButton?.isUserInteractionEnabled = false
        timeBasedGameService.stop()

        let result = JustPlayLevelResult(
            leftTime: -1,
            moves: gameService.getLevel().movesCounter,
            minLevelMoves: gameService.getLevel().minimumMovesToSolve ?? gameService.getLevel().movesCounter
        )
        ResourcesManager.getInstance().storyService?.loadJustPlayLostSceneFromJustPlayScene(justPlayLevelResult: result)
    }

    func updateJustPlayScene(remainingTime: Int) {
        leftTimeNode.text = String(remainingTime)

        if remainingTime <= 5 {
            warningOverlay?.removeAllActions()
            let flashIn = SKAction.fadeAlpha(to: 0.20, duration: 0.15)
            let flashOut = SKAction.fadeAlpha(to: 0.0, duration: 0.15)
            warningOverlay?.run(SKAction.sequence([flashIn, flashOut]))
        }

        if remainingTime == 0 && !gameService.solvedPuzzle() {
            onLostGame()
        }
    }
}

class JustPlayScoreScene: SKScene {
    private let justPlayResult: JustPlayResult
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)

    init(size: CGSize, proportionSet: ProportionSet, justPlayResult: JustPlayResult) {
        self.justPlayResult = justPlayResult
        _ = proportionSet
        super.init(size: size)
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)
        addLabels()
        addButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLabels() {
        let title = SKLabelNode(fontNamed: "Optima-Bold")
        title.text = "Level \(justPlayResult.levelCount) Complete"
        title.fontSize = min(size.width, size.height) * 0.07
        title.fontColor = textColor
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.82)
        addChild(title)

        let score = SKLabelNode(fontNamed: "Optima-Bold")
        score.text = "Score: \(justPlayResult.lastScore) -> \(justPlayResult.score)"
        score.fontSize = min(size.width, size.height) * 0.052
        score.fontColor = textColor
        score.position = CGPoint(x: size.width * 0.5, y: size.height * 0.60)
        addChild(score)

        let time = SKLabelNode(fontNamed: "Optima-Bold")
        time.text = "Time Left: \(justPlayResult.leftTime)"
        time.fontSize = min(size.width, size.height) * 0.043
        time.fontColor = textColor
        time.position = CGPoint(x: size.width * 0.5, y: size.height * 0.50)
        addChild(time)

        let extraTime = SKLabelNode(fontNamed: "Optima-Bold")
        extraTime.text = "Extra Time: +\(justPlayResult.extraTime)"
        extraTime.fontSize = min(size.width, size.height) * 0.043
        extraTime.fontColor = textColor
        extraTime.position = CGPoint(x: size.width * 0.5, y: size.height * 0.43)
        addChild(extraTime)

        let helper = SKLabelNode(fontNamed: "Optima-Bold")
        helper.text = "Continue to the next level?"
        helper.fontSize = min(size.width, size.height) * 0.036
        helper.fontColor = textColor
        helper.position = CGPoint(x: size.width * 0.5, y: size.height * 0.31)
        helper.alpha = 0.9
        addChild(helper)
    }

    private func addButtons() {
        let side = min(size.width, size.height) * 0.20

        let nextLevel = SpriteButton(imageNamed: "NextLevel") {
            ResourcesManager.getInstance().storyService?.loadNextJustPlayGameScene()
        }
        nextLevel.size = CGSize(width: side, height: side)
        nextLevel.position = CGPoint(x: size.width * 0.72, y: size.height * 0.17)
        addChild(nextLevel)

        let levelChoice = SpriteButton(imageNamed: "LevelChoice") {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        levelChoice.size = CGSize(width: side, height: side)
        levelChoice.position = CGPoint(x: size.width * 0.28, y: size.height * 0.17)
        addChild(levelChoice)
    }
}

class JustPlayLostScene: SKScene {
    private let proportionSet: ProportionSet
    private let justPlayResult: JustPlayResult
    private let previousHighscore: JustPlayScore?
    private let isNewHighscore: Bool
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)

    init(size: CGSize, proportionSet: ProportionSet, justPlayResult: JustPlayResult) {
        self.proportionSet = proportionSet
        self.justPlayResult = justPlayResult
        self.previousHighscore = ResourcesManager.getInstance().levelService?.getBestJustPlayScore()
        self.isNewHighscore = previousHighscore == nil || justPlayResult.score > previousHighscore!.points
        super.init(size: size)
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)
        ResourcesManager.getInstance().levelService?.submitJustPlayScore(score: JustPlayScore(points: justPlayResult.score, solvedLevels: justPlayResult.levelCount))
        if isNewHighscore {
            addConfetti()
        }
        addLabels()
        addButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLabels() {
        if isNewHighscore {
            let topTitle = SKLabelNode(fontNamed: "Optima-Bold")
            topTitle.text = "New"
            topTitle.fontSize = min(size.width, size.height) * 0.10
            topTitle.fontColor = textColor
            topTitle.position = CGPoint(x: size.width / 2.0, y: size.height * 0.81)
            topTitle.zPosition = 2
            addChild(topTitle)

            let bottomTitle = SKLabelNode(fontNamed: "Optima-Bold")
            bottomTitle.text = "Highscore"
            bottomTitle.fontSize = min(size.width, size.height) * 0.10
            bottomTitle.fontColor = textColor
            bottomTitle.position = CGPoint(x: size.width / 2.0, y: size.height * 0.73)
            bottomTitle.zPosition = 2
            addChild(bottomTitle)

            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.06, duration: 0.35),
                SKAction.scale(to: 1.0, duration: 0.35)
            ])
            let pulseForever = SKAction.repeatForever(pulse)
            topTitle.run(pulseForever)
            bottomTitle.run(pulseForever)
        } else {
            let title = SKLabelNode(fontNamed: "Optima-Bold")
            title.text = "Game Over"
            title.fontSize = min(size.width, size.height) * 0.10
            title.fontColor = textColor
            title.position = CGPoint(x: size.width / 2.0, y: size.height * 0.77)
            title.zPosition = 2
            addChild(title)
        }

        let score = SKLabelNode(fontNamed: "Optima-Bold")
        score.text = "Score: \(justPlayResult.score)"
        score.fontSize = size.height * 0.05
        score.fontColor = textColor
        score.position = CGPoint(x: size.width / 2.0, y: size.height * 0.62)
        score.zPosition = 2
        addChild(score)

        let level = SKLabelNode(fontNamed: "Optima-Bold")
        level.text = "Reached Level: \(justPlayResult.levelCount)"
        level.fontSize = size.height * 0.04
        level.fontColor = textColor
        level.position = CGPoint(x: size.width / 2.0, y: size.height * 0.54)
        level.zPosition = 2
        addChild(level)

        if let highscore = ResourcesManager.getInstance().levelService?.getBestJustPlayScore() {
            let highscoreLabel = SKLabelNode(fontNamed: "Optima-Bold")
            highscoreLabel.text = "Highscore: \(max(highscore.points, justPlayResult.score))"
            highscoreLabel.fontSize = size.height * 0.04
            highscoreLabel.fontColor = textColor
            highscoreLabel.position = CGPoint(x: size.width / 2.0, y: size.height * 0.46)
            highscoreLabel.zPosition = 2
            addChild(highscoreLabel)
        }
    }

    private func addConfetti() {
        for burst in 0..<3 {
            let delay = SKAction.wait(forDuration: Double(burst) * 0.35)
            run(delay) { [weak self] in
                self?.emitConfettiBurst(pieceCount: 80)
            }
        }
    }

    private func emitConfettiBurst(pieceCount: Int) {
        let confettiColors = [
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.07, green: 0.84, blue: 0.12, alpha: 1.0),
            UIColor(red: 0.24, green: 0.0, blue: 0.87, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        ]

        for _ in 0..<pieceCount {
            let piece = SKSpriteNode(
                color: confettiColors[Int.random(in: 0..<confettiColors.count)],
                size: CGSize(width: CGFloat.random(in: 8...16), height: CGFloat.random(in: 4...9))
            )
            piece.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height + CGFloat.random(in: 10...40))
            piece.zPosition = 1
            piece.zRotation = CGFloat.random(in: 0...(2.0 * .pi))
            addChild(piece)

            let duration = Double.random(in: 2.5...4.0)
            let driftX = CGFloat.random(in: -180...180)
            let fallY = -(size.height + 120)

            let move = SKAction.moveBy(x: driftX, y: fallY, duration: duration)
            move.timingMode = .easeIn
            let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -12...12), duration: duration)
            let fade = SKAction.sequence([
                SKAction.wait(forDuration: duration * 0.55),
                SKAction.fadeOut(withDuration: duration * 0.45)
            ])
            piece.run(SKAction.sequence([
                SKAction.group([move, rotate, fade]),
                SKAction.removeFromParent()
            ]))
        }
    }

    private func addButtons() {
        let restart = SpriteButton(imageNamed: "restart") {
            ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromMenuScene()
        }
        restart.size = CGSize(width: proportionSet.buttonSize(), height: proportionSet.buttonSize())
        restart.position = CGPoint(x: size.width * 0.72, y: size.height * 0.18)
        addChild(restart)

        let levelChoice = SpriteButton(imageNamed: "LevelChoice") {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        levelChoice.size = CGSize(width: proportionSet.buttonSize(), height: proportionSet.buttonSize())
        levelChoice.position = CGPoint(x: size.width * 0.28, y: size.height * 0.18)
        addChild(levelChoice)
    }
}
