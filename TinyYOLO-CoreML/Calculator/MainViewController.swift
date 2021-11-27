//
//  MainViewController.swift
//  TinyYOLO-CoreML
//
//  Created by RYO SUZUKI on 2017/12/23.
//  Copyright © 2017年 MachineThink. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var paiView1: UIImageView!
    @IBOutlet weak var paiView2: UIImageView!
    @IBOutlet weak var paiView3: UIImageView!
    @IBOutlet weak var paiView4: UIImageView!
    @IBOutlet weak var paiView5: UIImageView!
    @IBOutlet weak var paiView6: UIImageView!
    @IBOutlet weak var paiView7: UIImageView!
    @IBOutlet weak var paiView8: UIImageView!
    @IBOutlet weak var paiView9: UIImageView!
    @IBOutlet weak var paiView10: UIImageView!
    @IBOutlet weak var paiView11: UIImageView!
    @IBOutlet weak var paiView12: UIImageView!
    @IBOutlet weak var paiView13: UIImageView!
    @IBOutlet weak var paiView14: UIImageView!
    
    @IBOutlet weak var riichiSwitch: UISwitch!
    @IBOutlet weak var doubleRiichiSwitch: UISwitch!
    @IBOutlet weak var ippatsuSwitch: UISwitch!
    @IBOutlet weak var tsumoSwitch: UISwitch!
    @IBOutlet weak var haiteiSwitch: UISwitch!
    @IBOutlet weak var rinshanSwitch: UISwitch!
    @IBOutlet weak var chankanSwitch: UISwitch!
    
    
    @IBOutlet weak var doraCounterLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var detailScoreLabel: UILabel!
    @IBOutlet weak var yakuLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //牌画像表示
        let clearimage=UIImage(named: "clear.png")
        paiView1.image=clearimage
        paiView2.image=clearimage
        paiView3.image=clearimage
        paiView4.image=clearimage
        paiView5.image=clearimage
        paiView6.image=clearimage
        paiView7.image=clearimage
        paiView8.image=clearimage
        paiView9.image=clearimage
        paiView10.image=clearimage
        paiView11.image=clearimage
        paiView12.image=clearimage
        paiView13.image=clearimage
        paiView14.image=clearimage
        for i in 0..<SharedAll.sharedInstance.winningHand.tiles.count {
            let tile = SharedAll.sharedInstance.winningHand.tiles[i]
            let key = "\(tile.getRawValue())"
            if let paiimage = imageDictionary[key] {
                switch i {
                    case 0: paiView1.image=paiimage
                    case 1: paiView2.image=paiimage
                    case 2: paiView3.image=paiimage
                    case 3: paiView4.image=paiimage
                    case 4: paiView5.image=paiimage
                    case 5: paiView6.image=paiimage
                    case 6: paiView7.image=paiimage
                    case 7: paiView8.image=paiimage
                    case 8: paiView9.image=paiimage
                    case 9: paiView10.image=paiimage
                    case 10: paiView11.image=paiimage
                    case 11: paiView12.image=paiimage
                    case 12: paiView13.image=paiimage
                    case 13: paiView14.image=paiimage
                    default:break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableview

    // Changes round to that selected on screen
    // Adapted from: http://www.raywenderlich.com/81880/storyboards-tutorial-swift-part-2
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section==0 && indexPath.row==1 {
            performSegue(withIdentifier: "YOLO", sender: self)
        }else if indexPath.section==0 && indexPath.row==2{
            performSegue(withIdentifier: "EditHands", sender: self)
        }else if indexPath.section==3 && indexPath.row==0 {
            if SharedAll.sharedInstance.winningHand.tiles.count != 14 {
                let alertController = UIAlertController(
                    title: "あれ？",
                    message: "手牌の枚数が正しくないよ",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "ごめんね", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
                return
            }
            calculate()
        }
    }
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    */

    
    //switch
    @IBAction func tapRiichiSwitch(sender:UISwitch) {
        doubleRiichiSwitch.setOn(false, animated:true)
        if !riichiSwitch.isOn && !doubleRiichiSwitch.isOn && ippatsuSwitch.isOn {
            ippatsuSwitch.setOn(false, animated:true)
        }
        updateWinningHandCondition()
    }
    @IBAction func tapDoubleRiichi(sender:UISwitch) {
        riichiSwitch.setOn(false, animated:true)
        if !riichiSwitch.isOn && !doubleRiichiSwitch.isOn && ippatsuSwitch.isOn {
            ippatsuSwitch.setOn(false, animated:true)
        }
        updateWinningHandCondition()
    }
    @IBAction func tapIppatsuSwitch(sender:UISwitch) {
        if !riichiSwitch.isOn && !doubleRiichiSwitch.isOn && ippatsuSwitch.isOn {
            riichiSwitch.setOn(true, animated:true)
        }
        updateWinningHandCondition()
    }

    @IBAction func updateWinningHandCondition(){
        SharedAll.sharedInstance.winningHand.conditions.setRiichi(riichiSwitch.isOn, hand: SharedAll.sharedInstance.winningHand)
        SharedAll.sharedInstance.winningHand.conditions.setDoubleRiichi(doubleRiichiSwitch.isOn, hand: SharedAll.sharedInstance.winningHand)
        SharedAll.sharedInstance.winningHand.conditions.setIppatsu(ippatsuSwitch.isOn)
        SharedAll.sharedInstance.winningHand.conditions.setTsumo(tsumoSwitch.isOn)
        SharedAll.sharedInstance.winningHand.conditions.setLastTileFromWall(haiteiSwitch.isOn)
        SharedAll.sharedInstance.winningHand.conditions.setDeadWallDraw(rinshanSwitch.isOn)
        SharedAll.sharedInstance.winningHand.conditions.setRobKan(chankanSwitch.isOn)
    }
    
    @IBAction func tapDoraStepper(sender: UIStepper) {
        doraCounterLabel.text=String(format: "%.0f", sender.value)
        SharedAll.sharedInstance.winningHand.conditions.setDoraCounts(sender.value)
    }
    
    //stepper
    @IBAction func tapRoundSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            SharedAll.sharedInstance.winningHand.conditions.setRound(Wind.east)
        case 1:
            SharedAll.sharedInstance.winningHand.conditions.setRound(Wind.south)
        case 2:
            SharedAll.sharedInstance.winningHand.conditions.setRound(Wind.west)
        case 3:
            SharedAll.sharedInstance.winningHand.conditions.setRound(Wind.north)
        default:
            break
        }
    }

    @IBAction func tapSeatSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            SharedAll.sharedInstance.winningHand.conditions.setSeat(Wind.east)
        case 1:
            SharedAll.sharedInstance.winningHand.conditions.setSeat(Wind.south)
        case 2:
            SharedAll.sharedInstance.winningHand.conditions.setSeat(Wind.west)
        case 3:
            SharedAll.sharedInstance.winningHand.conditions.setSeat(Wind.north)
        default:
            break
        }
    }
    
    //
    func calculate() {
        let score = SharedAll.sharedInstance.winningHand.calculateScore()
        if SharedAll.sharedInstance.winningHand.han == 0 {
            var alertController:UIAlertController
            alertController = UIAlertController(title: "Chombo!",
                                                message: "Invalid hand: Player must pay chombo penalty.",
                                                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        /*
            alertController = UIAlertController(
                title: "Han: \(SharedAll.sharedInstance.winningHand.han), Fu: \(SharedAll.sharedInstance.winningHand.fu)",
                message: "\(SharedAll.sharedInstance.winningHand.displayDictionary()) \n" +
                    "Winner: \(score.winner) \nPlayer 2: \(score.other1) \n" +
                "Player 3: \(score.other2) \nPlayer 4: \(score.other3) \n",
                preferredStyle: .alert)
        */
        scoreLabel.text="\(String(format: "%.0f",SharedAll.sharedInstance.winningHand.han))飜\(String(format: "%.0f",SharedAll.sharedInstance.winningHand.fu))符 \(String(format: "%.0f",score.winner))点"
        if SharedAll.sharedInstance.winningHand.conditions.isTsumo() {
            if SharedAll.sharedInstance.winningHand.conditions.getSeat()==Wind.east {
                detailScoreLabel.text="子：\(String(format: "%.0f",-1*score.other1))点"
            }else{
                detailScoreLabel.text="親：\(String(format: "%.0f",-1*score.other1))点 子：\(String(format: "%.0f",-1*score.other2))点"
            }
        }else{
            detailScoreLabel.text="放銃者：\(String(format: "%.0f",score.winner))点"
        }
        yakuLabel.text=SharedAll.sharedInstance.winningHand.displayYakuDictionary()

    }
}
