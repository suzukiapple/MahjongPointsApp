//
//  ConditionsViewController.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/31/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import UIKit

class ConditionsViewController: UITableViewController {

    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var calculateButton: UIBarButtonItem!
    @IBOutlet weak var RiichiSwitch: UISwitch!
    @IBOutlet weak var DoubleRiichiSwitch: UISwitch!

    var winningHand:Hand!

    // Load default conditions of hand, load pre-conditions
    override func viewDidLoad() {
        super.viewDidLoad()

        winningHand.conditions.clearConditions()
        roundLabel.text = "East"
        seatLabel.text = "East"
        RiichiSwitch.isEnabled = winningHand.isClosed()
        DoubleRiichiSwitch.isEnabled = winningHand.isClosed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Move back to dora tiles controller to reselect dora tiles
        if segue.identifier == "BackDora" {
            let doraController = segue.destination as! DoraTilesViewController
            doraController.winningHand = winningHand
        }

        // Reset to tile select view controller, resetting hand in the process
        else if segue.identifier == "Reset" {
            let tilesController = segue.destination as! TilesViewController
            SharedAll.sharedInstance.winningHand.removeAllTiles()
            SharedAll.sharedInstance.winningHand.conditions.removeAllDoraTiles()
            //SharedAll.sharedInstance.updateHandImage()
        }
    }

    // Alters conditions of hand depending on switch that is activated
    @IBAction func tapSwitch(_ sender:UISwitch) {

        if let switchName:String = sender.accessibilityLabel {
            switch switchName {
            case "Riichi":
                winningHand.conditions.setRiichi(sender.isOn, hand: winningHand)
                DoubleRiichiSwitch.setOn(false, animated:true)
                break
            case "Ippatsu":
                winningHand.conditions.setIppatsu(sender.isOn)
                break
            case "LastTileFromWall":
                winningHand.conditions.setLastTileFromWall(sender.isOn)
                break
            case "LastDiscard":
                winningHand.conditions.setLastDiscard(sender.isOn)
                break
            case "DeadWall":
                winningHand.conditions.setDeadWallDraw(sender.isOn)
                break
            case "KanRobbed":
                winningHand.conditions.setRobKan(sender.isOn)
                break
            case "DoubleRiichi":
                winningHand.conditions.setDoubleRiichi(sender.isOn, hand: winningHand)
                RiichiSwitch.setOn(false, animated:true)
                break
            case "Tsumo":
                winningHand.conditions.setTsumo(sender.isOn)
            default:
                break
            }
        }
    }

    // Pulls up Table View Controller to select round
    @IBAction func selectedRound(_ segue:UIStoryboardSegue) {
        let roundPickerViewController = segue.source as! RoundTableViewController
        if let selectedRound = roundPickerViewController.selectedRound {
            switch selectedRound {
            case "East":
                roundLabel.text = "East"
                winningHand.conditions.setRound(Wind.east)
                break
            case "South":
                roundLabel.text = "South"
                winningHand.conditions.setRound(Wind.south)
                break
            case "West":
                roundLabel.text = "West"
                winningHand.conditions.setRound(Wind.west)
                break
            case "North":
                roundLabel.text = "North"
                winningHand.conditions.setRound(Wind.north)
                break
            default:
                roundLabel.text = "Null"
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    // Pulls up Table View Controller to select seat
    @IBAction func selectedSeat(_ segue:UIStoryboardSegue) {
        let seatPickerViewController = segue.source as! SeatTableViewController
        if let selectedSeat = seatPickerViewController.selectedSeat {
            switch selectedSeat {
            case "East":
                seatLabel.text = "East"
                winningHand.conditions.setSeat(Wind.east)
                break
            case "South":
                seatLabel.text = "South"
                winningHand.conditions.setSeat(Wind.south)
                break
            case "West":
                seatLabel.text = "West"
                winningHand.conditions.setSeat(Wind.west)
                break
            case "North":
                seatLabel.text = "North"
                winningHand.conditions.setSeat(Wind.north)
                break
            default:
                seatLabel.text = "Null"
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    // Calculates points of the winning hand when calculate button is pressed
    @IBAction func calculate() {
        let score = winningHand.calculateScore()
        var alertController:UIAlertController
        
        if winningHand.han == 0 {
            alertController = UIAlertController(title: "Chombo!",
                message: "Invalid hand: Player must pay chombo penalty.",
                preferredStyle: .alert)
        } else {
            alertController = UIAlertController(
                title: "Han: \(winningHand.han), Fu: \(winningHand.fu)",
                message: "\(winningHand.displayYakuDictionary()) \n" +
                    "Winner: \(score.winner) \nPlayer 2: \(score.other1) \n" +
                    "Player 3: \(score.other2) \nPlayer 4: \(score.other3) \n",
                preferredStyle: .alert)
        }

        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        func resetToStart(_ action:UIAlertAction!) {
            performSegue(withIdentifier: "Reset", sender: action)
        }

        let resetAction = UIAlertAction (title: "Reset", style: .cancel, handler: resetToStart)
        alertController.addAction(resetAction)

        present(alertController, animated: true, completion: nil)
    }
}
