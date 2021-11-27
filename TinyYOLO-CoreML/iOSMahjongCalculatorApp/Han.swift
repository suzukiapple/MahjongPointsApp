//
//  Han.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/16/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import Foundation

open class Han {
    var yakumanCount:Double
    var count:Double
    var wh:Hand

    init(wh:Hand) {
        self.yakumanCount = 0
        self.count = 0
        self.wh = wh
    }

    func calculateHan() -> (han: Double, yakumanCount: Double) {
        self.count = 0
        if wh.sevenPairs() {
            self.count += 2
            wh.dictionary["Seven pairs"] = 2
            calculateOtherHanSevenPairs()
            return (self.count, self.yakumanCount)
        }
        calculateHanSequence()
        calculateHanTriplets()
        calculateHanTerminals()
        calculateHanSuit()
        calculateHanLuck()
        return (self.count, self.yakumanCount)
    }

    func calculateHanLuck() {

        func calculateDora() {
            if count == 0 {
                return
            }

            var tilesToCheck:[Tile] = []

            for tile in wh.conditions.doraTiles {
                if (tile.value == Value.nine) {
                    let tile = Tile(value: Value.one, suit: tile.suit)
                    tilesToCheck.append(tile)
                } else if (tile.value == Value.north) {
                    let tile = Tile(value: Value.east, suit: tile.suit)
                    tilesToCheck.append(tile)
                } else if (tile.value == Value.red) {
                    let tile = Tile(value: Value.white, suit: tile.suit)
                    tilesToCheck.append(tile)
                } else {
                    let tile = Tile(value: Value(rawValue: tile.value.rawValue + 1)!, suit: tile.suit)
                    tilesToCheck.append(tile)
                }
            }

            var i:Double = 0
            for tileTC in tilesToCheck {
                for tileWH in wh.tiles {
                    if tileTC.isEqual(tileWH) {
                        i += 1
                    }
                }
            }

            if i > 0 {
                count += i
                wh.dictionary["Dora"] = i
            }
        }

        if wh.conditions.isRiichi() {
            count += 1
            wh.dictionary["Riichi"] = 1
        }
        if wh.conditions.isIppatsu() {
            count += 1
            wh.dictionary["Ippatsu"] = 1
        }
        if wh.conditions.isLastTileFromWall() {
            count += 1
            wh.dictionary["Last tile from the wall"] = 1
        }
        if wh.conditions.isLastDiscard() {
            count += 1
            wh.dictionary["Last discard"] = 1
        }
        if wh.conditions.isDeadWallDraw() {
            count += 1
            wh.dictionary["Dead wall draw"] = 1
        }
        if wh.conditions.isRobKan() {
            count += 1
            wh.dictionary["Kan robbed"] = 1
        }
        if wh.conditions.isDoubleRiichi() {
            count += 2
            wh.dictionary["Double riichi"] = 2
        }
        if wh.isClosed() && wh.conditions.isTsumo() {
            count += 1
            wh.dictionary["Closed tsumo"] = 1
        }

        //calculateDora()
        if wh.conditions.doraCounts>0 {
            count += wh.conditions.doraCounts
            wh.dictionary["Dora"] = wh.conditions.doraCounts
        }
    }

    func calculateHanSequence() {
        var melds:[Meld] = []
        for meld in wh.melds {
            if (meld.isSequence()) {
                melds.append(meld)
            }
        }

        if melds.count < 3 {
            return
        }

        func allSequence() {
            if (wh.isClosed() && (melds.count == 4)) {
                count += 1
                wh.dictionary["All sequence"] = 1
            }
        }

        func doubleSequence() {

            func doubleDoubleSequence(_ i:Int, j:Int) {
                if melds.count < 4 {
                    wh.dictionary["One set of identical sequences"] = 1
                    return
                }

                var otherMelds:[Meld] = []
                for k in 0...(melds.count - 1) {
                    if k != i && k != j {
                        otherMelds.append(melds[k])
                    }
                }

                if otherMelds[0].isEqual(otherMelds[1]) {
                    count += 2
                    wh.dictionary["Two sets of identical sequences"] = 3
                } else {
                    wh.dictionary["One set of identical sequences"] = 1
                }
            }

            if !wh.isClosed() {
                return
            }

            for i in 0...(melds.count - 2){
                if melds[i].isEqual(melds[i+1]) {
                    count += 1
                    doubleDoubleSequence(i,j: i+1)
                    return
                }
            }
        }

        func straight() {
            var pinAcc = 0
            var souAcc = 0
            var wanAcc = 0

            for i in 1...9 {
                if wh.containsTile(Tile(value: Value(rawValue: i)!, suit: Suit.pin)) {
                    pinAcc += 1
                }
                if wh.containsTile(Tile(value: Value(rawValue: i)!, suit: Suit.sou)) {
                    souAcc += 1
                }
                if wh.containsTile(Tile(value: Value(rawValue: i)!, suit: Suit.wan)) {
                    wanAcc += 1
                }
            }

            if (pinAcc == 9 || souAcc == 9 || wanAcc == 9) {
                var i:Double = 1
                if wh.isClosed() {
                    i += 1
                }
                count += i
                wh.dictionary["Straight"] = i
            }
        }

        func colourStraight() {
            let meldAcc1 = melds[0]
            let meldAcc2 = melds[1]
            var meldAcc3 = 0
            var meldAcc4 = 0

            for meld in melds {
                if (meld.tile1.isEqualValueOnly(meldAcc1.tile1)) {
                    meldAcc3 += 1
                }
                if (meld.tile1.isEqualValueOnly(meldAcc2.tile1)) {
                    meldAcc4 += 1
                }
            }
            if (meldAcc3 >= 2 || meldAcc4 >= 2) {
                var i:Double = 1
                if wh.isClosed() {
                    i += 1
                }
                count += i
                wh.dictionary["Three colour straight"] = i
            }
        }

        allSequence()
        doubleSequence()
        straight()
        colourStraight()
    }

