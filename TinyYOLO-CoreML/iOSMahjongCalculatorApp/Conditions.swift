//
//  Con.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/24/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import Foundation

public enum Wind: Int {
    case east = 10, south, west, north
}

open class Conditions {

    var seat:Wind
    var round:Wind
    fileprivate var tsumo:Bool
    fileprivate var riichi:Bool
    fileprivate var ippatsu:Bool
    fileprivate var lastTileFromWall:Bool
    fileprivate var lastDiscard:Bool
    fileprivate var deadWallDraw:Bool
    fileprivate var robKan:Bool
    fileprivate var doubleRiichi:Bool
    var doraTiles:[Tile]

    //追加しました(手牌にあるドラの枚数)
    var doraCounts:Double
    
    init() {
        seat = Wind.east
        round = Wind.east
        riichi = false
        tsumo = false
        ippatsu = false
        lastTileFromWall = false
        lastDiscard = false
        deadWallDraw = false
        robKan = false
        doubleRiichi = false
        doraTiles = []
        doraCounts=0
    }

    func clearConditions() {
        seat = Wind.east
        round = Wind.east
        riichi = false
        tsumo = false
        ippatsu = false
        lastTileFromWall = false
        lastDiscard = false
        deadWallDraw = false
        robKan = false
        doubleRiichi = false
        doraCounts=0
    }

    func isDealer() -> Bool {
        return seat == .east
    }

    func setSeat(_ wind:Wind) {
        seat = wind
    }

    func getSeat() -> Wind {
        return seat
    }

    func setRound(_ wind:Wind) {
        round = wind
    }

    func getRound() -> Wind {
        return round
    }

    func setRiichi(_ riichi:Bool, hand:Hand) {
        if riichi {
            if (hand.isClosed() || hand.sevenPairs()) {
                self.riichi = riichi
            }
            if (self.riichi && doubleRiichi) {
                doubleRiichi = false
            }
        } else {
            self.riichi = riichi
        }
    }

    func isRiichi() -> Bool {
        return riichi
    }

    func setTsumo(_ tsumo:Bool) {
        self.tsumo = tsumo
    }

    func isTsumo() -> Bool {
        return tsumo
    }

    func setIppatsu(_ ippatsu:Bool) {
        self.ippatsu = ippatsu
    }

    func isIppatsu() -> Bool {
        return ippatsu
    }

    func setLastTileFromWall(_ bool:Bool) {
        lastTileFromWall = bool
    }

    func isLastTileFromWall() -> Bool {
        return lastTileFromWall
    }

    func setLastDiscard(_ bool:Bool) {
        lastDiscard = bool
    }

    func isLastDiscard() -> Bool {
        return lastDiscard
    }

    func setDeadWallDraw(_ bool:Bool) {
        deadWallDraw = bool
    }

    func isDeadWallDraw() -> Bool {
        return deadWallDraw
    }

    func setRobKan(_ kan:Bool) {
        robKan = kan
    }

    func isRobKan() -> Bool {
        return robKan
    }
    
    func setDoraCounts(_ dora:Double) {
        doraCounts = dora
    }
    
    func getDoraCounts() -> Double {
        return doraCounts
    }
    
    func setDoubleRiichi(_ riichi:Bool, hand:Hand) {
        if riichi {
            if (hand.isClosed() || hand.sevenPairs()) {
                doubleRiichi = riichi
            }
            if (self.riichi && doubleRiichi) {
                self.riichi = false
            }
        } else {
            self.doubleRiichi = riichi
        }
    }

    func isDoubleRiichi() -> Bool {
        return doubleRiichi
    }

    func addDoraTile(_ tile:Tile, hand:Hand) {
        if canAddTile(tile, hand: hand) {
            doraTiles.append(tile)
            sortTiles()
        }
    }

    func removeDoraTile(_ index:Int) {
        if doraTiles.count > 0 {
            doraTiles.remove(at: index)
        }
        sortTiles()
    }

    func removeAllDoraTiles() {
        doraTiles.removeAll(keepingCapacity: true)
    }

    func getDoraTiles() -> [Tile] {
        return doraTiles
    }

    func currentTileCount(_ tile:Tile, hand:Hand) -> Int {
        var count:Int = 0
        for i:Int in 0 ..< hand.tiles.count {
            if (hand.tiles[i].isEqual(tile)) {
                count += 1
            }
        }
        for i:Int in 0 ..< doraTiles.count {
            if (doraTiles[i].isEqual(tile)) {
                count += 1
            }
        }
        return count
    }

    func canAddTile(_ tile:Tile, hand:Hand) -> Bool {
        if doraTiles.count > 10 {
            return false
        }

        for i:Int in 0 ..< hand.tiles.count {
            if hand.tiles[i].isEqual(tile) {
                if (hand.tiles[i].status == Status.kan || hand.tiles[i].status == Status.closedKan) {
                    return currentTileCount(tile, hand: hand) < 3
                }
            }
        }

        return currentTileCount(tile, hand: hand) < 4
    }

    func sortTiles() {
        for i:Int in 1 ..< doraTiles.count {
            let tileToSort:Tile = doraTiles[i]
            let newIndex:Int = binarySearch(tileToSort, left: 0, right: i)
            for j:Int in ((newIndex + 1)...i).reversed() {
                doraTiles[j] = doraTiles[j-1]
            }
            doraTiles[newIndex] = tileToSort
        }
    }

    func binarySearch(_ tile:Tile, left:Int, right:Int) -> Int {
        if (right < left) {
            return left
        }
        
        let mid:Int = (left + right) / 2
        
        if tile.isGreaterThan(doraTiles[mid]) {
            return binarySearch(tile, left: mid+1, right: right)
        } else {
            return binarySearch(tile, left: left, right: mid-1)
        }
    }
}
