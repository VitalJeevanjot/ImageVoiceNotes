//
//  MainPlayerButtonAndScreen.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 02/05/24.
//

import SwiftUI
import PDFKit
import AVFAudio

var timer: Timer?
struct MainPlayerButtonAndScreen: View {
    @Bindable var publicProperties: PublicAudioImageProperties
    @State private var appearUI = true
    @State private var closed = true
    
    @ObservedObject var viModel: ImageProperties
    @State private var pdfView = PDFView()

    
    var body: some View {
        Button {
            print("Main play")
            publicProperties.playOnFullScreen = true
            appearUI = true
            closed = false
        } label: {
            Image(systemName: "play.rectangle.on.rectangle.circle.fill")
                .frame(width: 80, height: 70)
                .font(.system(size: 50))
                .background(.black)
                .foregroundColor(.white)
                .clipShape(.rect(cornerRadius: 20))
        }
        .fullScreenCover(isPresented: $publicProperties.playOnFullScreen, content: {
            ZStack {
                Color.black.ignoresSafeArea(edges: .all)
                //                Image("sampleImage")
                let imgToShow = UIImage(data: publicProperties.pickedImageData)!
                
                imageViewerWithZoomEtc(image: imgToShow, view: pdfView).ignoresSafeArea()
                
                if appearUI {
                    VStack(alignment: .leading) {
                        Button{
                            publicProperties.playOnFullScreen = false
                            closed = true
                        }label: {
                            Label("Close", systemImage: "arrow.uturn.backward")
                        }
                        .foregroundStyle(.black)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(Color(red: 212/255, green: 212/255, blue: 212/255))
                        Spacer()
                        Group {
                            if publicProperties.showOnFullScreenAudioPlayer == true {
                                AudioPlayer(publicProperties: publicProperties, onFront: true)
                            }
                        }
                    }
                    
                    if publicProperties.isPlaying {
                        let _ = print("Is playing now")
                        let _ = autoHideUIWhenNotpaused()
                    }
                }
            }
            .onTapGesture {
                showHideUI()
            }
            .task {
                print("Task")
                autoHideUIWhenNotpaused()
            }
        })
        
        
    }
    
    func showHideUI() {
        withAnimation {
            appearUI.toggle()
        }
        autoHideUIWhenNotpaused()
    }
    
    func autoHideUIWhenNotpaused()  {
        print(publicProperties.isPlaying)
        let closedState = closed
        timer?.invalidate()
        if appearUI && publicProperties.isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { Timer in
                if closedState == false && publicProperties.isPlaying {
                    withAnimation {
                        appearUI = false
                    }
                }
            }
        }
    }
}

#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared
    @StateObject var viModel = ImageProperties()
    
    publicProperties.pickedImageData = UIImage(named: "sampleImage")!.pngData()!
//    print(publicProperties.pickedImageData)
    print("audio image data from Main player preview...")
    publicProperties.pickedAudioData = NSDataAsset(name: "music")!.data
    do {
        publicProperties.audioPlayer =  try AVAudioPlayer(data: publicProperties.pickedAudioData)    //    guard let img = UIImage(named: "sampleImage") else {
    } catch {
        print("err is from MainPlayer preview: \(error)")
    }
    
    publicProperties.durationTime = publicProperties.audioPlayer.duration
    
    publicProperties.setUpTimer()
    //            print(
    publicProperties.audioPlayer.delegate = publicProperties
//        print("cannot get data in preview from MainPlayer")
//        return MainPlayerButtonAndScreen(publicProperties: publicProperties, viModel: viModel)
//
//    }
//    publicProperties.pickedImageData = img!.pngData()
    return MainPlayerButtonAndScreen(publicProperties: publicProperties, viModel: viModel)
}
