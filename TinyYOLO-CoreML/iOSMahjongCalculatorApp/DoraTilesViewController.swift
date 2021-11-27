//
//  DoraTilesViewController.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/31/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import UIKit

class DoraTilesViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var ClearButton: UIButton!
    @IBOutlet weak var NextButton: UIBarButtonItem!
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBOutlet weak var HandImages: UIImageView!
    
    var winningHand:Hand!
    var values = lookUp
    var images = imageDictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HandImages.isUserInteractionEnabled = true
        updateHandImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Moving forward to the view controller that sets the conditions of the
        // winnning hand, only if there is at least one dora tile
        
        if segue.identifier == "NextConditions" {
            if winningHand.conditions.doraTiles.count < 1 {
                let alertController = UIAlertController(title: "No Dora Tiles", message:
                    "There must be at least one dora tile!", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                let conditionsController = segue.destination as! ConditionsViewController
                conditionsController.winningHand = winningHand
            }
        }
            
        // Moving back to the view controller that selects the tiles of the 
        // winning hand, saving the dora tiles
            
        else if segue.identifier == "BackTiles" {
            let tilesController = segue.destination as! TilesViewController
            SharedAll.sharedInstance.winningHand = winningHand
        }
    }
    
    // When image tapped, add dora tile to winning hand and display image
    // on bottom of screen
    @IBAction func tileTapped(_ sender:UITapGestureRecognizer) {
        if let message:String = sender.view?.accessibilityLabel {
            if let (value, suit) = values[message] {
                let tile:Tile = Tile(value: value, suit: suit)
                winningHand.addDoraTile(tile)
                updateHandImage()
            }
        }
    }
    
    // When clear button is tapped, remove all dora tiles from hand
    @IBAction func clearTapped(_ button:UIButton) {
        winningHand.conditions.removeAllDoraTiles()
        clearAllSubViews()
    }
    
    // Dismisses view controller to return to this controller
    @IBAction func cancelToDoraTilesViewController(_ segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    // Adds images of all tiles of hand at the bottom of the screen iteratively
    func updateHandImage() {
        // Clear all images of the tiles in hand added from the view
        clearAllSubViews()

        // Some constants about the screen size
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth:Double = Double(screenSize.width)
        let screenHeight:Double = Double(screenSize.height)

        // Using screen dimensions to determine x,y offset of first tile from UI view
        let xOffset:Double = screenWidth/7.11
        let yOffset:Double = screenHeight/9
        //let xImageOffset:Double = screenWidth/1600
        //let yImageOffset:Double = screenHeight/400

        // Some constants about the size of the image to be created
        let imageWidth:Double = screenWidth/9.14
        let imageHeight:Double = screenHeight/12.62

        // Adds an image of each tile at a specific location, based on the number
        // of tiles in the hand
        for index:Int in 0 ..< winningHand.conditions.doraTiles.count {
            // Get where the tile is supposed to be relative to other tiles
            let xRelIndex:Double = Double(index%7)
            let yRelIndex:Double = Double(index/7)

            // Define the centre of the image to be created
            let xImageCenter:Double = screenWidth/14.72 + xOffset*xRelIndex
            let yImageCenter:Double = screenHeight/16.22 + yOffset*yRelIndex

            // Get the tile from the hand
            let tile = winningHand.conditions.doraTiles[index]
            let key = "\(tile.getRawValue())"

            if let image = imageDictionary[key] {
                // Get the image from the dictionary, and create the image
                let newImage = rescaleImage(image!, width: imageWidth, height: imageHeight)

                let imageView = UIImageView(image: newImage)
                imageView.center = CGPoint(x: xImageCenter, y: yImageCenter)
                imageView.isUserInteractionEnabled = true

                // Add tap handler to listen for deletes
                let recognizer = UITapGestureRecognizer(target: self, action:#selector(DoraTilesViewController.doraTileTapped(_:)))
                recognizer.delegate = self
                imageView.addGestureRecognizer(recognizer)
                imageView.accessibilityLabel = "\(index)"

                HandImages.addSubview(imageView)
            }
        }
    }
    
    // Clear all images of the dora tiles added from the view
    func clearAllSubViews() {
        for view in HandImages.subviews {
            view.removeFromSuperview()
        }
    }
    
    // Helper function to rescale image to correct size.
    // Adapted from: https://gist.github.com/hcatlin/180e81cd961573e3c54d
    func rescaleImage(_ image: UIImage, width: Double, height: Double) -> UIImage {
        let newSize:CGSize = CGSize(width: width, height: height)
        let rect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)

        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    // Deletes dora tile
    @objc func doraTileTapped(_ sender: UITapGestureRecognizer) {
        if let message:String = sender.view?.accessibilityLabel {
            if let index:Int = Int(message) {
                winningHand.conditions.removeDoraTile(index)
                updateHandImage()
            }
        }
    }
}
