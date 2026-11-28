//
//  ContentCreationViewer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 25/04/24.
//

import SwiftUI

struct ContentCreationViewer: View {
    @StateObject private var voicedImageModel = ImageProperties()
    @State private var publicProperties = PublicAudioImageProperties.shared
        
    @Environment(\.dismiss) private var dismiss
    @State private var showBackButtonAlert = false

    var demo: Bool
    
    init(diemo: Bool = false) {
        self.demo = diemo
    }
    
    var body: some View {
//        let _ = print("rendering image viewer \(DateFormatter().string(from: Date.now))")
        Group {
            if  voicedImageModel.pickedItemIdentifier.isEmpty && !demo {
                AddNewImage(viewModel: voicedImageModel)
            } else {
                VStack {
//                    Text("Hello")
                    if publicProperties.isReadyToPlayFull {
                        TextField(text: $publicProperties.textOfCreation) {
                            Text("Name of creation.")
                        }
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(.brown)
                        .font(.title2)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                    }
                    
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if PublicAudioImageProperties.shared.requiresSave {
                        showBackButtonAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .tint(.black)
            }
        }
        .alert("Going back with unsaved changes?", isPresented: $showBackButtonAlert, actions: {
            Button(role: .destructive) {
                showBackButtonAlert = false
                dismiss()
            } label: {
                Text("Yes")
            }
            Button(role: .cancel) {
                showBackButtonAlert = false
            } label: {
                Text("No")
            }
        })
        .onDisappear(perform: {
            publicProperties.requiresSave = false
            publicProperties.textOfCreation = String(localized: "Untitled")
        })


//        .toolbar {
//            // show it only if viewing, not while creating.
//            ToolbarItem {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "xmark.bin.fill")
//                }
//            }
//        }

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
    NavigationStack {
        ContentCreationViewer(diemo: false)
    }
}

#Preview {
    ContentCreationViewer(diemo: true)
}
#Preview {
    NavigationStack {
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
            ContentCreationViewer(diemo: true)
        }
    }
}

