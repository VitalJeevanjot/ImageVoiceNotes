//
//  perItemView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 20/05/24.
//

import SwiftUI
import AVFAudio

struct perItemView: View {
    @Environment(\.modelContext) private var modelContext
    
    var item: AudioImageModel
    let direc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURl: URL
    @State private var showDeletionAlert: Bool = false
    @State private var pickedAudio = AVAudioPlayer()
    
    
    var body: some View {
        //                            let _ = print("File path on checkl..... \(fileURl.path())")
        Group {
            HStack {
                buttonImageView(fileURl: fileURl, creationName: item.nameOfCreation, creationTime: item.createdDate, imported: item.isImported)
                
                Spacer()
                Button {
                    showDeletionAlert = true
//                    isPlaying.toggle()
                    
                    //                                        playStopAudio(picked: item.audioPicked)
                    //                                        print("play/pause")
                } label: {
                    Label("Delete creation", systemImage: "xmark.bin.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 40))
                }
                .tint(.black)
                .padding([.trailing])
            }
            .padding(10)
            .background(Color(red: 248/255, green: 248/255, blue: 248/255))
            .clipShape(Capsule())
            .overlay {
                Capsule().strokeBorder(.brown, lineWidth: 2)
            }
            .alert("Delete \(item.nameOfCreation)?",isPresented: $showDeletionAlert, presenting: item) { item in
                AlertBeforeDeletion(item: item, showDeletionAlert: $showDeletionAlert, direc: direc)
            }
            
        }
        .padding(6)

    }
    
//    func playStopAudio(picked: String) {
//        pickedAudio.stop()
//        
//        let audioFileURl: URL = direc.appendingPathComponent(picked)
//        do {
//            print("Before audio playing init Base view.......\(audioFileURl.path())")
//            let data = try Data(contentsOf: audioFileURl)
//            print(" 2 Before audio playing init Base view....... \(data)")
//            pickedAudio = try AVAudioPlayer(data: data)
//            print("After audio playing init Base view.......")
//        } catch {
//            print("on creating avaudioplayer in base view err is \(error)")
//        }
//        
////        if isPlaying {
////            loadedAudio.stop()
////            isPlaying = false
////        } else {
////            loadedAudio.play()
////            isPlaying = true
////        }
//        
//    }
}

#Preview {
    @State var aim = AudioImageModel(nameOfCreation: "Sample name", imagePicked: "sampleImage", audioPicked: "music", createdDate: Date.now, isImported: false, importedDate: Date.now)
    
    return perItemView(item: aim, fileURl: URL(string: "sampleImage")!)
}
