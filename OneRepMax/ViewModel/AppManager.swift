//
//  AppManager.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI
import SwiftData
import Observation

fileprivate
let loggerDataModel = LoggerFactory.category(.dataModel)


@MainActor
@Observable
class AppManager {
    var modelContainer: ModelContainer? = nil
    
    nonisolated
    init() {}
    
    func workoutListRefresh(_ workoutList: [ResponseWorkout]) async throws {
        guard let modelContainer = modelContainer else {
            let error = NSError(domain: "",
                                code: 11000,
                                userInfo: [NSLocalizedDescriptionKey: "Model Container isn't initialized"])
            throw error
        }
        var favorityStatus: [String: Bool] = .init()
        do {
            favorityStatus = try modelContainer.mainContext
                .fetch( FetchDescriptor<WorkoutHistorical>() )
                .reduce(into: [String:Bool]()) {
                    $0[$1.exercise] = $1.favorite
                }
        } catch {
            loggerDataModel.error("Failure during WorkoutHistorical Fetch")
        }
        
        try modelContainer.mainContext.delete(model: WorkoutHistorical.self)
        
        let workoutHistoricalList: [WorkoutHistorical] = try await WorkoutHistoricalEngine()
            .process(workoutList: workoutList, favorityStatus: favorityStatus)
        for workoutHistorical in workoutHistoricalList {
            modelContainer.mainContext.insert(workoutHistorical)
        }
    }
    
    //let googleFileId = "1HomqPGU5CW6Wqk5ykM0goZLAiAgtTtl2"
    func loadWorkouts(googleFileId:String) async throws {
        let workoutList: [ResponseWorkout] = try await ApiServer().refresh(googleFileId.googleFileIdToURL )
        try await workoutListRefresh(workoutList)
    }
    func loadWorkouts(fileURL:URL) async throws {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let workoutList: [ResponseWorkout] = try URLRequest.WorkoutsHistorical.workouts(contentsOf: content)
        try await workoutListRefresh(workoutList)
    }
}


