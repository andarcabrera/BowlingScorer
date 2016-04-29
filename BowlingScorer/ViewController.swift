//
//  ViewController.swift
//  BowlingScorer
//
//  Created by Anda Cabrera on 4/10/16.
//  Copyright (c) 2016 Anda Cabrera. All rights reserved.
//

import UIKit

public class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var maxPossiblePins = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private var knockedDownPins = 0
    private let game = Game()
    

    @IBOutlet public weak var recordRoll: UIButton!
    @IBOutlet public weak var numberPicker: UIPickerView!
    @IBOutlet public weak var currentScore: UILabel!
    @IBOutlet public weak var strikeButton: UIButton!
    @IBOutlet public weak var spareButton: UIButton!
    @IBOutlet public weak var gutterButton: UIButton!
    @IBOutlet public weak var presetButton: UIButton!
    @IBOutlet public weak var framesScore: UILabel!
    @IBOutlet public weak var framesCollectionView: UICollectionView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        numberPicker.delegate = self
        numberPicker.dataSource = self
        spareButton.enabled = false
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let playedFrameScores = game.getScorePerFrames()
        return playedFrameScores.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! frameViewCelll
        let frameScoreDetails = game.getScorePerFrame(indexPath.row + 1)
        if frameScoreDetails[0] == 10 {
            cell.frameScoreDetails.text = " ▩ \n \(frameScoreDetails[2])"
        } else if frameScoreDetails[0] + frameScoreDetails[1] == 10 {
            cell.frameScoreDetails.text = "\(frameScoreDetails[0]) | ◢ \n \(frameScoreDetails[2])"
        } else {
            cell.frameScoreDetails.text = "\(frameScoreDetails[0]) | \(frameScoreDetails[1]) \n \(frameScoreDetails[2])"
        }
        return cell
    }
    
    public func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = maxPossiblePins[row]
        let attributedString = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
        return attributedString
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxPossiblePins.count
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBAction public func submit(sender: UIButton) {
        game.roll(knockedDownPins)
        updateDisplay()
        numberPicker.selectRow(0, inComponent: 0, animated: true)
        knockedDownPins = 0
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        knockedDownPins = row
    }
    
    @IBAction func rollPreset(sender: UIButton) {
        switch sender.currentTitle! {
        case "Gutter" :
            game.rollGutter()
        case "Spare":
            game.rollSpare()
        case "Strike":
            game.rollStrike()
        default:return
        }
        updateDisplay()
    }
    
    @IBAction public func newGame() {
        game.newGame()
        currentScore.text = "Current Score: 0"
        recordRoll.setTitle("Record Roll", forState: UIControlState.Normal)
        recordRoll.enabled = true
        gutterButton.enabled = true
        strikeButton.enabled = true
        spareButton.enabled = false
        maxPossiblePins = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        framesCollectionView.reloadData()
        framesCollectionView.sizeToFit()
    }
    
    private func populateNumbers(maxNumber: Int) {
        var possibleNumbers = [String]()
        for i in 0...maxNumber {
            possibleNumbers.append(String(i))
        }
        self.maxPossiblePins = possibleNumbers
        numberPicker.reloadAllComponents()
        framesCollectionView.reloadData()
    }
    
    private func enableDisableButtons() {
        if (game.getFirstBallInFrame() == true) {
            spareButton.enabled = false
            strikeButton.enabled = true
        } else {
            spareButton.enabled = true
            strikeButton.enabled = false
        }
    }
    
    private func updateDisplay() {
        currentScore.text = "Current Score: " + String(game.score())
        enableDisableButtons()
        populateNumbers(game.maxPinsPerRoll())
        if game.gameOver() == true {
            recordRoll.setTitle("Game Over", forState: UIControlState.Normal)
            recordRoll.enabled = false
            gutterButton.enabled = false
            spareButton.enabled = false
            strikeButton.enabled = false
        }
    }
}

