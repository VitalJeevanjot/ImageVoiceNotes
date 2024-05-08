//
//  SharedModelContainer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 04/05/24.
//

import Foundation
import SwiftData

@MainActor
class SampleModelContainer {
    static let shared = SampleModelContainer()
    
    let modelContainer: ModelContainer
    
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    init() {
        let schema = Schema([
            AudioImageModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Unable to create container here: \(error)")
        }
        
    }
}
