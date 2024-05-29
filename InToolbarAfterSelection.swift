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
            
            if publicProperties.isReadyToPlayFull && publicProperties.requiresSave {
                Button {
                    saveFiles()
                    let dataToSave : AudioImageModel =
                    AudioImageModel(nameOfCreation: publicProperties.textOfCreation, imagePicked: publicProperties.pickedImageDataFileName, audioPicked: publicProperties.pickedAudioDataFileName, createdDate: Date.now, isImported: false, importedDate: nil)
//                    print("===========")
//                    print("\(String(describing: dataToSave))")
////                    print("\(publicProperties.pickedImageDataURL!.path())")
////                    print("\(publicProperties.pickedImageDataURL!)")
//                    print("----------")
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
        publicProperties.requiresSave = false
    }
    
    func saveFiles() {
        let audioData = publicProperties.pickedAudioData
        let imageData = publicProperties.pickedImageData
        let uuidForAudio = UUID().uuidString
        let uuidForImage = UUID().uuidString
        publicProperties.pickedAudioDataFileName = uuidForAudio
        publicProperties.pickedImageDataFileName = uuidForImage
        SaveFiles(audioData: audioData, imageData: imageData, uuidForAudio: uuidForAudio, uuidForImage: uuidForImage)
//        let pickedAudioDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(uuidForAudio, conformingTo: .audio)
//        let pickedImageDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(uuidForImage, conformingTo: .image)
//
//
//        do {
//            try audioData.write(to: pickedAudioDataURL)
//            try imageData.write(to: pickedImageDataURL)
//        } catch {
//            print("On file saving err is: \(error)")
//        }
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
