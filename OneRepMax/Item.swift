//
//  Item.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
