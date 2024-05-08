//
//  AudioPlayer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 07/05/24.
//

import SwiftUI

struct AudioPlayer: View {
    @Bindable var publicProperties: PublicAudioImageProperties
    let componentFormatter = DateComponentsFormatter()
    @State private var edited: Bool = false
    var onFront: Bool = false
    
    
    var body: some View {
        componentFormatter.unitsStyle = .positional
        componentFormatter.allowedUnits = [.minute, .second]
        componentFormatter.zeroFormattingBehavior = .pad
        
        return VStack {
            Group {                
                HStack {
                    Slider(
                        value: $publicProperties.audioPlayer.currentTime,
                        in: 0...publicProperties.durationTime
                    ) {
                        Text("Audio Time Slider")
                    } minimumValueLabel: {
                        //                            Text("Demo")
                        Text("\(componentFormatter.string(from: publicProperties.currentTime) ?? "00:00")")
                    } maximumValueLabel: {
                        Text("\(componentFormatter.string(from: publicProperties.durationTime) ?? "00:00")")
                    }
//                onEditingChanged: {
//                    editedVal in
//                    edited = true
//                }
//                .onChange(of: edited,
//                          { oldValue, newValue in
//                    print("\(newValue)")
//                    if newValue {
//                        publicProperties.audioPlayer.currentTime = publicProperties.currentTime
//                        edited = false
//                    }
//                })
                .padding([.leading, .trailing], 30)
                }
                HStack {
                    Button {
                        if publicProperties.isPlaying {
                            //                        print("Doing it")
                            Task {
                                await stopStartAudioPlayer("stop")
                                publicProperties.isPlaying = false
                            }
                        } else {
                            publicProperties.audioPlayer.prepareToPlay()
                            Task {
                                await stopStartAudioPlayer("start")
                                publicProperties.isPlaying = true
                            }
                        }
                        
                    } label: {
                        PlayPauseButton(isPlaying: publicProperties.isPlaying)
                    }
                }
            }
            .padding([.top, .trailing, .leading])
            .padding([.bottom], 5)
        }
        .background(onFront ? Color(red: 212/255, green: 212/255, blue: 212/255) : .white)
    }
    
    func stopStartAudioPlayer(_ type: String) async {
        if type == "stop" {
            publicProperties.audioPlayer.stop()
        } else {
            publicProperties.audioPlayer.play()
            
        }
    }
    
}





#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared
    return AudioPlayer(publicProperties: publicProperties)
}
