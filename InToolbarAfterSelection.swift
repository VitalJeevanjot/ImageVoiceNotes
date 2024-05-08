//
//  InToolbarAfterSelection.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 03/05/24.
//

import SwiftUI

struct InToolbarAfterSelection: View {
    @ObservedObject var viewModel: VoicedImageModel
    var publicProperties: PublicAudioImageProperties
    
    var body: some View {
//        let _ = print("toolbar")
        HStack {
            if publicProperties.audioFileSelectedAndAdded {
                AddAudioButton(publicProperties: publicProperties, toolbar: true)
            }
            AddNewImage(viewModel: viewModel, inToolbar: true)
        }
    }
}

#Preview {
    let voicedImageModel = VoicedImageModel()
    @State var publicProperties = PublicAudioImageProperties.shared
    return InToolbarAfterSelection(viewModel: voicedImageModel, publicProperties: publicProperties)
}
