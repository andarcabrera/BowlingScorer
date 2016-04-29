//
//  ViewControllerTest.swift
//  BowlingScorer
//
//  Created by Anda Cabrera on 4/28/16.
//  Copyright © 2016 Anda Cabrera. All rights reserved.
//

import BowlingScorer
import XCTest

class ViewControllerTest: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewControllerWithIdentifier("ViewControllerID") as! ViewController
        let _ = viewController.view
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGutterButton() {
        XCTAssertTrue(viewController.gutterButton.enabled)
    }
    
    func testStrikeButtonEnabledNewGame() {
        XCTAssertTrue(viewController.strikeButton.enabled)
    }
    
    func testStrikeButtonDisabledOnSecondThrowInGame() {
        viewController.gutterButton.sendActionsForControlEvents(.TouchUpInside)

        XCTAssertFalse(viewController.strikeButton.enabled)
    }
    
    func testSpareButtonDisabledNewGame() {
        XCTAssertFalse(viewController.spareButton.enabled)
    }
    
    func testSpareButtonEnabledOnSecondThrowInFrame() {
        let numberPicker = viewController.numberPicker
        viewController.pickerView(numberPicker, didSelectRow: 5, inComponent: 0)
        viewController.submit(viewController.recordRoll)
        
        XCTAssertTrue(viewController.spareButton.enabled)
        XCTAssertEqual(viewController.currentScore.text, "Current Score: 5")
        XCTAssertEqual(viewController.numberPicker.numberOfRowsInComponent(0), 6)
        XCTAssertTrue(viewController.numberPicker.showsSelectionIndicator)
    }
    
    func testRecordRollButton() {
        XCTAssertTrue(viewController.recordRoll.enabled)
        XCTAssertEqual("Record Roll", viewController.recordRoll.currentTitle)
    }
    
    func testButtonsDisabledWhenGameOver() {
        for _ in 0...11 {
            viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        }
        
        XCTAssertFalse(viewController.recordRoll.enabled)
        XCTAssertEqual("Game Over", viewController.recordRoll.currentTitle)
        XCTAssertFalse(viewController.strikeButton.enabled)
        XCTAssertFalse(viewController.spareButton.enabled)
        XCTAssertFalse(viewController.gutterButton.enabled)
        XCTAssertEqual(viewController.framesCollectionView.numberOfItemsInSection(0), 12)
    }
    
    func testNumberPickerNewGame() {
        XCTAssertEqual(viewController.numberPicker.numberOfRowsInComponent(0), 11)
    }
    
    func testNumberPickerOnSecondThrowInFrame() {
        let numberPicker = viewController.numberPicker
        viewController.pickerView(numberPicker, didSelectRow: 3, inComponent: 0)
        viewController.submit(viewController.recordRoll)
        
        XCTAssertEqual(viewController.numberPicker.numberOfRowsInComponent(0), 8)
    }
    
    func testCurrentScore() {
        XCTAssertEqual(viewController.currentScore.text, "0")
    }
    
    func testCollectionViewNewGame(){
        let collectionView = viewController.framesCollectionView
        
        XCTAssertEqual(viewController.collectionView(collectionView, numberOfItemsInSection: 0), 0)
    }
    
    func testCollectionAfterTwoFrames(){
        let collectionView = viewController.framesCollectionView
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)

        
        XCTAssertEqual(viewController.collectionView(collectionView, numberOfItemsInSection: 0), 2)
    }
    
    func testNewGame() {
        for _ in 0...11 {
            viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        }
        viewController.newGame()
        
        XCTAssertEqual("Record Roll", viewController.recordRoll.currentTitle)
        XCTAssertEqual("Current Score: 0", viewController.currentScore.text)
        XCTAssertTrue(viewController.recordRoll.enabled)
        XCTAssertTrue(viewController.strikeButton.enabled)
        XCTAssertFalse(viewController.spareButton.enabled)
        XCTAssertTrue(viewController.gutterButton.enabled)
    }
    
    func testRollPresetGutter() {
        viewController.gutterButton.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual("Current Score: 0", viewController.currentScore.text)
    }
    
    func testRollPresetSpare() {
        roll(3)
        viewController.spareButton.sendActionsForControlEvents(.TouchUpInside)
        roll(3)

        XCTAssertEqual("Current Score: 16", viewController.currentScore.text)
    }
    
    func testRollPresetStrike() {
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        roll(3)
        roll(4)

        XCTAssertEqual("Current Score: 24", viewController.currentScore.text)
    }
    
    func testCollectionViewWithOneFrame() {
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual(viewController.framesCollectionView.numberOfItemsInSection(0), 1)
    }
    
    func testCollectionViewWithTwoFrames() {
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        viewController.strikeButton.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual(viewController.framesCollectionView.numberOfItemsInSection(0), 2)
    }
    
    private func roll(pins: Int){
        let numberPicker = viewController.numberPicker
        viewController.pickerView(numberPicker, didSelectRow: pins, inComponent: 0)
        viewController.submit(viewController.recordRoll)
    }
    
}
