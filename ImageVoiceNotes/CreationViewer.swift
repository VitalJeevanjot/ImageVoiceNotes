//
//  CreationViewer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 17/05/24.
//

import SwiftUI
import PDFKit
import SwiftData
import AVFAudio


struct CreationViewer: View {
    //    var receivedAudioImageModel: AudioImageModel
    var receivedAudioImageModel: AudioImageModel
    
    @State private var pdfView = PDFView()
    
    @State private var showUI = true
    
    @State private var disappeared = false
    
    var publicProperties = PublicAudioImageProperties()
    
    @State private var imgDataReceived = Data()
    
    @State private var durationCheck = TimeInterval(0)
    
    @Environment (\.dismiss) private var dismiss
    
    @State private var pickedAudioDataURL: URL?
    @State private var pickedImageDataURL: URL?
    
    
    var isDemo = false
    
    let dir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var body: some View {
        
        ZStack {
            
            //            let _ = print("djek")
            ////            let _ = print("\(aim[0])")
            ////            let _ = print("\(aim)")
            //            let _ = print("/djek")
            //            var imgToShow: UIImage {
            //                if !aim.isEmpty {
            //                    print("HEre")
            //                    if !aim[0].imagePicked.isEmpty {
            //                        return UIImage(named: aim[0].imagePicked)!
            //
            //                    } else {
            //                        return UIImage(named: receivedAudioImageModel.imagePicked)!
            //                    }
            //                } else {
            //                    print("HEre or")
            //                    return UIImage(named: receivedAudioImageModel.imagePicked)!
            //                }
            //            }
            //            let _ = print("before uiimage assigned")
            //            let _ = print("\( receivedAudioImageModel.imagePicked)")
            //            let _ = print("\(imgDataReceived)")
            //            let imgToShow = UIImage(data: imgDataReceived)
            //            let _ = print("after uiimage assigned")
            //
            
            let pickedImageDataURL = dir.appendingPathComponent(receivedAudioImageModel.imagePicked, conformingTo: .image)
            
            
            let imgToShow = UIImage(named: !isDemo ?  pickedImageDataURL.path() : receivedAudioImageModel.imagePicked)
            
            imageViewerWithZoomEtc(image: imgToShow, view: pdfView)
            
            if showUI {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                        .foregroundStyle(.black)
                        
                        Spacer()
                        
                        ShareLink(item: , preview: <#T##SharePreview<Transferable, Transferable>#>, label: <#T##() -> View#>)
                        
                        Button {
                            print("fit")
                            withAnimation {
                                pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
                            }
                            
                            //                fitImage.toggle()
                            //                print("\(fitImage)")
                        } label: {
                            Label("fit", systemImage: "square.dashed.inset.filled")
                                .foregroundStyle(.black)
                                .font(.title)
                                .labelStyle(.iconOnly)
                        }
                        //                        .buttonStyle(.borderedProminent)
                        //                        .tint(Color(red: 212/255, green: 212/255, blue: 212/255))
                    }
                    .padding()
                    .background(Color(red: 232/255, green: 232/255, blue: 232/255))
                    //                    .padding([.leading, .trailing, .bottom])
                    
                    //            Image(uiImage: imgToShow)
                    //                .resizable()
                    //                .aspectRatio(contentMode: .fit)
                    //                .shadow(radius: 10)
                    
                    Spacer()
                    if durationCheck > 0 {
                        AudioPlayer(publicProperties: publicProperties, onFront: true)
                            .backgroundStyle(Color(red: 212/255, green: 212/255, blue: 212/255))
                    }
                    
                }
            }
            
        }
        .background(.black)
        .onAppear {
            print("Task")
            //            defer {
            //                print("removing permission in creationViewer......>>,,,")
            //                publicProperties.pickedAudioDataURL!.stopAccessingSecurityScopedResource()
            //                publicProperties.pickedImageDataURL!.stopAccessingSecurityScopedResource()
            //            }
            //            pub
            do {
                print("Picked paths")
                print(receivedAudioImageModel.audioPicked)
                
                pickedAudioDataURL = dir.appendingPathComponent(receivedAudioImageModel.audioPicked, conformingTo: .audio)
                pickedImageDataURL = dir.appendingPathComponent(receivedAudioImageModel.imagePicked, conformingTo: .image)
//                print(pickedImageDataURL)
//                print(pickedAudioDataURL)
//                print(try Data(contentsOf: pickedAudioDataURL))
                //                guard publicProperties.pickedAudioDataURL!.startAccessingSecurityScopedResource() else {
                //                    print("cannot get permission to read audio file in creationViewer")
                //                    return
                //                }
                //
                //                guard publicProperties.pickedImageDataURL!.startAccessingSecurityScopedResource() else {
                //                    print("cannot get permission to read image file in creationViewer")
                //                    return
                //                }
                
                print("Before Picked audio data, creationview")
                
                publicProperties.pickedAudioData = try Data(contentsOf: pickedAudioDataURL!)
                print("Picked audio data, creationview")
                publicProperties.pickedImageData = try Data(contentsOf: pickedImageDataURL!)
                print("Picked image data creationviewer")
                imgDataReceived = publicProperties.pickedImageData
                print("imgDataReceived")
                print(imgDataReceived)
                publicProperties.audioPlayer = try AVAudioPlayer(data: publicProperties.pickedAudioData)
                durationCheck = publicProperties.audioPlayer.duration
                publicProperties.durationTime = publicProperties.audioPlayer.duration
                
                publicProperties.setUpTimer()
                //            print(
                publicProperties.audioPlayer.delegate = publicProperties
                publicProperties.isReadyToPlayFull = true
                publicProperties.isLoading = false
            } catch {
                print("Audio data not loaded on creation view err is: \(error)")
            }
            autoHideUIWhenNotpaused()
        }
        .onDisappear() {
            publicProperties.audioPlayer.stop()
            publicProperties.isPlaying = false
            publicProperties.audioFileSelectedAndAdded = false
            publicProperties.isReadyToPlayFull = false
        }
        
