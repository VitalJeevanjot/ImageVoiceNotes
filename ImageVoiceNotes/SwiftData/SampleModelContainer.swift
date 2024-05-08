////
////  SampleModelContainer.swift
////  ImageVoiceNotes
////
////  Created by Jeevanjot Singh on 29/04/24.
////
//
//import Foundation
//import SwiftData
//
//@MainActor
//class SampleModelContainer {
//    static let shared = SampleModelContainer()
//    
//    let modelContainer: ModelContainer
//    
//    var modelContext: ModelContext {
//        modelContainer.mainContext
//    }
//    
//    init() {
//        let schema = Schema([
//            PickedImageSampleData.self
//        ])
//        
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Unable to create container here: \(error)")
//        }
//    }
//}
