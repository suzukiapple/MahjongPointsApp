//
//  Data.swift
//  MyNewProject
//
//  Created by Oliver Zhang on 12/31/14.
//  Copyright (c) 2014 Oliver Zhang. All rights reserved.
//

import Foundation
import UIKit

// Lookup table to associate a description of an image with a tile
let lookUp:Dictionary<String, (value: Value, suit: Suit)> =
[
    "Wan1": (value: Value.one, suit: Suit.wan),
    "Wan2": (value: Value.two, suit: Suit.wan),
    "Wan3": (value: Value.three, suit: Suit.wan),
    "Wan4": (value: Value.four, suit: Suit.wan),
    "Wan5": (value: Value.five, suit: Suit.wan),
    "Wan6": (value: Value.six, suit: Suit.wan),
    "Wan7": (value: Value.seven, suit: Suit.wan),
    "Wan8": (value: Value.eight, suit: Suit.wan),
    "Wan9": (value: Value.nine, suit: Suit.wan),
    "Pin1": (value: Value.one, suit: Suit.pin),
    "Pin2": (value: Value.two, suit: Suit.pin),
    "Pin3": (value: Value.three, suit: Suit.pin),
    "Pin4": (value: Value.four, suit: Suit.pin),
    "Pin5": (value: Value.five, suit: Suit.pin),
    "Pin6": (value: Value.six, suit: Suit.pin),
    "Pin7": (value: Value.seven, suit: Suit.pin),
    "Pin8": (value: Value.eight, suit: Suit.pin),
    "Pin9": (value: Value.nine, suit: Suit.pin),
    "Sou1": (value: Value.one, suit: Suit.sou),
    "Sou2": (value: Value.two, suit: Suit.sou),
    "Sou3": (value: Value.three, suit: Suit.sou),
    "Sou4": (value: Value.four, suit: Suit.sou),
    "Sou5": (value: Value.five, suit: Suit.sou),
    "Sou6": (value: Value.six, suit: Suit.sou),
    "Sou7": (value: Value.seven, suit: Suit.sou),
    "Sou8": (value: Value.eight, suit: Suit.sou),
    "Sou9": (value: Value.nine, suit: Suit.sou),
    "East": (value: Value.east, suit: Suit.wind),
    "South": (value: Value.south, suit: Suit.wind),
    "West": (value: Value.west, suit: Suit.wind),
    "North": (value: Value.north, suit: Suit.wind),
    "Red": (value: Value.red, suit: Suit.dragon),
    "Green": (value: Value.green, suit: Suit.dragon),
    "White": (value: Value.white, suit: Suit.dragon)
]

// Lookup table to associate a tile (in raw value) with an image
// to display on the screen

let imageDictionary =
[
    "11": UIImage(named: "1m.png"),
    "12": UIImage(named: "2m.png"),
    "13": UIImage(named: "3m.png"),
    "14": UIImage(named: "4m.png"),
    "15": UIImage(named: "5m.png"),
    "16": UIImage(named: "6m.png"),
    "17": UIImage(named: "7m.png"),
    "18": UIImage(named: "8m.png"),
    "19": UIImage(named: "9m.png"),
    "21": UIImage(named: "1p.png"),
    "22": UIImage(named: "2p.png"),
    "23": UIImage(named: "3p.png"),
    "24": UIImage(named: "4p.png"),
    "25": UIImage(named: "5p.png"),
    "26": UIImage(named: "6p.png"),
    "27": UIImage(named: "7p.png"),
    "28": UIImage(named: "8p.png"),
    "29": UIImage(named: "9p.png"),
    "31": UIImage(named: "1s.png"),
    "32": UIImage(named: "2s.png"),
    "33": UIImage(named: "3s.png"),
    "34": UIImage(named: "4s.png"),
    "35": UIImage(named: "5s.png"),
    "36": UIImage(named: "6s.png"),
    "37": UIImage(named: "7s.png"),
    "38": UIImage(named: "8s.png"),
    "39": UIImage(named: "9s.png"),
    "64": UIImage(named: "haku.png"),
    "65": UIImage(named: "hatsu.png"),
    "66": UIImage(named: "chun.png"),
    "50": UIImage(named: "east.png"),
    "51": UIImage(named: "south.png"),
    "52": UIImage(named: "west.png"),
    "53": UIImage(named: "north.png")
]

//key:YOLOのClassIndex -> value:
let classIndexDictionary=[
    "0": "Wan1",
    "1": "Wan2",
    "2": "Wan3",
    "3": "Wan4",
    "4": "Wan5",
    "5": "Wan6",
    "6": "Wan7",
    "7": "Wan8",
    "8": "Wan9",
    "9": "Pin1",
    "10": "Pin2",
    "11": "Pin3",
    "12": "Pin4",
    "13": "Pin5",
    "14": "Pin6",
    "15": "Pin7",
    "16": "Pin8",
    "17": "Pin9",
    "18": "Sou1",
    "19": "Sou2",
    "20": "Sou3",
    "21": "Sou4",
    "22": "Sou5",
    "23": "Sou6",
    "24": "Sou7",
    "25": "Sou8",
    "26": "Sou9",
    "72": "East",
    "28": "South",
    "29": "West",
    "30": "North",
    "31": "White",
    "32": "Green",
    "33": "Red",
    "34": "Backside",
]

let yakuTranslateDictionary = [
    "Dora": "ドラ",
    "Riichi": "リーチ",
    "Ippatsu": "一発",
    "Last tile from the wall": "海底摸月",
    "Last discard": "河底撈魚",
    "Dead wall draw": "嶺上開花",
    "Kan robbed": "槍槓",
    "Double riichi": "ダブルリーチ",
    "Closed tsumo": "門前清自摸和",
    "Seven pairs": "七対子",
    "All sequence": "平和",
    "No-points hand": "平和",
    "One set of identical sequences": "一盃口",
    "Two sets of identical sequences": "二盃口",
    "Straight": "一気通貫",
    "Three colour straight": "三色同順",
    "Three kans": "三槓子",
    "Three closed triplets or kans": "三暗刻",
    "Three colour triplets or kans": "三色同刻",
    "All triplets or kans": "対々和",
    "All terminals and honours": "混老頭",
    "All simples": "断么九",
    "Honour tiles": "飜牌",
    "Little dragons": "小三元",
    "Terminal or honor in each set": "全帯么",
    "Terminal in each set": "純全帯么",
    "Half-flush": "混一色",
    "Flush": "清一色",
    "Thirteen orphans": "国士無双",
    "Thirteen orphans 13 wait": "国士無双十三面待ち",
    "Four concealed triplets": "四暗刻",
    "Four concealed triplets single wait": "四暗刻単騎",
    "Big three dragons": "大三元",
    "Little four winds": "小四喜",
    "Big four winds": "大四喜",
    "All honors": "字一色",
    "All terminals": "清老頭",
    "All green": "緑一色",
    "Nine gates": "九蓮宝燈",
    "Nine gates 9 wait": "純正九蓮宝燈",
]

