//
//  MainPlayerButton.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 02/05/24.
//

import SwiftUI

struct MainPlayerButtonAndScreen: View {
    @Bindable var publicProperties: PublicAudioImageProperties
    var body: some View {
        Button {
            print("Main play")
            publicProperties.playOnFullScreen = true
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
            Image("img")
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 18))
                .ignoresSafeArea(edges: .all)
                .padding()
            
            VStack {
                Spacer()
                AudioPlayer(publicProperties: publicProperties)
            }
                
        
        }
    })

    }
}

#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared
    return MainPlayerButtonAndScreen(publicProperties: publicProperties)
}
