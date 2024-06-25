//
//  MarketCap.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation
import SwiftData

@Model
class MarketCap {
    let fmt: String      // eg. "2.572T"
    let longFmt: String  // eg. "2,571,783,372,800"
    let raw: Int         // eg. 2571783372800
    init(fmt: String, longFmt: String, raw: Int) {
        self.fmt = fmt
        self.longFmt = longFmt
        self.raw = raw
    }
}
