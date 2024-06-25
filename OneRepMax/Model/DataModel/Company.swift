//
//  Company.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import Foundation
import SwiftData


@Model
class Company {
    @Attribute(.unique)
    let symbol: String       // eg. "MSFT"
    let name: String         // eg. "Microsoft Corporation",
    var favorite: Bool
    let marketCap: MarketCap
    
    init(symbol: String, name: String, favorite: Bool, marketCap: MarketCap ) {
        self.symbol = symbol
        self.name = name
        self.favorite = favorite
        self.marketCap = marketCap
    }
}
