//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Kyle Cabigon on 2/4/15.
//  Copyright (c) 2015 Kyle Cabigon. All rights reserved.
//

import Foundation

class SlotBrain {
    
    class func unpackSlotIntoRows (slots: [[Slot]]) -> [[Slot]] {
        var slotRow: [Slot] = []
        var slotRow2: [Slot] = []
        var slotRow3: [Slot] = []
        
        for slotArray in slots {
            for var index = 0; index < slotArray.count; index++ {
                let slot = slotArray[index]
                if index == 0 {
                    slotRow.append(slot)
                }
                else if index == 1 {
                    slotRow2.append(slot)
                }
                else if index == 2 {
                    slotRow3.append(slot)
                }
            }
        }
        var slotsInRows : [[Slot]] = [slotRow, slotRow2, slotRow3]
        
        return slotsInRows
    }
    
    class func computeWinnings (slots : [[Slot]]) -> Int {
        
        var slotsInRows = unpackSlotIntoRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            if checkThree(slotRow) {
                threeOfAKindWinCount += 3
                winnings += 3
            } else if checkStraight(slotRow) {
                straightWinCount += 6
                winnings += 6
            }
            
            
            if checkFlush(slotRow) {
                flushWinCount += 1
                winnings += 1
            }
        
        }
        
        if flushWinCount == 3 {
            winnings += 15
        }
        
        if straightWinCount == 3 {
            winnings += 1000
        }
        
        if threeOfAKindWinCount == 3 {
            winnings += 50
        }
        
        return winnings
    }
    
    class func checkFlush (slotRow:[Slot]) -> Bool {
        
        var redCount  = 0
        var blackCount = 0
        
        for card in slotRow {
            if card.isRed == true {
                redCount++
            } else {
                blackCount++
            }
        }
        
        if redCount == slotRow.count || blackCount == slotRow.count{
            return true
        } else {
            return false
        }
    }
    
    class func checkThree (slotRow:[Slot]) -> Bool {
        
        if slotRow[0].value == slotRow[1].value {
            if slotRow[1].value == slotRow[2].value {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func checkStraight (slotRow:[Slot]) -> Bool {
        
        if (slotRow[0].value + 1) == slotRow[1].value {
            if (slotRow[1].value + 1) == slotRow[2].value {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
}