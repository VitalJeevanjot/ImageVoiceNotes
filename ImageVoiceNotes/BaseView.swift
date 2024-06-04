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
    
    @Environment(\.modelContext) private var modelContext
    
    
    //    @State private var creationsUpdated = [newModel]()
    
    @State private var isPresentCreationViewer = false
    //    @State private var publicProperties = PublicAudioImageProperties.shared
    //    @StateObject private var viModel = ImageProperties()
    
    
    @State private var currentSelectModel: AudioImageModel?
    
    @State private var searchText = ""
    
    @Binding var navPath: [AudioImageModel]
    
    @State private var showDeveloperInfoSheet: Bool = false
    
//    init() {
//        print("Rendering base view.......")
//    }
    
    var body: some View {
        //        AudioRecorder()
        //        Text("hello")
        //        let _ = loadAudio()
//        NavigationStack(path: $navPath)
        NavigationStack(path: $navPath){
            VStack(spacing: 0) {
                HStack {
                    Image("applogo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding([.trailing], 10)
                        .onTapGesture {
                            showDeveloperInfoSheet = true
                        }
                    
                    TextField("Search", text: $searchText)
                        .padding(5)
                        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.brown, lineWidth: 2))
//                                .frame(width:200)
//                                .fixedSize(horizontal: true, vertical: true)
                    
                    NavigationLink {
                        ContentCreationViewer()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding(4.0)
                                .background(.black)
                                .clipShape(.rect(cornerRadius: 8))
                                .tint(.accent)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(.white, lineWidth: 2))
                        }
                        
                    }
                }
                .padding([.trailing, .leading],25)
                .padding([.bottom], 10)
                .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                
                creationsViewer(searchText: searchText)
//                    .padding([.leading, .trailing],10)
            }
//                .background(.black)

//                .toolbar {
//                   
////                    ToolbarItem {
////                        
//////                        .frame(maxWidth: .infinity)
//////                        .background(.green)
////                        
////                    }
//                    
//                }
//                .toolbarBackground(Color(red: 242/255, green: 242/255, blue: 242/255), for: .navigationBar)
            
        }
        .tint(.black)
        
        .sheet(isPresented: $showDeveloperInfoSheet, content: {
            VStack(spacing: 5) {
                Image("applogo")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                HStack {
                    Text("PicMik. (Picture Miked)")
                        .font(.title)
                }.padding([.bottom], 5)
                
                Text("by Jeevanjot Singh Vital")
                    .font(.title3)
                Button {
                    showDeveloperInfoSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }
                .tint(.black)
                .padding()
            }
        })
//    detail: {
//        Text("Selected items")
//    }
//        .navigationBarTitleDisplayMode(.inline)
//        .padding(0)
//        .searchable(text: $searchText)

        
        
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

struct creationsViewer: View {
    @Query var creations: [AudioImageModel]
    
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init(searchText: String) {
        _creations = Query(filter: #Predicate<AudioImageModel> { item in
            if searchText.isEmpty {
                return true
            } else {
                return item.nameOfCreation.localizedStandardContains(searchText)
            }
        }, sort: \AudioImageModel.createdDate, order: .reverse)
    }
    
    var body: some View {
//        List {

        ScrollView(showsIndicators: false) {
            ForEach(creations) {
                item in
                NavigationLink(value: item) {
                    perItemView(item: item, fileURl: direc.appendingPathComponent(item.imagePicked))
                }
//                NavigationLink {
//                    CreationViewer(receivedAudioImageModel: item)
//                        .toolbar(.hidden)
//                        
//                } label: {
//                    perItemView(item: item, fileURl: direc.appendingPathComponent(item.imagePicked))
//                }
            }
            .padding([.top], 10)
            .padding([.trailing, .leading], 4)
//            .background(.black)
//            .shadow(radius: 2)
//            .listRowSeparator(.hidden)
//         }.listSectionSeparator(.hidden)
        }
        .navigationDestination(for: AudioImageModel.self) { Dest in
            CreationViewer(receivedAudioImageModel: Dest)
        }
        
    }
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
        let path: String = fileURl.path(percentEncoded: false)
        let img: UIImage = UIImage(named: path)!
        return Group {
            Image(uiImage: img)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding([.trailing], 10)
//                .aspectRatio(contentMode: .fit)
            
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
