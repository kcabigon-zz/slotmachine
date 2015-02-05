//
//  ViewController.swift
//  SlotMachine
//
//  Created by Kyle Cabigon on 12/29/14.
//  Copyright (c) 2014 Kyle Cabigon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var firstContainer:UIView!
    var secondContainer:UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    var titleLabel:UILabel!
    
    // Information Labels
    var creditsLabel = UILabel()
    var betLabel = UILabel()
    var winnerPaidLabel = UILabel()
    var creditsTitleLabel = UILabel()
    var betTitleLabel = UILabel()
    var winnerPaidTitleLabel = UILabel()
    
    // Margins and ratios
    let kMarginForView:CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0
    let kSixth:CGFloat = 1.0/6.0
    let kHalf:CGFloat = 1.0/2.0
    let kThird:CGFloat = 1.0/3.0
    let kEighth:CGFloat = 1.0/8.0
    
    // Buttons in the fourth container
    var resetButton:UIButton!
    var betOneButton:UIButton!
    var betMaxButton:UIButton!
    var spinButton:UIButton!
    
    var slots: [[Slot]] = []
    
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    // For the 9 slots
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setUpContainerViews()
        self.setUpFirstContainer(firstContainer)
        self.setUpThirdContainerLabel(creditsLabel, labelText: "000000", columnNumber: 1, valueOrLabel: "Value")
        self.setUpThirdContainerLabel(betLabel, labelText: "000000", columnNumber: 2, valueOrLabel: "Value")
        self.setUpThirdContainerLabel(winnerPaidLabel, labelText: "000000", columnNumber: 3, valueOrLabel: "Value")
        self.setUpThirdContainerLabel(creditsTitleLabel, labelText: "Credits", columnNumber: 1, valueOrLabel: "Label")
        self.setUpThirdContainerLabel(betTitleLabel, labelText: "Bet", columnNumber: 2, valueOrLabel: "Label")
        self.setUpThirdContainerLabel(winnerPaidTitleLabel, labelText: "Winner Paid", columnNumber: 3, valueOrLabel: "Label")
        self.setUpFourthContainerButtons(fourthContainer)
        self.hardReset()
    }
    
    // IBActions
    
    func resetButtonPressed (button: UIButton) {
        hardReset()
    }
    
    func betOneButtonPressed (button: UIButton) {
        if credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        } else {
            if currentBet < 5 {
                currentBet  += 1
                credits -= 1
                updateMainView()
            } else {
                showAlertWithText(message: "You can only bet 5 credits at a time!")
            }
        }
    }
    
    func betMaxButtonPressed (button: UIButton) {
        if credits < 5 {
            showAlertWithText(header: "Not Enough Credits", message: "Reset Game")
        }
        else {
            if currentBet < 5 {
                while currentBet < 5 {
                    currentBet++
                    credits--
                }
                updateMainView()
            }
            else {
                showAlertWithText(message: "You've already bet the max")
            }   
        }
    }

    func spinButtonPressed (button: UIButton) {
        
        if currentBet == 0 {
            showAlertWithText(header: "Need Bet", message: "Bet at least 1 credit to spin")
        }
        else {
            removeSlotImageViews()
            slots = Factory.createSlots()
            setUpSecondContainer(self.secondContainer)
            var winningsMultiplier = SlotBrain.computeWinnings(slots)
            winnings += (winningsMultiplier * currentBet)
            currentBet = 0
            updateMainView()
            
            if winningsMultiplier == 18 {
                showAlertWithText(header: "+18!", message: "You spun all flushes!")
            }
            
            if winningsMultiplier == 59 {
                showAlertWithText(header: "+59!", message: "You spun all 3-of-a-kind!")
            }
            
            if winningsMultiplier == 1018 {
                showAlertWithText(header: "+1018!", message: "You spun all straights!")
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpContainerViews() {
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginForView*2), height: self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.firstContainer.frame.height, width: self.view.bounds.width - (2 * kMarginForView), height: self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(secondContainer)
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height, width: self.view.bounds.width - (2 * kMarginForView), height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: self.view.bounds.width - (2 * kMarginForView), height: self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
    }
    
    func setUpFirstContainer(containerView: UIView) {
        // Titles the first container
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.font = UIFont(name: "DevanagariSangamMN-Bold", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(self.titleLabel)
    }
    
    func setUpSecondContainer(containerView: UIView) {
        // Creates the 9 slot spaces for each card
                
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber {
            
            for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber {
                
                var slot:Slot
                var slotImageView = UIImageView()
                
                if slots.count != 0 {
                    let slotContainer = slots[containerNumber]
                    slot = slotContainer[slotNumber]
                    slotImageView.image = slot.image
                } else {
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * self.kThird) + self.kMarginForSlot, y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * self.kThird) + self.kMarginForSlot, width: containerView.frame.width * self.kThird - (2*self.kMarginForSlot), height: containerView.frame.height * self.kThird - (2*self.kMarginForSlot))
                
                containerView.addSubview(slotImageView)

            }
        }
    }
    
    func setUpThirdContainerLabel(labelName: UILabel, labelText: String, columnNumber: Int, valueOrLabel: String) {
        
        var font = ""
        var fontSize = 0
        var rowNumber = 0
        
        if valueOrLabel == "Label" {
            font = "AmericanTypewriter"
            fontSize = 14
            rowNumber = 2
        } else if valueOrLabel == "Value" {
            font = "Menlo-Bold"
            fontSize = 16
            rowNumber = 1
        }
        
        labelName.text = labelText
        
        if valueOrLabel == "Value" {
            labelName.textColor = UIColor.redColor()
        } else if valueOrLabel == "Label" {
            labelName.textColor = UIColor.blackColor()
        }
        
        labelName.font = UIFont(name: font, size: CGFloat(fontSize))
        labelName.sizeToFit()
        labelName.center = CGPoint(x: thirdContainer.frame.width * CGFloat(columnNumber * 2 - 1) * kSixth, y: thirdContainer.frame.height * CGFloat(rowNumber) * kThird)
        labelName.textAlignment = NSTextAlignment.Center
        
        thirdContainer.addSubview(labelName)
    }
    
    func setUpFourthContainerButtons(containerView: UIView) {
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEighth, y: containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name:"Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEighth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * 5 * kEighth, y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEighth, y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
    }
    
    func removeSlotImageViews () {
        if self.secondContainer != nil {
            let container:UIView? = self.secondContainer
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset () {
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        self.setUpSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        
        updateMainView()
    }
    
    func updateMainView () {
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertWithText (header : String = "Warning", message : String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

