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
    @Environment (\.dismiss) private var dismiss
    @Environment (\.modelContext) private var modelContext

    
    var body: some View {
//        let _ = print("toolbar")
        HStack {
            if publicProperties.audioFileSelectedAndAdded {
                AddAudioButton(publicProperties: publicProperties, toolbar: true)
            }
            AddNewImage(viewModel: viewModel, inToolbar: true)
            
            if publicProperties.isReadyToPlayFull {
                Button {
                    saveFiles()
                    let dataToSave : AudioImageModel =
                    AudioImageModel(nameOfCreation: publicProperties.textOfCreation, imagePicked: publicProperties.pickedImageDataURL!.path(), audioPicked: publicProperties.pickedAudioDataURL!.path(), createdDate: Date.now, importedDate: nil)//
                    saveData(dataToSave)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark.square.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.brown)
                        .font(.title)
                    
                }
                
            }
            
        }
    }
    
    func saveData(_ model: AudioImageModel) {
        modelContext.insert(model)
    }
    
    func saveFiles() {
        let audioData = publicProperties.pickedAudioData
        let imageData = publicProperties.pickedImageData
        publicProperties.pickedAudioDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(UUID().uuidString, conformingTo: .audio)
        publicProperties.pickedImageDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(UUID().uuidString, conformingTo: .image)


        do {
            try audioData.write(to: publicProperties.pickedAudioDataURL!)
            try imageData.write(to: publicProperties.pickedImageDataURL!)
        } catch {
            print("On file saving err is: \(error)")
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
