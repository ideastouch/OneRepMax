//
//  WorkoutHistorical.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/22/24.
//

import Foundation
import SwiftData
import SwiftExt

@Model
class WorkoutHistorical {
    let exercise: String  // eg. "Back Squat"
    var maxOneRM: Int16
    var favorite: Bool
    init(exercise: String, maxOneRM: Int16, favorite: Bool = false) {
        self.exercise = exercise
        self.favorite = favorite
        self.maxOneRM = maxOneRM
        // workoutList.reduce(into: 0){ $0 = Swift.max($0, $1.oneRepMax) }
        // maxOneRM = Swift.max(maxOneRM, workout.oneRepMax)
    }
}
/*
extension WorkoutHistorical: RandomAccessCollection {
    typealias Element = Workout
    typealias Index = Int

    var startIndex: Index { workoutList.startIndex }
    var endIndex: Index { workoutList.endIndex }

    subscript(position: Index) -> Element {
        workoutList[position]
    }
}
*/
