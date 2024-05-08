//
//  ImageVoiceNotesApp.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 12/04/24.
//

import SwiftUI
import SwiftData

@main
struct ImageVoiceNotesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AudioImageModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SampleModelContainer.shared.modelContainer)
    }
}
