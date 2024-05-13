//
//  AddNewAudio.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 26/04/24.
//

import SwiftUI
import AVFAudio

struct AddNewAudio: View {
    var toolbar = false
    
    var publicProperties: PublicAudioImageProperties
        
    
    //    @Binding private var durationOfAudioPlayed: TimeInterval
    
    var body: some View {
        //        let _ = print("\(publicProperties.audioPlayer?.currentTime)")
        //        let _ = print("\(publicProperties.audioPlayer?.duration)")
        return VStack {
            //            Text("hello from AddNewAudio")
            //            let _ = print("hello from vstack in AddNewAudio")
            Group {
                if publicProperties.audioFileSelectedAndAdded {
                    if publicProperties.durationTime > 0 {
                        //                    Text("hello")
                        AudioPlayer(publicProperties: publicProperties)
                        
                    }
                } else {
                    AddAudioButton(publicProperties: publicProperties, toolbar: toolbar)
                    
                    Text("Add audio")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundStyle(.black)
                        .padding([.top], 10)
                }
                if publicProperties.isLoading {
                    ProgressView()
                        .padding()
                        .scaleEffect(CGSize(width: 2.0, height: 2.0))
                    Text("Processing file.")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                }
                
                
            }
            
        }
        .onDisappear(perform: {
            print("disappeared....")
            publicProperties.audioPlayer.stop()
            publicProperties.isPlaying = false
            publicProperties.audioFileSelectedAndAdded = false
            publicProperties.isReadyToPlayFull = false
        })
    }
    
}
//extension View

#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared
    return AddNewAudio(publicProperties: publicProperties)
}

#Preview ("2nd Add new Audio") {
    @State var publicProperties = PublicAudioImageProperties.shared
    publicProperties.durationTime = 10
    publicProperties.isLoading = true
    return AddNewAudio(publicProperties: publicProperties)
}

