//
//  WorkoutHistorical.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/22/24.
//

import Foundation
import SwiftData

@Model
class WorkoutHistorical {
    let exercise: String
    var maxOneRM: Int16
    var favorite: Bool
    init(exercise: String, maxOneRM: Int16, favorite: Bool = false) {
        self.exercise = exercise
        self.favorite = favorite
        self.maxOneRM = maxOneRM
    }
}
