//
//  BaseView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 22/04/24.
//

import SwiftUI
import AVFAudio

struct BaseView: View {
    
    var body: some View {
        let _ = loadAudio()
        NavigationSplitView {
            Text("Listing something")
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        ImageViewer()
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

    }
    
    func loadAudio() {
        print("calling load audio")
        let fg = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let filesURLs = try  FileManager.default.contentsOfDirectory(at: fg, includingPropertiesForKeys: [])
            print(filesURLs)
        }
        catch {
            print("\(error)")
        }
//        let url = URL(fileURLWithPath: "/private/var/mobile/Containers/Shared/AppGroup/5CEF82B9-17AB-48D4-95FF-3C6339BB136C/File Provider Storage/Shared/Ranjit Pura 4.m4a")
//        print(url.path())
//        print(FileManager.default.fileExists(atPath: url.path()))
        
//        defer {
//            url.stopAccessingSecurityScopedResource()
//        }
//        
//        print("the value is")
//        let val = url.startAccessingSecurityScopedResource()
//        print(val)
//        print("val")
//        do {
//            let ad = try AVAudioPlayer(contentsOf: url)
//            print("File loaded.....")
//            print(ad.duration)
//        } catch {
//            print("err is: \(error)")
//        }
    }
    
}

extension View {
    func apply<V: View> (@ViewBuilder _ block:(Self) -> V) -> V {block (self)}
}



#Preview {
    BaseView()
}
