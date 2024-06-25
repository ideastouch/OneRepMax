//
//  Workout+OneRM.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/22/24.
//

import Foundation

enum WorkoutError: Error {
    case repetitionsCeroValue
    case repetitionsAboveMax(above:UInt8)
    case weightCeroValue
    case weightCeroAboveMax(above:Int)
}

// Brzycki, https://en.wikipedia.org/wiki/One-repetition_maximum
enum BrzyckiOneRepMaxCalculator {
    static let maxRepetitionsAllowed: UInt8 = 36
    static let maxWeightAllowed: Int = Int(UInt16.max)
    static func checkRepetitions(_ value: UInt8) throws {
        guard value != 0 else { throw WorkoutError.repetitionsCeroValue }
        guard value <= maxRepetitionsAllowed else {
            throw WorkoutError.repetitionsAboveMax(above: value - maxRepetitionsAllowed)
        }
    }
    static func checkWeight(_ value: UInt16) throws {
        guard value != 0 else { throw WorkoutError.weightCeroValue }
    }
    static func calcOneRepMax(_ repetitions:UInt8, weight: UInt16) throws -> Float {
        try checkRepetitions(repetitions)
        try checkWeight(weight)
        let repetitions = Float(repetitions)
        let weight = Float(weight)
        let maxRepetitionsAllowed = Float(maxRepetitionsAllowed)
        return weight * maxRepetitionsAllowed / (maxRepetitionsAllowed + 1 - repetitions)
    }
}
