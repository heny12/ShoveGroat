//
//  ViewController.swift
//  ShoveGroat
//
//  Created by Henry Chipman on 1/8/16.
//  Copyright © 2016 Henry Chipman. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var redTeamNameField: UITextField!
    @IBOutlet weak var blueTeamNameField: UITextField!
    @IBOutlet weak var redGroatButton: UIImageView!
    @IBOutlet weak var blueGroatButton: UIImageView!
    @IBOutlet weak var redScore: UILabel!
    @IBOutlet weak var blueScore: UILabel!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var redHammer: UIImageView!
    @IBOutlet weak var blueHammer: UIImageView!
    @IBOutlet weak var failButton: UIImageView!
    
    var tune:AVAudioPlayer = AVAudioPlayer()
    var failure:AVAudioPlayer = AVAudioPlayer()

    var sayings =
    [
        "May the Groat be with you",
        "Groatpacolypse!",
        "Groatamanjaro!",
        "The little Groat that could",
        "Go shove it up your app",
        "Grotesque!",
        "Murder she Groat",
        "The Groat wall",
        "Groat Simulator: 2016",
        "Mad Max: Fury Groat",
        "Groat Expectations",
        "Everyday Im Shufflin'"
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Gives random title to page on load
        randomTitle()
        
        // Gives a random player the hammer
        giveHammer()
        
        // Handle the text field’s user input through delegate callbacks.
        redTeamNameField.delegate = self
        blueTeamNameField.delegate = self

        // Initializes sound used in app
        
        var tuneURL:NSURL = NSBundle.mainBundle().URLForResource("Sweet Victory", withExtension: "mp3")!
        do { tune = try AVAudioPlayer(contentsOfURL: tuneURL, fileTypeHint: nil) } catch let error as NSError {
            print(error.description)
        }
        
        var failureURL:NSURL = NSBundle.mainBundle().URLForResource("EpicFail", withExtension: "mp3")!
        do { failure = try AVAudioPlayer(contentsOfURL: failureURL, fileTypeHint: nil) } catch let error as NSError {
            print(error.description)
        }
        
        // Control for tapping the failure button
        
        var tapFailureButton = UITapGestureRecognizer(target: self, action: Selector("playEpicFail"))
        self.failButton.addGestureRecognizer(tapFailureButton)
        
        // Controls swiping and tapping actions for red groat button
        
        redGroatButton.userInteractionEnabled = true;
        var swipeRedButtonDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "decrementRed")
        swipeRedButtonDown.direction = UISwipeGestureRecognizerDirection.Down
        self.redGroatButton.addGestureRecognizer(swipeRedButtonDown)

        var swipeRedButtonUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "incrementRed")
        swipeRedButtonUp.direction = UISwipeGestureRecognizerDirection.Up
        self.redGroatButton.addGestureRecognizer(swipeRedButtonUp)
        
        var tapRedButton = UITapGestureRecognizer(target: self, action: Selector("incrementRed"))
        self.redGroatButton.addGestureRecognizer(tapRedButton)
        
        
        
        // Controls swiping and tapping actions for blue groat button
        
        blueGroatButton.userInteractionEnabled = true;
        var swipeBlueButtonDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "decrementBlue")
        swipeBlueButtonDown.direction = UISwipeGestureRecognizerDirection.Down
        self.blueGroatButton.addGestureRecognizer(swipeBlueButtonDown)
        
        var swipeBlueButtonUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "incrementBlue")
        swipeBlueButtonUp.direction = UISwipeGestureRecognizerDirection.Up
        self.blueGroatButton.addGestureRecognizer(swipeBlueButtonUp)

        var tapBlueButton = UITapGestureRecognizer(target: self, action: Selector("incrementBlue"))
        self.blueGroatButton.addGestureRecognizer(tapBlueButton)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        // Do something after editing text field
        checkForWin() // updated winner name if needed
    }
    
    
    // MARK: Actions
    func incrementRed()
    {
        let myInt: Int? = Int(redScore.text!)
        if(myInt < 21){
            redScore.text = String(myInt!+1)
        }
        checkForWin()
        removeHammer()
    }
    func incrementBlue()
    {
        let myInt: Int? = Int(blueScore.text!)
        if(myInt < 21){
            blueScore.text = String(myInt!+1)
        }
        checkForWin()
        removeHammer()
    }
    
    func decrementRed()
    {
        let myInt: Int? = Int(redScore.text!)
        if(myInt > 0){
            redScore.text = String(myInt!-1)            
        }
        checkForWin()
        removeHammer()
        tune.stop()
    }
        
    func decrementBlue()
    {
        let myInt: Int? = Int(blueScore.text!)
        if(myInt > 0){
            blueScore.text = String(myInt!-1)
        }
        checkForWin()
        removeHammer()
        tune.stop()
    }
    
    func checkForWin()
    {
        let red: Int? = Int(redScore.text!)
        let blue: Int? = Int(blueScore.text!)
        if(red > blue && red >= 21){
            let alert: String!
            if(redTeamNameField.text == ""){
                alert = "Red Team wins!"
            }else{
                alert = redTeamNameField.text! + " wins!"
            }
            titleHeader.text = alert
            victory()
        }
        if(blue > red && blue >= 21){
            let alert: String!
            if(blueTeamNameField.text == ""){
                alert = "Blue Team wins!"
            }else{
                alert = blueTeamNameField.text! + " wins!"
            }
            titleHeader.text = alert
            victory()
        }
    }
    
    @IBAction func resetButton(sender: UIButton) {
        redScore.text = "0"
        blueScore.text = "0"
        randomTitle()
        giveHammer()
        tune.stop()
    }
    
    
    // MARK: Helpers
    func giveHammer()
    {
        let flip = Int(arc4random_uniform(2))
        removeHammer()
        if(flip == 0){
           redHammer.image = UIImage(named:"hammer.png")
        }else{
           blueHammer.image = UIImage(named:"hammer.png")
        }
    }
    
    func victory()
    {
        tune.numberOfLoops = 1
        tune.prepareToPlay()
        tune.currentTime = 0
        tune.play()
    }
    
    func playEpicFail()
    {
        failure.numberOfLoops = 0
        failure.prepareToPlay()
        failure.currentTime = 0
        failure.play()
    }
    
    func removeHammer()
    {
        redHammer.image = UIImage(named:"blank.png")
        blueHammer.image = UIImage(named:"blank.png")
    }
    
    func randomTitle()
    {
        let randomIndex = Int(arc4random_uniform(UInt32(sayings.count)))
        titleHeader.text = sayings[randomIndex]
    }
}
