//
//  ModelContainerFactory.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation
import SwiftUI
import SwiftData

actor ModelContainerFactory {
    init() {}
    func makeOne(isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            Workout.self,
            WorkoutHistorical.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: isStoredInMemoryOnly)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
