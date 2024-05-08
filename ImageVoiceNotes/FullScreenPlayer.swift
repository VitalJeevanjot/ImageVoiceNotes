//
//  FullScreenPlayer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 06/05/24.
//

import SwiftUI

struct FullScreenPlayer: View {
    var publicProperties: PublicAudioImageProperties
    
    var body: some View {
        Text("Is full screen")
            
        //        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared

    return FullScreenPlayer(publicProperties: publicProperties)
}
