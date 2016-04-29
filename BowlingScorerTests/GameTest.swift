//
//  BowlingKataTest.swift
//  BowlingKataPractice
//
//  Created by Anda Cabrera on 4/6/16.
//  Copyright (c) 2016 Anda Cabrera. All rights reserved.
//

import UIKit
import XCTest
import BowlingScorer


class BowlingKataTest: XCTestCase {
    private var g = Game()
    
    func testGutterGame(){
        rollMany(20, pins: 0)
        
        XCTAssertEqual(0, g.score())
    }
    
    func testAllOnes() {
        rollMany(20, pins: 1)
        
        XCTAssertEqual(20, g.score())
    }
    
    func testSpare() {
        rollSpare()
        g.roll(3)
        rollMany(17, pins: 0)
        
        XCTAssertEqual(16, g.score())
    }
    
    func testStrike() {
        rollStrike()
        g.roll(3)
        g.roll(4)
        rollMany(16, pins: 0)
        
        XCTAssertEqual(24, g.score())
    }
    
    func testPerfectGame() {
        rollMany(12, pins: 10)
        
        XCTAssertEqual(300, g.score())
    }
    
    func testSingleRoll() {
        g.roll(1)
        
        XCTAssertEqual(1, g.score())
    }
    
    func testRollGutter(){
        g.rollGutter()
        
        XCTAssertEqual(0, g.score())
    }
    
    func testRollSpare(){
        g.roll(3)
        g.rollSpare()
        g.roll(2)
        
        XCTAssertEqual(14, g.score())
    }
    
    func testRollStrike() {
        g.rollStrike()
        g.roll(2)
        g.roll(1)
        
        XCTAssertEqual(16, g.score())
    }
    
    func testFirstBallInFrameOneRoll() {
        g.roll(1)
        
        XCTAssertEqual(false, g.getFirstBallInFrame())
    }
    
    func testFirstBallInFrameTwoRolls() {
        g.roll(1)
        g.roll(3)
        
        XCTAssertEqual(true, g.getFirstBallInFrame())
    }
    
    func testFirstBallInFramewithStrike() {
        g.rollStrike()
        
        XCTAssertEqual(true, g.getFirstBallInFrame())
    }
    
    func testPossibleNumbersFirstThrowInFrame() {
        
        XCTAssertEqual(10, g.maxPinsPerRoll())
    }
    
    func testPossibleNumbersSecondThrowInFrame() {
        g.roll(3)
        
        XCTAssertEqual(7, g.maxPinsPerRoll())
    }
    
    func testPossibleNumbersAfterStrike() {
        g.roll(10)
        
        XCTAssertEqual(10, g.maxPinsPerRoll())
    }
    
    func testGameOverPerfectGame() {
        rollMany(12, pins: 10)
        g.score()
        
        XCTAssertEqual(true, g.gameOver())
    }
    
    func testGameOverNoStrikesOrSpares() {
        rollMany(20, pins: 1)
        g.score()
        
        XCTAssertEqual(true, g.gameOver())
    }
    
    func testGameOverSpareInLastFrame() {
        rollMany(19, pins: 1)
        g.roll(9)
        g.score()
        
        XCTAssertEqual(true, g.gameOver())
    }
    
    func testGameOverMidGame() {
        rollMany(8, pins: 10)
        g.score()
        
        XCTAssertEqual(false, g.gameOver())
    }
    
    func testNewGame() {
        rollMany(8, pins: 10)
        g.newGame()
        
        XCTAssertEqual(0, g.score())
    }
    
    func testFrameScoreOneFrame() {
        g.roll(1)
        g.roll(2)
        
        XCTAssertEqual([1, 2, 3], g.getScorePerFrames()[1]!)
    }
    
    func testFrameScoreTwoFrames() {
        g.roll(1)
        g.roll(2)
        g.roll(3)
        g.roll(4)
        
        XCTAssertEqual([1, 2, 3], g.getScorePerFrames()[1]!)
        XCTAssertEqual([3, 4, 10], g.getScorePerFrames()[2]!)
    }
    
    func testFrameScoreWithSpare() {
        g.roll(7)
        g.roll(3)
        
        XCTAssertEqual([7, 3, 10], g.getScorePerFrames()[1]!)
    }
    
    func testFrameScoreWithStrike() {
        g.roll(10)
        
        XCTAssertEqual([10, 0, 10], g.getScorePerFrames()[1]!)
    }
    
    private func rollMany(times: Int, pins: Int) {
        for _ in 0...times-1{
            g.roll(pins)
        }
    }
    
    private func rollSpare() {
        g.roll(5)
        g.roll(5)
    }
    
    private func rollStrike() {
        g.roll(10)
    }
    
}
