//
//  Date+Ext.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/22/24.
//

import Foundation

extension Date {
    static let min: Date = Date(timeIntervalSince1970: 0) // January 1, 1970
    static let max: Date = Date(timeIntervalSince1970: TimeInterval(Int.max)) // Far future date
}
