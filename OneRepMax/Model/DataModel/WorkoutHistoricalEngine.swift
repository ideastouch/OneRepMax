//
//  WorkoutHistoricalEngine.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/24/24.
//

import Foundation
import SwiftExt

fileprivate
let loggerDataModel = LoggerFactory.category(.dataModel)

actor WorkoutHistoricalEngine {
    func process(workoutList: [ResponseWorkout], favorityStatus: [String: Bool] ) throws -> ([WorkoutHistorical], [Workout]) {
        let workoutsByExercise = workoutList.reduce(into: [String: [ResponseWorkout]]() ) {
            let exercise = $1.exercise
            var workouts = $0[exercise] ?? [ResponseWorkout]()
            workouts.append($1)
            $0[exercise] = workouts
        }
        var workouts: [Workout] = .init()
        var workoutHistoricalList: [WorkoutHistorical] = .init()
        for (exersise,historical) in workoutsByExercise {
            var date = Date.min
            var oneRepMax: Int16 = 0
            var workoutList: [Workout] = .init()
            for workout in historical.sorted(by: { $0.date < $1.date }) {
                if date != workout.date {
                    if date > Date.min, oneRepMax > 0 {
                        let workout = Workout(date: date, exercise: exersise, oneRepMax: oneRepMax)
                        workoutList.append(workout)
                    }
                    date = workout.date
                    oneRepMax = 0
                }
                do {
                    let nextOneRepMax = try BrzyckiOneRepMaxCalculator
                        .calcOneRepMax(workout.repetitions, weight: workout.weight)
                        .intRounded
                    guard nextOneRepMax <= BrzyckiOneRepMaxCalculator.maxWeightAllowed else {
                        let above = nextOneRepMax - BrzyckiOneRepMaxCalculator.maxWeightAllowed
                        throw WorkoutError.weightCeroAboveMax(above: above)
                    }
                    let int16 = Int16(nextOneRepMax)
                    oneRepMax = max(oneRepMax, int16)
                } catch WorkoutError.repetitionsCeroValue {
                    loggerDataModel.error("Repetitions value cannot be zero.")
                } catch WorkoutError.repetitionsAboveMax(let above) {
                    loggerDataModel.error("Repetitions above the maximum by \(above).")
                } catch WorkoutError.weightCeroValue {
                    loggerDataModel.error("Weight value cannot be zero.")
                } catch WorkoutError.weightCeroAboveMax(let above) {
                    loggerDataModel.error("Weight above the maximum by \(above).")
                } catch {
                    loggerDataModel.error("An unknown error occurred: \(error)")
                }
            }
            //let sortedWorkoutList = workoutList.sorted(by: { $0.date < $1.date } )
            let maxOneRM = workoutList.reduce(into: 0){ $0 = Swift.max($0, $1.oneRepMax) }
            let workoutHistorical: WorkoutHistorical = .init(exercise: exersise,
                                                             maxOneRM: maxOneRM,
                                                             favorite: favorityStatus[exersise] ?? false)
            workouts.append(contentsOf: workoutList)
            workoutHistoricalList.append(workoutHistorical)
        }
        return (workoutHistoricalList, workouts)
    }
}


