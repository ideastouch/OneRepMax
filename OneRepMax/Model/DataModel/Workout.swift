//
//  MarketCap.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//
import Foundation
import SwiftData

@Model
class Workout {
    let exercise: String  // eg. "Back Squat"
    let date: Date        // DateFormatter: "MMM dd yyyy", eg "Oct 11 2020"
    let oneRepMax: Int16  //
    init(date: Date, exercise: String, oneRepMax: Int16) {
        self.date = date
        self.exercise = exercise
        self.oneRepMax = oneRepMax
    }
}