        .onTapGesture {
            showHideUI()
        }
        //        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
            pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
            
            print("Orientation changed")
            
        })
    }
    
    func getSharableData() {
        let nameOfCreationData = Data(receivedAudioImageModel.nameOfCreation.utf8)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        var createdDateData: Data
        var imagePickedData: Data
        var audioPickedData: Data
        do {
            createdDateData = try encoder.encode(receivedAudioImageModel.createdDate)
        } catch {
            print("err on date encoding to data is: \(error)")
        }
        
        do {
            imagePickedData = try Data(contentsOf: pickedImageDataURL!)
        } catch {
            print("err on imagePicked to data is: \(error)")
        }
        
        do {
            audioPickedData = try Data(contentsOf: pickedImageDataURL!)
        } catch {
            print("err on audioPicked to data is: \(error)")
        }
        
//        let imagePickedData = try Data
    }
    
    func showHideUI() {
        withAnimation {
            showUI.toggle()
        }
        autoHideUIWhenNotpaused()
        
    }
    func autoHideUIWhenNotpaused() {
        //        print(publicProperties.isPlaying)
        timer?.invalidate()
        if showUI && publicProperties.isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { Timer in
                if disappeared == false && publicProperties.isPlaying {
                    withAnimation {
                        showUI = false
                    }
                }
            }
        }
        
    }
    
}

#Preview {
    
    //    return CreationViewer(receivedAudioImageModel: sampleModel)
    @State var aim = AudioImageModel(nameOfCreation: "Sample name", imagePicked: "sampleImage", audioPicked: "music", createdDate: Date.now, isImported: false, importedDate: Date.now)
    return CreationViewer(receivedAudioImageModel: aim, isDemo: true)
}



struct imageViewerWithZoomEtc: UIViewRepresentable {
    
    var image: UIImage?
    var view = PDFView()
    
    func makeUIView(context: Context) -> PDFView {
        view.document = PDFDocument()
        guard let page = PDFPage(image: image!) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        view.backgroundColor = .black
        return view
    }
    
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
        
    }
}
