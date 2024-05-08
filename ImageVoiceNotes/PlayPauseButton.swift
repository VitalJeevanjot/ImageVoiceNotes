//
//  PlayPauseButton.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 28/04/24.
//

import SwiftUI

struct PlayPauseButton: View {
    var isPlaying: Bool
    var body: some View {
        Image(systemName: isPlaying ? "pause" : "play")
            .frame(width: 50, height: 50)
            .font(.system(size: 30))
            .background(.black)
            .foregroundColor(.white)
            .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    PlayPauseButton(isPlaying: false)
}
