//
//  Fu.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/16/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import Foundation

open class Fu {

    var count:Double
    var wh:Hand

    init(wh:Hand) {
        self.count = 0
        self.wh = wh
    }

    func calculateFu() -> Double {
        self.count = 0
        var pinfu:Bool = false

        func calculateClosedHand() {
            if !(wh.conditions.isTsumo()) {
                for meld in wh.melds {
                    if !(meld.isClosed()) {
                        return
                    }
                }
                count = count + 10
                pinfu = false
                print("closed hand fu +10")
            }
        }

        func calculateFuMelds() {
            for meld in wh.melds {
                if (meld.isTriplet()) {
                    var acc:Double = 2

                    if (meld.isClosed()) { acc = acc*2 }
                    if (meld.isKan()) { acc = acc*4 }
                    if (meld.tile1.isTerminalOrHonor()) { acc = acc*2 }
                    count = count + acc
                    pinfu = false
                    print("triplet fu + \(acc)")
                }
            }
            if (wh.pair.tile1.isDragon()) ||
                (wh.pair.tile1.isCorrectWind(wh.conditions.seat)) ||
                (wh.pair.tile1.isCorrectWind(wh.conditions.round)) {
                    count = count + 2
                    pinfu = false
                    print("wind/dragon fu +2")
            }
        }

        func calculateFuWaits() {
            if (wh.pair.tile1.wait || wh.pair.tile2.wait) {
                print("wait fu +2")
                count = count + 2
                pinfu = false
            }
            else {
                for meld in wh.melds {
                    if (meld.isSequence()) && ((meld.tile2.wait) ||
                        ((meld.tile1.value == Value.seven) && (meld.tile1.wait)) ||
                        ((meld.tile3.value == Value.three) && (meld.tile3.wait))) {
                            count = count + 2
                            pinfu = false
                            print("wait fu +2")
                            return
                    }
                }
            }
        }

        func calculateFuTsumo() {
            if (wh.conditions.isTsumo()) {
                count = count + 2
                pinfu = true
                print("tsumo fu +2")
            }
        }

        func roundFu() {
            if round(count/10)*10 < count/10*10 {
                count = round((count+10)/10)*10
            }
            count = round(count/10)*10
        }

        count = 20
        if wh.sevenPairs() {
            print("sevenPairs fu = 25")
            return 25
        }

        calculateFuTsumo()
        calculateClosedHand()
        calculateFuMelds()
        calculateFuWaits()

        if pinfu {
            count = 20
        } else {
            roundFu()
        }

        return count
    }

}
