//
//  AddAudioButton.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 03/05/24.
//

import SwiftUI
import AVFAudio

struct AddAudioButton: View {
    @State private var presentFilePicker = false
    @State private var presentPopOver = false
    
    @Bindable var publicProperties: PublicAudioImageProperties
    var toolbar = false
    
    
    var body: some View {
        Button {
            presentPopOver = true
        } label: {
            Image(systemName: "waveform.badge.plus")
                .symbolRenderingMode(.monochrome)
                .apply {
                    if !toolbar {
                        $0.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 5))
                            .frame(maxWidth: 100)
                    } else {
                        $0.font(.system(size: 14))
                            .padding(EdgeInsets(top: 5, leading: 8, bottom: 3, trailing: 12))
                    }
                    
                }
                .background(Color.black)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.white)
        }
        .popover(isPresented: $presentPopOver) {
            popoverForAudioChoice(presentFilePicker: $presentFilePicker, presentPopOver: $presentPopOver, publicProperties: publicProperties)
        }
        .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.audio]) { result in
            switch result {
            case .success(let file):
                updateUIAfterAudioSelect()
                presentFilePicker = false
                publicProperties.requiresSave = true
                guard file.startAccessingSecurityScopedResource() else {
                    return
                }
                Task {
//                    print(file.pa)
                    await assignAudioPlayer(val: file)

//                    print("File exists/")
//                    print(FileManager.default.fileExists(atPath: URL(filePath: file.absoluteString).path))
//                    print(FileManager.default.fileExists(atPath: file.absoluteString))
//                    let url = URL.init(string: file.absoluteString)
//                    print(FileManager.default.fileExists(atPath: url!.path()))
//                    print(FileManager.default.fileExists(atPath: file.absoluteURL.path))
//                    print(URL(fileURLWithPath: file.absoluteString).path())
//                    print(file.absoluteString)
//                    print(file.absoluteURL)
//                    print(file.absoluteURL.path())
//                    print(file.absoluteURL.path)
//                    print("\\File exists")
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    func updateUIAfterAudioSelect() {
        publicProperties.isLoading = true
        publicProperties.audioFileSelectedAndAdded = true
//        presentFilePicker = false
    }
    
    
    func assignAudioPlayer(val: URL) async {
        
        defer {
            val.stopAccessingSecurityScopedResource()
//            publicProperties.selectedFilePathForAudio?.stopAccessingSecurityScopedResource()
        }
        
        print("Something---------")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("Something---------end")
        
//        publicProperties.selectedFilePathForAudio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(UUID().uuidString, conformingTo: .mp3)
        
//        guard publicProperties.selectedFilePathForAudio?.startAccessingSecurityScopedResource() != nil else {
//            print("Cannot access filepath for audi--------")
//            return
//        }
        do {
            
            publicProperties.pickedAudioData = try Data(contentsOf: val)
//            print("Path is:::::")
//            print(publicProperties.selectedFilePathForAudio)
//            try FileManager.default.copyItem(at: val, to: publicProperties.selectedFilePathForAudio!)
//            if {
//
//            }
//            print(":::::::::::Path is:::::")
//            print(publicProperties.selectedFilePathForAudio)
            
        } catch {
            print("err when saving data temporarily is: \(error)")
        }

        do {
            publicProperties.audioPlayer =  try AVAudioPlayer(data: publicProperties.pickedAudioData)
            //            print("2")
         
        } catch {
            //            print("2.5")
            print(error)
            publicProperties.isPlaying = false
            publicProperties.audioFileSelectedAndAdded = false
            publicProperties.isReadyToPlayFull = false
            publicProperties.isLoading = false
            
        }
        
        publicProperties.durationTime = publicProperties.audioPlayer.duration
        
        publicProperties.setUpTimer()
        //            print(
        publicProperties.audioPlayer.delegate = publicProperties
        publicProperties.isReadyToPlayFull = true
        publicProperties.isLoading = false
    }
    
}

#Preview {
    @State var publicproperties = PublicAudioImageProperties.shared
    return AddAudioButton(publicProperties: publicproperties)
}

#Preview("In toolbar") {
    @State var publicproperties = PublicAudioImageProperties.shared
    return AddAudioButton(publicProperties: publicproperties, toolbar: true)
}

