//
//  BaseView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 22/04/24.
//

import SwiftUI
import AVFAudio
import SwiftData

struct BaseView: View {
    
    @Query private var creations: [AudioImageModel]
    @State private var isPresentCreationViewer = false
    //    @State private var publicProperties = PublicAudioImageProperties.shared
    //    @StateObject private var viModel = ImageProperties()
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    @State private var currentSelectModel: AudioImageModel?
    
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
                            CreationViewer(receivedAudioImageModel: item)
                                .toolbar(.hidden)
                        } label: {
                            Group {
                                HStack {
                                    let fileURl: URL = direc.appendingPathComponent(item.imagePicked)
                                    //                            let _ = print("File path on checkl..... \(fileURl.path())")
                                    buttonImageView(fileURl: fileURl, creationName: item.nameOfCreation)
                                    
                                    Spacer()
                                    Button {
                                        print("play/pause")
                                    } label: {
                                        Label("Play or pause on main view", systemImage: "play.fill")
                                            .labelStyle(.iconOnly)
                                            .font(.title2)
                                    }
                                    .tint(.black)
                                    .padding([.trailing])
                                    
                                }
                                .padding(5)
                                .background(Color(red: 248/255, green: 248/255, blue: 248/255))
                                .clipShape(Capsule())
                                
                            }
                            .padding(5)
                            
                            
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
        //
    }
    
    func loadAudio() {
        
        do {
            let filesURLs = try  FileManager.default.contentsOfDirectory(at: direc, includingPropertiesForKeys: [])
            print(filesURLs)
        } catch {
            print("cannot load files from baseview err is: \(error)")
        }
        
        //        print("calling load audio")
        //        let fg = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //        do {
        //            let filesURLs = try  FileManager.default.contentsOfDirectory(at: fg, includingPropertiesForKeys: [])
        //            print(filesURLs)
        //        }
        //        catch {
        //            print("\(error)")
        //        }
        ////        let url = URL(fileURLWithPath: "/private/var/mobile/Containers/Shared/AppGroup/5CEF82B9-17AB-48D4-95FF-3C6339BB136C/File Provider Storage/Shared/Ranjit Pura 4.m4a")
        ////        print(url.path())
        ////        print(FileManager.default.fileExists(atPath: url.path()))
        //
        ////        defer {
        ////            url.stopAccessingSecurityScopedResource()
        ////        }
        ////
        ////        print("the value is")
        ////        let val = url.startAccessingSecurityScopedResource()
        ////        print(val)
        ////        print("val")
        ////        do {
        ////            let ad = try AVAudioPlayer(contentsOf: url)
        ////            print("File loaded.....")
        ////            print(ad.duration)
        ////        } catch {
        ////            print("err is: \(error)")
        ////        }
    }
    
}


struct buttonImageView: View {
    var fileURl: URL
    var creationName: String
    var body: some View {
        let path: String = fileURl.path
        let img: UIImage = UIImage(named: path)!
        Image(uiImage: img)
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding([.trailing], 10)
        VStack (alignment: .leading) {
            Text(creationName)
                .font(.title2)
            Text("date")
                .font(.caption)
        }
        
    }
}

extension View {
    func apply<V: View> (@ViewBuilder _ block:(Self) -> V) -> V {block (self)}
}





#Preview {
    //    return List {
    //
    //        ForEach(1...50, id: \.self) {_ in
    //            HStack {
    //                Image("sampleImage")
    //                    .resizable()
    //                    .frame(width: 50, height: 50)
    //                    .clipShape(Circle())
    //                    .padding([.trailing], 10)
    //                VStack (alignment: .leading) {
    //                    Text("hello")
    //                        .font(.title2)
    //                    Text("date")
    //                        .font(.caption)
    //                }
    //                Spacer()
    //                Button {
    //                    print("play/pause")
    //                } label: {
    //                    Label("Play or pause on main view", systemImage: "play")
    //                        .labelStyle(.iconOnly)
    //                        .font(.title2)
    //                }
    //                .tint(.black)
    //                .padding([.trailing])
    //            }
    //            .padding(5)
    //            .background(Color(red: 248/255, green: 248/255, blue: 248/255))
    //            .clipShape(Capsule())
    //        }
    //        .shadow(radius: 2)
    //        .listRowSeparator(.hidden)
    //
    //    }
    //    .listStyle(.inset)
    
    return BaseView()
}