    func calculateHanTriplets() {
        var melds:[Meld] = []
        for meld in wh.melds {
            if meld.isTriplet() {
                melds.append(meld)
            }
        }
        if melds.count <= 2 {
            return
        }

        var kanAcc = 0
        var closedAcc = 0
        var value1Acc = 0
        var value2Acc = 0
        let tile1 = melds[0].tile1
        let tile2 = melds[1].tile1

        for meld in melds {
            if (meld.isKan()) { kanAcc += 1 }
            if (meld.isClosed() && (!meld.containsWait() || wh.conditions.isTsumo())) { closedAcc += 1 }
            if (meld.tile1.isEqualValueOnly(tile1)) { value1Acc += 1 }
            if (meld.tile1.isEqualValueOnly(tile2)) { value2Acc += 1 }
        }

        if kanAcc >= 3 {
            count += 2
            wh.dictionary["Three kans"] = 2
        }
        if closedAcc >= 3 {
            count += 2
            wh.dictionary["Three closed triplets or kans"] = 2
        }
        if value1Acc >= 2 || value2Acc >= 2 {
            count += 2
            wh.dictionary["Three colour triplets or kans"] = 2
        }
        if melds.count == 4 {
            count += 2
            wh.dictionary["All triplets or kans"] = 2
        }
    }

    func calculateHanTerminals() {
        func allTerminalAndHonor() {
            for meld in wh.melds {
                if !(meld.tile1.isTerminalOrHonor() && meld.tile2.isTerminalOrHonor() &&
                    meld.tile3.isTerminalOrHonor()) {
                        return
                }
            }
            if wh.pair.tile1.isTerminal() {
                count += 2
                wh.dictionary["All terminals and honours"] = 2
            }
        }

        func allNonTerminalOrHonor() {
            for meld in wh.melds {
                if (meld.tile1.isTerminalOrHonor() || meld.tile2.isTerminalOrHonor() ||
                    meld.tile3.isTerminalOrHonor()) {
                        return
                }
            }
            if !wh.pair.tile1.isTerminalOrHonor() {
                count += 1
                wh.dictionary["All simples"] = 1
            }
        }

        func honourTriplets() {
            var honour:Double = 0
            var dragonAcc:Double = 0

            for meld in wh.melds {
                if (meld.isTriplet()) &&
                    ((meld.tile1.isCorrectWind(wh.conditions.seat))) {
                    honour += 1
                }
                if (meld.isTriplet()) &&
                    ((meld.tile1.isCorrectWind(wh.conditions.round))) {
                        honour += 1
                }
                if meld.isTriplet() && (meld.tile1.isDragon()) {
                    honour += 1
                    dragonAcc += 1
                }
            }

            if honour > 0 {
                count += honour
                wh.dictionary["Honour tiles"] = honour
            }

            if (dragonAcc == 2) && ((wh.pair.tile1.isDragon())) {
                count += 2
                wh.dictionary["Little dragons"] = 2
            }
        }

        func terminalOrHonorInEachSet() {
            if !(wh.pair.tile1.isTerminalOrHonor()) {
                return
            }
            for meld in wh.melds {
                if !(meld.tile1.isTerminalOrHonor() || meld.tile3.isTerminalOrHonor()) {
                    return
                }
            }

            var i:Double = 0
            if wh.isClosed() {
                i += 1
            }
            for meld in wh.melds {
                if !(meld.tile1.isTerminal() || meld.tile3.isTerminal()) {
                    i += 1
                    count += i
                    wh.dictionary["Terminal or honor in each set"] = i
                    return
                }
            }
            if !(wh.pair.tile1.isTerminal()) {
                i += 1
                count += i
                wh.dictionary["Terminal or honor in each set"] = i
            }
            else {
                i += 2
                count += i
                wh.dictionary["Terminal in each set"] = i
            }
        }

        allTerminalAndHonor()
        allNonTerminalOrHonor()
        honourTriplets()
        terminalOrHonorInEachSet()
    }

    func calculateHanSuit() {
        let acc = wh.tiles[0].suit
        for tile in wh.tiles {
            if !(tile.suit == acc) && !(tile.isHonor()) {
                return
            }
        }

        var i:Double = 0
        if (wh.isClosed()) {
            i += 1
        }

        for tile in wh.tiles {
            if !(tile.suit == acc) {
                i += 2
                count += i
                wh.dictionary["Half-flush"] = i
                return
            }
        }

        i += 5
        count += i
        wh.dictionary["Flush"] = i
    }

    func calculateOtherHanSevenPairs() {
        func sevenPairsAllTerminalAndHonor() {
            for tile in wh.tiles {
                if !(tile.isTerminalOrHonor()) {
                    return
                }
            }

            count += 2
            wh.dictionary["All terminals and honours"] = 2
        }

        func sevenPairsAllNonTerminalOrHonor() {
            for tile in wh.tiles {
                if (tile.isTerminalOrHonor()) {
                    return
                }
            }

            count += 1
            wh.dictionary["All simples"] = 1
        }

        calculateHanSuit()
        calculateHanLuck()
        sevenPairsAllTerminalAndHonor()
        sevenPairsAllNonTerminalOrHonor()
    }
}
