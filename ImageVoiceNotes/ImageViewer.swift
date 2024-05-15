//
//  ImageViewer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 25/04/24.
//

import SwiftUI

struct ImageViewer: View {
    @StateObject private var voicedImageModel = ImageProperties()
    @State private var publicProperties = PublicAudioImageProperties.shared
    
    @Environment (\.dismiss) private var dismiss
    var demo: Bool
    
    init(diemo: Bool = false) {
        self.demo = diemo
    }
    
    var body: some View {
//        let _ = print("rendering image viewer")
        Group {
            if  voicedImageModel.pickedItemIdentifier.isEmpty && !demo {
                AddNewImage(viewModel: voicedImageModel)
            } else {
                VStack {
//                    Text("Hello")
                    ImageViewing(viModel: voicedImageModel,publicProperties: publicProperties,  isDemo: demo)
                        .padding([.bottom], 50)
                    AddNewAudio(publicProperties: publicProperties)
                    Spacer()
//                    let _ = print("is ready to play ? \(publicProperties.isReadyToPlayFull)")
                    if publicProperties.isReadyToPlayFull {
                        MainPlayerButtonAndScreen(publicProperties: publicProperties, viModel: voicedImageModel)
                            .padding()
                    }

                }
                .toolbar {
                    ToolbarItem {
                        InToolbarAfterSelection(viewModel: voicedImageModel, publicProperties: publicProperties)
                    }
                    
//                    if publicProperties.isReadyToPlayFull { 
//                        ToolbarItem {
//                            AddNewAudio(publicProperties: publicProperties)                        }
//
//                    }
                }
                
            }

            
        }
        .toolbar {
            // show it only if viewing, not while creating.
            ToolbarItem {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.bin.fill")
                }
            }
        }

    }
    
    
}

struct ImageViewing: View {
    @ObservedObject var viModel: ImageProperties
    var publicProperties: PublicAudioImageProperties
    var isDemo: Bool = false
    
    var body: some View {
//        let _ = print("image viewING running")

        VStack {
            switch viModel.imageStatus {
            case .finished(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding()

                
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            default:
//                Text("hello")
                ProgressView()
            }
//            let _ = print("getting view")
            
            if !isDemo {
                let _ = loadImage()
            }

            //            Spacer()
        }
        .onAppear {
            if !publicProperties.isReadyToPlayFull && isDemo {
                publicProperties.isReadyToPlayFull = true
            }
        }
    }
    
    func loadImage() {
        Task {
            await viModel.loadImage()
        }
        
    }
}

#Preview {
    ImageViewer(diemo: false)
}

#Preview {
    ImageViewer(diemo: true)
}
#Preview {
    Group {
        Image("sampleImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 10)
            .padding()
//            .resizable().aspectRatio(contentMode: .fit)
//            .clipShape(.rect(cornerRadius: 20))
//            .frame(maxWidth: (UIScreen.main.bounds.height - 20), maxHeight: (UIScreen.main.bounds.width - 20))
//            .shadow(radius: 10)
//            .padding()
        ImageViewer(diemo: true)
    }
}

