//
//  ModelContainerProxy.swift
//  Employees
//
//  Created by Gustavo Halperin on 5/20/24.
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
            Company.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
