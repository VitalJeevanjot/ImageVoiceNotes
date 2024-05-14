//
//  InToolbarAfterSelection.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 03/05/24.
//

import SwiftUI

struct InToolbarAfterSelection: View {
    @ObservedObject var viewModel: ImageProperties
    var publicProperties: PublicAudioImageProperties
    
    var body: some View {
//        let _ = print("toolbar")
        HStack {
            if publicProperties.audioFileSelectedAndAdded {
                AddAudioButton(publicProperties: publicProperties, toolbar: true)
            }
            AddNewImage(viewModel: viewModel, inToolbar: true)
            
            if publicProperties.isReadyToPlayFull {
                Button {
                    print("full")
                } label: {
                    Label("Save", systemImage: "checkmark.square.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.brown)
                        .font(.title)
                    
                }
                
            }
            
        }
    }
}

#Preview {
    let voicedImageModel = ImageProperties()
    @State var publicProperties = PublicAudioImageProperties.shared
    return NavigationStack {
        InToolbarAfterSelection(viewModel: voicedImageModel, publicProperties: publicProperties)
    }
}

#Preview("Save button") {
    
    let voicedImageModel = ImageProperties()
    @State var publicProperties = PublicAudioImageProperties.shared
    publicProperties.isReadyToPlayFull = true
    publicProperties.audioFileSelectedAndAdded = true
    return NavigationStack {
        InToolbarAfterSelection(viewModel: voicedImageModel, publicProperties: publicProperties)
    }
}
