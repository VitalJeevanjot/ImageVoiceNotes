//
//  popoverForAudioChoice.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 13/05/24.
//

import SwiftUI

struct popoverForAudioChoice: View {
    var body: some View {
        Group{}
        .popover(isPresented: .constant(true), content: {
            Text("hello")
        })
    }
}

#Preview {
    popoverForAudioChoice()
}
