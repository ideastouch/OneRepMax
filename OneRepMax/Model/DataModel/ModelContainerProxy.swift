//
//  ModelContainerProxy.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation
import SwiftUI
import SwiftData
import Observation


@MainActor
@Observable
class ModelContainerProxy {
    var modelContainer: ModelContainer? = nil
    
    nonisolated
    init() {}
    
    func loadModelContainer() throws {
        let schema = Schema([
            Workout.self,
            WorkoutHistorical.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
