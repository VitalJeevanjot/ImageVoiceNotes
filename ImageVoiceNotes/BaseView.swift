//
//  BaseView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 22/04/24.
//

import SwiftUI
import AVFAudio
import SwiftData

struct newModel {
    var nameOfCreation: String
    var imagePicked: String
    var audioPicked: String
    var createdDate: Date
    var isImported: Bool
    var importedDate: Date?
    var isPlaying: Bool
}

struct BaseView: View {
    
    @Query(sort: \AudioImageModel.createdDate, order: .reverse) private var creations: [AudioImageModel]
    @Environment(\.modelContext) private var modelContext

    
//    @State private var creationsUpdated = [newModel]()
    
    @State private var isPresentCreationViewer = false
    //    @State private var publicProperties = PublicAudioImageProperties.shared
    //    @StateObject private var viModel = ImageProperties()
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    
    @State private var currentSelectModel: AudioImageModel?
    
    
    @State private var showInfoPopup = false
    @State private var showDeleteAlert = false
    
    init() {
        print("Rendering base view.......")
    }
    
    var body: some View {
        //        AudioRecorder()
        //        Text("hello")
        //        let _ = loadAudio()
        
        NavigationSplitView {
            List {
                ScrollView(showsIndicators: false) {
                    ForEach(creations) {
                        item in
                        NavigationLink {
                            CreationViewer(receivedAudioImageModel: item, showInfoPopup: $showInfoPopup, showDeleteAlert: $showDeleteAlert)
                                .toolbar(.hidden)
                        } label: {
                                perItemView(item: item, fileURl: direc.appendingPathComponent(item.imagePicked))
                        }
                    }
                    .shadow(radius: 2)
                    .listRowSeparator(.hidden)
                }.listSectionSeparator(.hidden)
                
            }
            .listStyle(.inset)
            .padding([.top], 20)
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        ContentCreationViewer()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .padding(4.0)
                                .background(.black)
                                .clipShape(.rect(cornerRadius: 4))
                                .tint(.accent)
                        }
                        
                    }
                    
                }
                
            }
            
            
        } detail: {
            Text("Selected items")
        }
        .tint(.black)
//        .task(priority: .high, {
//
//        })
//        .task {
//            creationsUpdated = creations.map {
//                return newModel(nameOfCreation: $0.nameOfCreation, imagePicked: $0.imagePicked, audioPicked: $0.audioPicked, createdDate: $0.createdDate, isImported: $0.isImported, isPlaying: false)
//            }
//            
//            print("\(String(describing: creationsUpdated))")
//        }
        //
    }
    
    //    func loadAudio() {
    //
    //        do {
    //            let filesURLs = try  FileManager.default.contentsOfDirectory(at: direc, includingPropertiesForKeys: [])
    //            print(filesURLs)
    //        } catch {
    //            print("cannot load files from baseview err is: \(error)")
    //        }
    //    }
    
}


struct buttonImageView: View {
    var fileURl: URL
    var creationName: String
    var creationTime: Date
    let imported: Bool
    let dateFormatter = DateFormatter()
    var body: some View {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
        let path: String = fileURl.path
        let img: UIImage = UIImage(named: path)!
        return Group {
            Image(uiImage: img)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding([.trailing], 10)
            
            VStack (alignment: .leading) {
                HStack {
                    Text(creationName)
                        .font(.title2)
                        .lineLimit(1)
                    Spacer()
                    if imported {
                        Image(systemName: "square.and.arrow.down")
                            .font(.caption)
                    }
                }
                Text(dateFormatter.string(from: creationTime))
                    .font(.caption)
            }
        }
        
    }
}

extension View {
    func apply<V: View> (@ViewBuilder _ block:(Self) -> V) -> V {block (self)}
}





//#Preview {
//    //    return List {
//    //
//    //        ForEach(1...50, id: \.self) {_ in
//    //            HStack {
//    //                Image("sampleImage")
//    //                    .resizable()
//    //                    .frame(width: 50, height: 50)
//    //                    .clipShape(Circle())
//    //                    .padding([.trailing], 10)
//    //                VStack (alignment: .leading) {
//    //                    Text("hello")
//    //                        .font(.title2)
//    //                    Text("date")
//    //                        .font(.caption)
//    //                }
//    //                Spacer()
//    //                Button {
//    //                    print("play/pause")
//    //                } label: {
//    //                    Label("Play or pause on main view", systemImage: "play")
//    //                        .labelStyle(.iconOnly)
//    //                        .font(.title2)
//    //                }
//    //                .tint(.black)
//    //                .padding([.trailing])
//    //            }
//    //            .padding(5)
//    //            .background(Color(red: 248/255, green: 248/255, blue: 248/255))
//    //            .clipShape(Capsule())
//    //        }
//    //        .shadow(radius: 2)
//    //        .listRowSeparator(.hidden)
//    //
//    //    }
//    //    .listStyle(.inset)
//    
//    return BaseView()
//}
