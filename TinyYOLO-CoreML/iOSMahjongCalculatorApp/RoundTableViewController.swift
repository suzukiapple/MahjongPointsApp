//
//  RoundTableViewController.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 1/5/15.
//  Copyright (c) 2015 Oliver Zhang. All rights reserved.
//

import UIKit

class RoundTableViewController: UITableViewController {

    var rounds:[String]!
    var selectedRound:String? = nil
    var selectedRoundIndex:Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        rounds = ["East",
            "South",
            "West",
            "North"]
        if let round = selectedRound {
            selectedRoundIndex = rounds.index(of: round)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }

    // Loads table into view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoundCell", for: indexPath) 
        cell.textLabel?.text = rounds[indexPath.row]

        if indexPath.row == selectedRoundIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    // Changes round to that selected on screen
    // Adapted from: http://www.raywenderlich.com/81880/storyboards-tutorial-swift-part-2
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //Other row is selected - need to deselect it
        if let index = selectedRoundIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }

        selectedRoundIndex = indexPath.row
        selectedRound = rounds[indexPath.row]
        
        //Update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    // Saves the round selected and returns to the conditions controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedRound" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            selectedRoundIndex = indexPath?.row
            if let index = selectedRoundIndex {
                selectedRound = rounds[index]
            }
        }
    }
}
