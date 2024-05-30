//
//  ContentView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 12/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AudioImageModel.createdDate, order: .reverse) private var creations: [AudioImageModel]
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    
    @State private var nowShowView = false
//    @Query private var items: [Item]
    var body: some View {
//        CreationViewer()
        Group {
            if nowShowView {
                
                BaseView()
                    .preferredColorScheme(.light)
                    .onOpenURL(perform: { url in
                        if url.pathExtension == "imagesong" {
                            print("url is....")
                            print(url)
                            defer {
                                url.stopAccessingSecurityScopedResource()
                            }
                            guard url.startAccessingSecurityScopedResource() else {
                                print("permission not given to open image song file.")
                                return
                            }
                            
                            
                            do {
                                let receivedData = try Data(contentsOf: url)
                                do {
                                    let decoder = JSONDecoder()
                                    let jsonReceived = try decoder.decode(FileToSaveWith.self, from: receivedData)
                                    print(jsonReceived)
                                    
                                    let audioData = jsonReceived.audioPickedData
                                    let imageData = jsonReceived.imagePickedData
                                    let uuidForAudio = UUID().uuidString
                                    let uuidForImage = UUID().uuidString
                                    
                                    let dataToSave : AudioImageModel = AudioImageModel(nameOfCreation: jsonReceived.nameOfCreation, imagePicked: uuidForImage, audioPicked: uuidForAudio, createdDate: Date.now, isImported: true, importedDate: Date.now)
                                    
                                    SaveFiles(audioData: audioData, imageData: imageData, uuidForAudio: uuidForAudio, uuidForImage: uuidForImage)
                                    
                                    // Imported date same as created date for reasons to keep sorting order correct in base view by date....
                                    
                                    modelContext.insert(dataToSave)
                                    
                                } catch {
                                    print("Err while decoding fetched data from imported file is: \(error)")
                                }
                            } catch {
                                print("Err while fetching data from imported file is: \(error)")
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
