//
//  Tile.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/13/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import Foundation

public enum Suit: Int {
    case wan = 1, pin, sou, wind, dragon
}

public enum Value: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine
    case east = 10, south, west, north
    case white = 14, green, red
}

public enum Status: Int {
    case chi = 1, pon, kan, closedKan, none
}

open class Tile {

    var value:Value
    var suit:Suit
    var status:Status
    var wait:Bool

    init(value:Value, suit:Suit) {
        self.value = value
        self.suit = suit
        self.status = Status.none
        self.wait = false
    }

    func getRawValue() -> Int {
        return suit.rawValue*10 + value.rawValue
    }

    func isEqual(_ other:Tile) -> Bool {
        return getRawValue() == other.getRawValue()
    }

    func isEqualValueOnly(_ other:Tile) -> Bool {
        return value == other.value && suit != other.suit
    }

    func isGreaterThan(_ other:Tile) -> Bool {
        return getRawValue() + status.rawValue*100 > other.getRawValue() + other.status.rawValue*100
    }

    func isOneValueGreaterThan(_ other:Tile) -> Bool {
        return value.rawValue + 1 == other.value.rawValue
    }

    func isSameSuit(_ other:Tile) -> Bool {
        return suit == other.suit
    }

    func hasSameStatus(_ other:Tile) -> Bool {
        return status == other.status
    }

    func isTerminal() -> Bool {
        return value == Value.one || value == Value.nine
    }

    func isHonor() -> Bool {
        return suit == Suit.wind || suit == Suit.dragon
    }

    func isTerminalOrHonor() -> Bool {
        return isTerminal() || isHonor() 
    }

    func isDragon() -> Bool {
        return suit == Suit.dragon
    }

    func isCorrectWind(_ wind1:Wind) -> Bool {
        return (value.rawValue == wind1.rawValue)
    }

    func setStatus(_ status:Status) {
        self.status = status
    }

    func setWait(_ bool:Bool) {
        self.wait = bool
    }

}
