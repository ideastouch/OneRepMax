//
//  ContentView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI
import SwiftData
import SwiftUIExt

fileprivate
let logger = LoggerFactory.category(.setup)

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppManager.self) var appManager
    @State var filter: String = .init()
    @State var sortSelection: SortSelection = .NoOrder
    @State private var presentImporter = false
    
    
    @State private var gDriveActive = false
    static let gDriveDefault = "1HomqPGU5CW6Wqk5ykM0goZLAiAgtTtl2"
    @State private var gDriveText = ContentView.gDriveDefault
    
    @State private var activityIndicatorActive = false
    @State private var activityIndicatorLabel: String?
    @State private var clearAlertActive = false
    
    @State private var errorAlertMessage: String?
    @State private var errorAlertActive = false
    
    var body: some View {
        NavigationStack {
            ExerciseListView(
                emptyList:
            """
            Check GDrive Button for default Google Drive \
            file id or hit on Open Button and choose a csv \
            file from your Files.
            """,
                             sortSelection: sortSelection,
                             filter: filter)
                .searchable(text: $filter)
                .navigationTitle("Exercises")
                .toolbar { bottomBar() }
                .toolbar { navigationBar() }
        }
        .activityIndicator(isActive: activityIndicatorActive,
                           label: activityIndicatorLabel)
        .modifier(alert)
        .modifier(error)
    }
}

/// Toolbars
extension ContentView {
    private
    func navigationBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button { clearAlertActive.toggle()
                } label: {
                    Text("Clear").buttonDecorator(foreground: .red)
                }
                Button { gDriveActive.toggle() } label:
                { Text("GDrive").buttonDecorator() }
                    .popover(isPresented: $gDriveActive) {
                        VStack {
                            TextField("Google File Id",
                                      text: $gDriveText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .presentationCompactAdaptation((.popover))
                            HStack {
                                Button {
                                    if gDriveText.isEmpty == false {
                                        Task { await refresh(googleFileId: gDriveText) } }
                                    gDriveActive.toggle()
                                } label:
                                { Text("Download").buttonDecorator() }
                                Button {
                                    gDriveText = ContentView.gDriveDefault
                                    Task { await refresh(googleFileId: gDriveText) }
                                    gDriveActive.toggle()
                                } label:
                                { Text("Default").buttonDecorator() }
                                Button { gDriveActive.toggle()
                                } label:
                                { Text("Cancel").buttonDecorator(foreground: .red) }
                                
                            }
                            .padding()
                        }
                    }
                Button { presentImporter.toggle() } label: {
                    Text("Open").buttonDecorator() }
            }.fileImporter(isPresented: $presentImporter, allowedContentTypes: [.text]) { result in
                switch result {
                case .success(let url):
                    Task { await refresh(fileURL: url) }
                case .failure(let error):
                    logger.error("Failure loading file, \(error)")
                }
            }
        }
    }
    
    private
    func bottomBar() -> some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Picker("", selection: $sortSelection) {
                ForEach(SortSelection.allCases) { sortBy in
                    Text(sortBy.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    private
    var alert: some ViewModifier {
        AlertModifier(title: "Delete Local Data Base",
                      isPresented: $clearAlertActive,
                      actions: {
            HStack {
                Button("Confirm", role: .destructive) {
                    clearAlertActive.toggle()
                    Task { try await appManager.cleanDataBase() }
                } } },
                      message: { Text("Please confirm") } )
    }
    private
    var error: some ViewModifier {
        AlertModifier(title: "Error",
                      isPresented: $errorAlertActive,
                      actions: {
            HStack {
                Button("OK", role: .none) {
                    Task { try await appManager.cleanDataBase() }
                } } },
                      message: { Text(errorAlertMessage ?? "") } )
    }
}

/// View Actions
extension ContentView {
    private
    func refresh(googleFileId: String) async {
        activityIndicatorLabel = "Loading New Data"
        activityIndicatorActive = true
        defer {
            activityIndicatorActive = false
            activityIndicatorLabel = nil
        }
        do {
            logger.debug("Request to download google file")
            try await appManager.loadWorkouts(googleFileId: googleFileId)
        } catch {
            logger.error("Error refreshing exercises: \(error)")
            errorAlertMessage = error.localizedDescription
            errorAlertActive.toggle()
        }
    }
    private
    func refresh(fileURL:URL) async {
        activityIndicatorLabel = "Loading New Data"
        activityIndicatorActive = true
        defer {
            activityIndicatorActive = false
            activityIndicatorLabel = nil
        }
        do {
            logger.debug("Request to load workout's file")
            try await appManager.loadWorkouts(fileURL: fileURL)
        } catch {
            logger.error("Error refreshing exercises: \(error)")
            errorAlertMessage = error.localizedDescription
            errorAlertActive.toggle()
        }
    }
}

public
extension View {
    func buttonDecorator(foreground:Color = .black) -> some View {
        self.contentRoundedBorder(foreground: foreground,
                                  background: .clear,
                                  borderColor: .black,
                                  maxWidth: nil,
                                  padding: .body * 0.5)
    }
}

#Preview {
    // In order to make it work, to show some companies, I need to load the data offline.
    LoadingPreviewProxy { ContentView() }
        .previewDevice("iPhone 13 mini")
        .previewDisplayName("iPhone 13 mini")
}
