//
//  BowlingKata.swift
//  BowlingKataPractice
//
//  Created by Anda Cabrera on 4/6/16.
//  Copyright (c) 2016 Anda Cabrera. All rights reserved.
//

import Foundation

public class Game : NSObject {
    private var rolls = [Int] (count: 22, repeatedValue: 0)
    private var currentRoll = 0
    private var strikes = 0
    private var frame = 1
    private var scorePerFrames = Dictionary<Int, Array<Int>>()
    private var firstBallInFrame = true

    public func roll(pins: Int) {
        rolls[currentRoll] = pins
        updateFrameScores()
        currentRoll += 1
        if pins == 10 && firstBallInFrame == true{
            firstBallInFrame = !firstBallInFrame
            strikes += 1
        }
        firstBallInFrame = !firstBallInFrame
        if firstBallInFrame {
            frame += 1
        }
    }

    public func rollGutter() {
        roll(0)
    }

    public func rollSpare() {
        roll(10 - previousRoll())
    }

    public func rollStrike() {
        roll(10)
    }

    public func score() -> Int {
        var rollScore = 0
        var keepScore = 0
        for _ in 0...9 {
            if isStrike(rollScore){
                keepScore += strikeBonus(rollScore)
                rollScore += 1
            } else if isSpare(rollScore) {
                keepScore += spareBonus(rollScore)
                rollScore += 2
            } else {
                keepScore += frameScore(rollScore)
                rollScore += 2
            }
        }
        return keepScore
    }

    public func maxPinsPerRoll()-> Int {
        if firstBallInFrame == true {
            return 10
        } else {
            return 10 - previousRoll()
        }
    }

    public func newGame() {
        currentRoll = 0
        rolls = [Int](count: 22, repeatedValue: 0)
        strikes = 0
        firstBallInFrame = true
        scorePerFrames = Dictionary<Int, Array<Int>>()
        frame = 1
    }

    public func gameOver() -> Bool {
        if  currentRoll + strikes == 24 && isStrike(currentRoll - 3) {
            return true
        } else if currentRoll + strikes == 22 && isStrike(currentRoll - 3) && !isStrike(currentRoll - 2) {
            return true
        } else if (currentRoll + strikes == 21) && isSpare(currentRoll - 3){
            return true
        } else if (currentRoll + strikes == 20) && !isStrike(currentRoll-1) && !isSpare(currentRoll - 1){
            return true
        } else {
            return false
        }
    }

    public func getScorePerFrames() -> Dictionary<Int, Array<Int>> {
        return scorePerFrames
    }

    public func getScorePerFrame(frame: Int) -> Array<Int> {
        var scoreDetail = [0, 0, 0]
        if let frameScoreDetail = scorePerFrames[frame] {
            scoreDetail = frameScoreDetail
        }
        return scoreDetail
    }

    public func getFirstBallInFrame() -> Bool {
        return firstBallInFrame
    }

    private func frameScore(activeRoll: Int) -> Int {
        return rolls[activeRoll] + rolls[activeRoll + 1]
    }

    private func spareBonus(activeRoll: Int) -> Int {
        return 10 + rolls[activeRoll + 2]
    }

    private func strikeBonus(activeRoll: Int) -> Int {
        return 10 + rolls[activeRoll + 1] + rolls[activeRoll + 2]
    }

    private func isStrike(activeRoll: Int) -> Bool {

        return rolls[activeRoll] == 10
    }

    private func isSpare(activeRoll: Int) -> Bool {
        return rolls[activeRoll] + rolls[activeRoll + 1] == 10
    }

    private func previousRoll() -> Int {
        return rolls[currentRoll - 1]
    }

    private func updateFrameScores() {
        var frameScore = getScorePerFrame(frame)
        if firstBallInFrame == true {
            frameScore[0] = rolls[currentRoll]
        } else {
            frameScore[1] = rolls[currentRoll]
        }
              frameScore[2] = score()
        scorePerFrames[frame] = frameScore
    }
}

