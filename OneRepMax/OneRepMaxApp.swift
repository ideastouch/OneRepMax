//
//  OneRepMaxApp.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI

fileprivate
let logger = LoggerFactory.category(.setup)

@main
struct OneRepMaxApp: App {
    @State private var isLoading = true
    private var appManager: AppManager = .init()


    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading == false,
                    let modelContainer = appManager.modelContainer {
                    ContentView()
                        .environment(appManager)
                        .modelContainer(modelContainer)
                } else {
                    Text("Loading Model Data")
                }
            }
            .task {
                do {
                    appManager.modelContainer = try await ModelContainerFactory().makeOne()
                } catch {
                    logger.critical("Failure loading model")
                }
                isLoading = false
            }
        }
    }
}


struct LoadingPreviewProxy<Content>: View
where Content : View {
    @ViewBuilder let content: () -> Content
    @State private var isLoading = true
    private var appManager: AppManager = .init()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        Group {
            if isLoading == false,
                let modelContainer = appManager.modelContainer {
                content()
                    .environment(appManager)
                    .modelContainer(modelContainer)
            } else {
                Text("Loading Model Data")
            }
        }
        .task {
            do {
                appManager.modelContainer = try await ModelContainerFactory().makeOne(isStoredInMemoryOnly: true)
            } catch {
                logger.critical("Failure loading model")
            }
            isLoading = false
        }
    }
}
