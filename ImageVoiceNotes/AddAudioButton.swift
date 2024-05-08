//
//  AddAudioButton.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 03/05/24.
//

import SwiftUI
import AVFAudio

struct AddAudioButton: View {
    @State private var presentFilePicker = false
    var publicProperties: PublicAudioImageProperties
    var toolbar = false
    
    
    var body: some View {
        Button {
            presentFilePicker = true
        } label: {
            Image(systemName: "waveform.badge.plus")
                .symbolRenderingMode(.monochrome)
                .apply {
                    if !toolbar {
                        $0.font(.system(size: 100))
                            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 20))
                    } else {
                        $0.font(.system(size: 14))
                            .padding(EdgeInsets(top: 5, leading: 8, bottom: 3, trailing: 12))
                    }
                    
                }
                .background(Color.black)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.white)
            
            
        }
        .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.audio]) { result in
            switch result {
            case .success(let file):
                Task {
                    updateUIAfterAudioSelect()
                    presentFilePicker = false
                    guard file.startAccessingSecurityScopedResource() else {
                        return
                    }
                    
                    assignAudioPlayer(val: file)
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    func updateUIAfterAudioSelect() {
        publicProperties.isLoading = true
        publicProperties.audioFileSelectedAndAdded = true
    }
    
    
    func assignAudioPlayer(val: URL) {
        
        defer {
            val.stopAccessingSecurityScopedResource()
        }
        
        
        print("1")
        
        do {
            publicProperties.audioPlayer =  try AVAudioPlayer(contentsOf: val)
            //            print("2")
            publicProperties.durationTime = publicProperties.audioPlayer.duration
            publicProperties.setUpTimer()
            //            print(
            publicProperties.audioPlayer.delegate = AVAudioPlayerDeleteFunction.shared
            publicProperties.isReadyToPlayFull = true
            publicProperties.isLoading = false
        } catch {
            //            print("2.5")
            //            print(error)
            publicProperties.timer?.invalidate()
            publicProperties.isPlaying = false
            publicProperties.audioFileSelectedAndAdded = false
            publicProperties.isReadyToPlayFull = false
            publicProperties.isLoading = false
            
        }
    }
    
}

#Preview {
    @State var publicproperties = PublicAudioImageProperties.shared
    return AddAudioButton(publicProperties: publicproperties)
}

#Preview("In toolbar") {
    @State var publicproperties = PublicAudioImageProperties.shared
    return AddAudioButton(publicProperties: publicproperties, toolbar: true)
}

