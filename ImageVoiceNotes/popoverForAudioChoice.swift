//
//  popoverForAudioChoice.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 13/05/24.
//

import SwiftUI

struct popoverForAudioChoice: View {
    @Binding var presentFilePicker: Bool
    @Binding var presentPopOver: Bool
    var publicProperties : PublicAudioImageProperties
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    presentPopOver = false
                    presentFilePicker = true
                    print("true now")
                } label: {
                    Image(systemName: "waveform.badge.plus")
                        .font(.system(size: 50))
                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 15))
                        .symbolRenderingMode(.monochrome)
                        .background(Color.black)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(.white)
                }
                Text("Record")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            .padding()
            
            VStack {
                Button {
                    presentPopOver = false
                    publicProperties.audioPlayer.stop()
                    publicProperties.isPlaying = false
                    publicProperties.audioFileSelectedAndAdded = false
                    publicProperties.isReadyToPlayFull = false
                    publicProperties.showRecordingUI = true
                    print("Record")
                } label: {
                    Image(systemName: "record.circle")
                        .font(.system(size: 50))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .symbolRenderingMode(.monochrome)
                        .background(Color.black)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(.red)
                }
                
                Text("Record")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            .padding()
            
        }
        
    }
}

#Preview {
    @State var filePicker = false
    @State var popOver = false
    @State var publicproperties = PublicAudioImageProperties.shared
    
    return popoverForAudioChoice(presentFilePicker: $filePicker, presentPopOver: $popOver, publicProperties: publicproperties)
}
