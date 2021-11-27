//
//  SeatTableViewController.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 1/5/15.
//  Copyright (c) 2015 Oliver Zhang. All rights reserved.
//

import UIKit

class SeatTableViewController: UITableViewController {

    var seats:[String]!
    var selectedSeat:String? = nil
    var selectedSeatIndex:Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        seats = ["East",
            "South",
            "West",
            "North"]
        if let seat = selectedSeat {
            //selectedSeatIndex = find(seats, seat)!
            selectedSeatIndex = seats.index(of: seat)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seats.count
    }

    // Loads table into view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeatCell", for: indexPath) 
        cell.textLabel?.text = seats[indexPath.row]
        
        if indexPath.row == selectedSeatIndex {
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
        if let index = selectedSeatIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }

        selectedSeatIndex = indexPath.row
        selectedSeat = seats[indexPath.row]

        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    // Saves the round selected and returns to the conditions controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedSeat" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            selectedSeatIndex = indexPath?.row
            if let index = selectedSeatIndex {
                selectedSeat = seats[index]
            }
        }
    }
}
