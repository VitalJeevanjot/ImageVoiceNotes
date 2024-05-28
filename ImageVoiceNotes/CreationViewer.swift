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
    
    //    @State private var imgDataReceived = Data()
    
    @State private var durationCheck = TimeInterval(0)
    
    @Environment (\.dismiss) private var dismiss
    
    @State private var pickedAudioDataURL: URL?
    @State private var pickedImageDataURL: URL?
    
    @State private var lineLimit = 1
    
//    @State private var imagePickedData = Data()
//    @State private var audioPickedData = Data()
    var isDemo = false
    
    let dir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var body: some View {
        
        ZStack {
            
            //            let pickedImageDataURL = dir.appendingPathComponent(receivedAudioImageModel.imagePicked, conformingTo: .image)
            
            
            //            let imgToShow = UIImage(data: imgDataReceived)
            if let imgToShow = UIImage(data: publicProperties.pickedImageData) {
                imageViewerWithZoomEtc(image: imgToShow, view: pdfView)
            }
            //            let imgToShow = UIImage(named: !isDemo ?  pickedImageDataURL.path() : receivedAudioImageModel.imagePicked)
            //            let _ = print("img to show 2...........")
            //            let _ = print("\(imgToShow2)")
            ////            Image(uiImage: imgToShow2!)
            //
            //            let imgToShow = UIImage(named: !isDemo ?  pickedImageDataURL.path() : receivedAudioImageModel.imagePicked)
            //            let _ = print("img to show 1...........")
            //            let _ = print("\(imgToShow)")
            
            //            imageViewerWithZoomEtc(image: imgToShow, view: pdfView)
            
            
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
                        
                        Text(receivedAudioImageModel.nameOfCreation)
                            .font(.headline)
                            .lineLimit(lineLimit)
                            .onTapGesture {
                                if lineLimit > 1 {
                                    lineLimit = 1
                                } else {
                                    lineLimit = 5
                                }
                            }
                        
                        Spacer()
                        
                        ShareLink(item: getSharableData() , preview: SharePreview(receivedAudioImageModel.nameOfCreation))
                            .foregroundStyle(.black)
                            .font(.title2)
                            .labelStyle(.iconOnly)
                            .padding([.leading, .trailing], 10)
                        
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
                    if publicProperties.durationTime > 0 {
                        AudioPlayer(publicProperties: publicProperties, onFront: true)
                            .backgroundStyle(Color(red: 212/255, green: 212/255, blue: 212/255))
                    }
                    
                }
            }
            
        }
        .background(.black)
        .onAppear {
            print("Task")
            print(isDemo)
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
                if !isDemo {
                    publicProperties.pickedAudioData = try Data(contentsOf: pickedAudioDataURL!)
                    print("Picked audio data, creationview")
                    publicProperties.pickedImageData = try Data(contentsOf: pickedImageDataURL!)
                    print("Picked image data creationviewer")
                } else {
                    let gotAudioData = NSDataAsset(name: "music")?.data
                    let gotImageData = NSDataAsset(name: "sampleImageData")?.data
                    publicProperties.pickedAudioData = gotAudioData!
                    print("Picked demo audio data, creationview")
                    
                    publicProperties.pickedImageData = gotImageData!
                    print("Picked demo image data creationviewer")
                }
                //                imgDataReceived = publicProperties.pickedImageData
                //                print("imgDataReceived")
                //                print(imgDataReceived)
                //                let sampleMusicData = NSDataAsset(name: "music")?.data
                publicProperties.audioPlayer = try AVAudioPlayer(data: publicProperties.pickedAudioData)
//                durationCheck = publicProperties.audioPlayer.duration
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
    
    func getSharableData() -> TransferableItem {
//        let nameOfCreationData = Data(receivedAudioImageModel.nameOfCreation.utf8)
//        
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .secondsSince1970
//        
//        var createdDateData: Data
//        
//        let separatorCode = Data([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11])
//        
//        var dataCreation = nameOfCreationData
//        dataCreation.append(separatorCode)
//        do {
//            createdDateData = try encoder.encode(receivedAudioImageModel.createdDate)
//            dataCreation.append(createdDateData)
//            dataCreation.append(contentsOf: separatorCode)
//        } catch {
//            print("err on date encoding to data is: \(error)")
//        }
//        
//        print("Appending rest.......")
//        // imagePickedData = try Data(contentsOf: pickedImageDataURL!)
//        dataCreation.append(publicProperties.pickedImageData)
//        dataCreation.append(contentsOf: separatorCode)
//        
//        
//        
//        //            audioPickedData = try Data(contentsOf: pickedImageDataURL!)
//        dataCreation.append(publicProperties.pickedAudioData)
////        dataCreation.append(contentsOf: separatorCode)
        
        
        //        let imagePickedData = try Data
        return TransferableItem(nameOfCreation: receivedAudioImageModel.nameOfCreation, imagePickedData: publicProperties.pickedImageData, audioPickedData: publicProperties.pickedAudioData, createdDate: receivedAudioImageModel.createdDate, isImported: true, importedDate: Date.now)
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
    @State var aim = AudioImageModel(nameOfCreation: "Sample nameasdasdasdascasdasdasdasdasd", imagePicked: "sampleImage", audioPicked: "music", createdDate: Date.now, isImported: false, importedDate: Date.now)
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
