//
//  ContentView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 12/04/24.
//

import SwiftUI
import SwiftData


@Observable class StatusBarValue {
    var statusBarHidden = false
}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var creations: [AudioImageModel] // for validating audio/image files in documents with swiftData entities saved.
//    @Environment (\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    
    @State private var nowShowView = false
    
    @State private var navPath: [AudioImageModel] = []
    
    @State private var pathItemToAppend: AudioImageModel?
    
    @State private var statusBarVal = StatusBarValue()
//    @Query private var items: [Item]
    var body: some View {
//        CreationViewer()
//        let _ = print(direc)

        Group {
            if nowShowView {
                
                BaseView(navPath: $navPath)
                    .environment(statusBarVal)
                    .preferredColorScheme(.light)
                    .statusBarHidden(statusBarVal.statusBarHidden)
                    .onOpenURL(perform: { url in
                        if url.pathExtension == "picmik" {
//                            print("url is....")
//                            print(url)
                            defer {
                                url.stopAccessingSecurityScopedResource()
                            }
                            guard url.startAccessingSecurityScopedResource() else {
                                print("permission not given to open image song file.")
                                return
                            }
                            
                            
                            do {
                                let jsonReceived = try FileToSaveWith.read(from: url)
                                let uuidForAudio = UUID().uuidString
                                let uuidForImage = UUID().uuidString
                                let dataToSave = AudioImageModel(nameOfCreation: jsonReceived.nameOfCreation, imagePicked: uuidForImage, audioPicked: uuidForAudio, createdDate: Date.now, isImported: true, importedDate: Date.now)

                                SaveFiles(audioData: jsonReceived.audioPickedData, imageData: jsonReceived.imagePickedData, uuidForAudio: uuidForAudio, uuidForImage: uuidForImage)

                                // Use the import date for both fields so the list sorts by when the creation was added.
                                modelContext.insert(dataToSave)
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("err while saving imported data to SwiftUI is: \(error)")
                                }
                                pathItemToAppend = dataToSave
                            } catch {
                                print("Error reading imported .picmik file: \(error)")
                            }
                            
                        }
                    })
            }
        }
        .task(priority: .high, {
            for i in creations {
                if !FileManager.default.fileExists(atPath: direc.appending(path: i.audioPicked).path(percentEncoded: false)) {
                    modelContext.delete(i)
                    continue
                }
                if !FileManager.default.fileExists(atPath: direc.appending(path: i.imagePicked).path(percentEncoded: false)) {
                    modelContext.delete(i)
                    continue

                }
            }
            nowShowView = true
            
        })
        .onChange(of: scenePhase) { old, newPhase in
            if newPhase == .active {
//                print("PHASE ___ Active!!")
                if pathItemToAppend != nil {
                    navPath.append(pathItemToAppend!)
                    pathItemToAppend = nil
                }
            }
            if newPhase == .inactive {
//                print("PHASE ___ Inactive!!")
                navPath.removeAll()
            }
            if newPhase == .background {
//                print("PHASE ___ Background!!")
            }
        }
//        AudioRecorder()
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
