//
//  SharedAll.swift
//  TinyYOLO-CoreML
//
//  Created by RYO SUZUKI on 2017/12/23.
//  Copyright © 2017年 MachineThink. All rights reserved.
//

import UIKit

class SharedAll: NSObject {
    static let sharedInstance = SharedAll()
    
    var winningHand:Hand
    
    private override init() {
        winningHand = Hand()
    }


}
