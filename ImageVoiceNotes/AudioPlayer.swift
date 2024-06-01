//
//  AudioPlayer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 07/05/24.
//

import SwiftUI
import AVFAudio

struct AudioPlayer: View {
    @Bindable var publicProperties: PublicAudioImageProperties
    let componentFormatter = DateComponentsFormatter()
    @State private var edited: Bool = false
    var onFront: Bool = false
    var secondsToForwardAndBackwardPlayer = 5
    
    var body: some View {
        componentFormatter.unitsStyle = .positional
        componentFormatter.allowedUnits = [.minute, .second]
        componentFormatter.zeroFormattingBehavior = .pad
        
        return VStack {
            
            Group {
//                let _ = print("avplayer \(publicProperties.audioPlayer.duration)")
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
                    } onEditingChanged: {
                        val in
                        publicProperties.currentTime = publicProperties.audioPlayer.currentTime
                        publicProperties.audioPlayer.stop()
                        publicProperties.isPlaying = false
                        
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
//                    .padding([.leading, .trailing], 30)
                }
                HStack {
//                    Group {
//                        let _ = print("Here")
//                        let _ = print("\(Bundle.main.path(forResource: "music", ofType: "mp3"))")
//                        guard let url = Bundle.main.path(forResource: "music", ofType: "mp3") else {
//                            print("returning without assigning...")
//                            return Text("hello")
//                        }
//                        let _ = print("url-")
//                        let _ = print("\(url)")
//                        return Text("hello")
//                    }

                    
                    Button {
                        let ct = publicProperties.audioPlayer.currentTime
                        if ct >  5 {
                            publicProperties.audioPlayer.currentTime -= 5
                        } else {
                            publicProperties.audioPlayer.currentTime -= ct
                        }
                        publicProperties.currentTime = publicProperties.audioPlayer.currentTime
                        
                        
                    } label: {
                        Label("5 second back", systemImage: "gobackward.5")
                            .font(.title)
                            .labelStyle(.iconOnly)

                    }
                    .padding([.trailing], 20)
                    
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
                    
                    
                    Button {
                        let offset = publicProperties.audioPlayer.duration - publicProperties.audioPlayer.currentTime
                        if offset > 5 {
                            publicProperties.audioPlayer.currentTime += 5
                        } else {
                            publicProperties.audioPlayer.currentTime += offset
                        }
                        
                        publicProperties.currentTime = publicProperties.audioPlayer.currentTime
                        
                    } label: {
                        Label("5 second forward", systemImage: "goforward.5")
                            .font(.title)
                            .labelStyle(.iconOnly)
                    }
                    .padding([.leading], 20)

                    
                }
            }
            .foregroundStyle(.black)
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

    do {
        let data = NSDataAsset(name: "music")?.data
        if data != nil {
            publicProperties.audioPlayer = try AVAudioPlayer(data: data!)
            publicProperties.durationTime = publicProperties.audioPlayer.duration
            publicProperties.setUpTimer()
            //            print(
            publicProperties.audioPlayer.delegate = publicProperties
            publicProperties.isReadyToPlayFull = true
            publicProperties.isLoading = false
        } else {
            print("no data")
        }
    } catch {
        print("cannot set avaudio player \(error)")
    }
    return AudioPlayer(publicProperties: publicProperties)
}
