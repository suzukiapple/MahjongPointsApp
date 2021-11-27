//
//  TilesViewController.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/31/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import UIKit

class TilesViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var ClearButton: UIButton!
    //@IBOutlet weak var NextButton: UIBarButtonItem!
    @IBOutlet weak var HandImages: UIImageView!
    @IBOutlet weak var ChiButton: UIButton!
    @IBOutlet weak var PonButton: UIButton!
    @IBOutlet weak var KanButton: UIButton!
    @IBOutlet weak var ClosedKanButton: UIButton!

    //var winningHand:Hand!
    var values = lookUp
    var images = imageDictionary
    var status = Status.none

    override func viewDidLoad() {
        super.viewDidLoad()
        //winningHand = Hand()
        HandImages.isUserInteractionEnabled = true
        setButtonColors()
        updateHandImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Move on to dora tiles only when 14 tiles are selected and that the tiles
        // selected form a valid hand
        if segue.identifier == "NextDora" {
            if SharedAll.sharedInstance.winningHand.isValid() {
                //let doraController = segue.destination as! DoraTilesViewController
                //doraController.winningHand = winningHand
                //doraController.updateHandImage()
            } else {
                let alertController = UIAlertController(title: "Invalid hand", message:
                    "Please input a valid hand.", preferredStyle: .alert)

                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)

                present(alertController, animated: true, completion: nil)
            }
        }
    }

    func gestureRecognizer( _: UIGestureRecognizer,
        _ shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }

    // When image tapped, add tile to winning hand and display image
    // on bottom of screen
    @IBAction func tileTapped(_ sender:UIButton) {
        if let message:String = sender.accessibilityLabel {
            if let (value, suit) = values[message] {
                let tile:Tile = Tile(value: value, suit: suit)
                if status == .none {
                    SharedAll.sharedInstance.winningHand.addTile(tile)
                    status = .none
                } else {
                    SharedAll.sharedInstance.winningHand.addMeld(tile, status:status)
                    status = .none
                }
                updateHandImage()
                setButtonColors()
            }
        }
    }

    @IBAction func chiTapped(_ sender: UIButton) {
        status = (status != .chi) ? .chi : .none
        setButtonColors()
    }

    @IBAction func ponTapped(_ sender: UIButton) {
        status = (status != .pon) ? .pon : .none
        setButtonColors()
    }

    @IBAction func kanTapped(_ sender: UIButton) {
        status = (status != .kan) ? .kan : .none
        setButtonColors()
    }

    @IBAction func closedKanTapped(_ sender: UIButton) {
        status = (status != .closedKan) ? .closedKan : .none
        setButtonColors()
    }

    func setButtonColors() {
        if status == .chi {
            ChiButton.setTitleColor(UIColor.purple, for: UIControlState())
        } else {
            ChiButton.setTitleColor(UIColor.blue, for: UIControlState())
        }

        if status == .pon {
            PonButton.setTitleColor(UIColor.purple, for: UIControlState())
        } else {
            PonButton.setTitleColor(UIColor.blue, for: UIControlState())
        }

        if status == .kan {
            KanButton.setTitleColor(UIColor.purple, for: UIControlState())
        } else {
            KanButton.setTitleColor(UIColor.blue, for: UIControlState())
        }

        if status == .closedKan {
            ClosedKanButton.setTitleColor(UIColor.purple, for: UIControlState())
        } else {
            ClosedKanButton.setTitleColor(UIColor.blue, for: UIControlState())
        }
    }

    // When clear button is tapped, remove all dora tiles from hand
    @IBAction func clearTapped(_ button:UIButton) {
        SharedAll.sharedInstance.winningHand.removeAllTiles()
        clearAllSubViews()
        status = Status.none
        setButtonColors()
    }

    // Dismisses view controller to return to this controller
    @IBAction func cancelToTilesViewController(_ segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    func getSecondaryImage(_ tile:Tile) -> UIImage {
        if tile.wait {
            return UIImage(named: "RedDot.png")!
        }

        switch tile.status {
        case Status.chi:
            return UIImage(named: "C.png")!
        case Status.pon:
            return UIImage(named: "P.png")!
        case Status.kan:
            return UIImage(named: "K.png")!
        case Status.closedKan:
            return UIImage(named: "CK.png")!
        default:
            return UIImage(named: "Default.png")!
        }
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
        let xImageOffset:Double = screenWidth/1600
        let yImageOffset:Double = screenHeight/400

        // Some constants about the size of the image to be created
        let imageWidth:Double = screenWidth/9.14
        let imageHeight:Double = screenHeight/12.62

        // Adds an image of each tile at a specific location, based on the number
        // of tiles in the hand
        for index:Int in 0 ..< SharedAll.sharedInstance.winningHand.tiles.count {
            // Get where the tile is supposed to be relative to other tiles
            let xRelIndex:Double = Double(index%7)
            let yRelIndex:Double = Double(index/7)

            // Define the centre of the image to be created
            let xImageCenter:Double = screenWidth/14.72 + xOffset*xRelIndex
            let yImageCenter:Double = screenHeight/16.22 + yOffset*yRelIndex

            // Get the tile from the hand
            let tile = SharedAll.sharedInstance.winningHand.tiles[index]
            let key = "\(tile.getRawValue())"

            if let image = imageDictionary[key] {
                // Get the image from the dictionary, and create the image
                let newImage = rescaleImage(image!, width: imageWidth, height: imageHeight)
                
                let imageView = UIImageView(image: newImage)
                imageView.center = CGPoint(x: xImageCenter, y: yImageCenter)
                imageView.isUserInteractionEnabled = true

                // Add tap handler to listen for deletes
                let recognizer = UITapGestureRecognizer(target: self, action:#selector(TilesViewController.handTileTapped(_:)))
                recognizer.delegate = self
                imageView.addGestureRecognizer(recognizer)
                imageView.accessibilityLabel = "\(index)"

                HandImages.addSubview(imageView)

                if tile.wait || tile.status != Status.none {
                    // Add red dot above tile to represent a wait
                    let image = getSecondaryImage(tile)
                    let view = UIImageView(image: image)

                    let xCenter:Double = screenWidth/29 + xImageOffset*xRelIndex
                    let yCenter:Double = yImageOffset*yRelIndex - screenHeight/37.87

                    view.frame = CGRect(x:xCenter, y:yCenter, width: 12, height: 12)

                    imageView.addSubview(view)
                }
            }
        }
    }

    // Clear all images of the tiles in hand added from the view
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

    // Deletes hand tile when tapped on
    @objc func handTileTapped(_ sender: UITapGestureRecognizer) {
        if let message:String = sender.view?.accessibilityLabel {
            if let index:Int = Int(message) {
                let tile = SharedAll.sharedInstance.winningHand.tiles[index]
                if tile.status == .pon || tile.status == .kan || tile.status == .closedKan {
                   SharedAll.sharedInstance.winningHand.removeAllOfTile(tile)
                } else {
                   SharedAll.sharedInstance.winningHand.removeTileAtIndex(index)
                }
                updateHandImage()
                setButtonColors()
            }
        }
    }
}
