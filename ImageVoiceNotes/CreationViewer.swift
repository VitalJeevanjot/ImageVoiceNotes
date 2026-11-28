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

var fileCreated = false
var sanitizedNameForShareLinkPreview = ""

struct CreationViewer: View {
    //    var receivedAudioImageModel: AudioImageModel
    var receivedAudioImageModel: AudioImageModel
    
    @State private var pdfView = PDFView()
    
    @State private var showUI = true
    
    @State private var disappeared = false
    
    var publicProperties = PublicAudioImageProperties() // Must remain separate
    
    //    @State private var imgDataReceived = Data()
    
    @State private var durationCheck = TimeInterval(0)
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pickedAudioDataURL: URL?
    @State private var pickedImageDataURL: URL?
    
    @State private var lineLimit = 1
    
    @State private var showInfoPopup = false
    @State private var showDeleteAlert = false
    
    @State private var transferableItem: TransferableItem?

    var isDemo = false
    
    let dir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    @Environment(StatusBarValue.self) private var statusBarVal
    
    var body: some View {
//        let _ = print("RENDERING creation viewer......")
        ZStack {
            
            //            let pickedImageDataURL = dir.appendingPathComponent(receivedAudioImageModel.imagePicked, conformingTo: .image)
            
            
            //            let imgToShow = UIImage(data: imgDataReceived)
            if let imgToShow = UIImage(data: publicProperties.pickedImageData) {
                imageViewerWithZoomEtc(image: imgToShow, view: pdfView).ignoresSafeArea()
                    .onTapGesture {
                        showHideUI()
                    }
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
                        .padding([.trailing], 25)
                        
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
                        
                        //                        ShareLink("Title", items: getSharableData()) { NewType in
                        //                            SharePreview(sanitizedNameForShareLinkPreview)
                        //                        }
                        //                        .foregroundStyle(.black)
                        //                        .font(.title2)
                        //                        .labelStyle(.iconOnly)
                        //                        .padding([.leading, .trailing], 10)
                        if transferableItem != nil {
                            ShareLink(item: transferableItem!.fileToShare , preview: SharePreview(sanitizedNameForShareLinkPreview))
                                .foregroundStyle(.black)
                                .font(.title2)
                                .labelStyle(.iconOnly)
                                .padding([.leading, .trailing], 10)
                        }
                        
                        Button {
                            print("fit")
                            withAnimation {
                                pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
                            }
                            
                            //                fitImage.toggle()
                            //                print("\(fitImage)")
                        } label: {
                            Label("Fit image", systemImage: "square.dashed.inset.filled")
                                .foregroundStyle(.black)
                                .font(.title)
                                .labelStyle(.iconOnly)
                        }
                        //                        .buttonStyle(.borderedProminent)
                        //                        .tint(Color(red: 212/255, green: 212/255, blue: 212/255))
                    }
                    .padding(8)
                    .padding([.leading, .trailing], 7)
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
            
            
            Group { // Info and delete
                if showUI {
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                showInfoPopup = true
                            } label: {
                                Label("Information on creation", systemImage: "info.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 40))
                            }
                            Spacer()
                            Button {
//                                dismiss()
                                showDeleteAlert = true
                            } label: {
                                Label("Delete creation", systemImage: "xmark.bin.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 40))
                            }
                            .tint(.black)
                        }.padding()
                    }
                } 
//                else {
//                    let _ = print("UI FALSE......")
//                }
            }
        }
        .toolbar(.hidden)
        .alert("Delete \(receivedAudioImageModel.nameOfCreation)?",isPresented: $showDeleteAlert, presenting: receivedAudioImageModel) { item in
            AlertBeforeDeletion(item: receivedAudioImageModel, showDeletionAlert: $showDeleteAlert, direc: dir)
        }
        .sheet(isPresented: $showInfoPopup) {
            VStack(alignment: .leading) {
                HStack {
                    Text(receivedAudioImageModel.nameOfCreation)
                        .font(.title)
                        Spacer()
                        Button {
                            showInfoPopup = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                        }
                }.padding([.bottom], 15)
                Group {
                    Text("Imported")
                        .fontWeight(.bold)
                    Text(receivedAudioImageModel.isImported ? "Yes" : "No")
                        .padding([.bottom], 15)
                }
//                    .padding()
                
                if receivedAudioImageModel.isImported {
                    Group {
                        Text("Imported Date")
                            .fontWeight(.bold)
                        Text(receivedAudioImageModel.importedDate!, format: .dateTime)
                            .padding([.bottom], 15)
                    }
                        

                } else {
                    Group {
                        Text("Created Date")
                            .fontWeight(.bold)
                        Text(receivedAudioImageModel.createdDate, format: .dateTime)
                            .padding([.bottom], 15)
                    }
                }
            }.padding()
        }
        .background(.black)
        .onAppear {
//            dissapearingActions()
            fileCreated = false
            showUI = false
            statusBarVal.statusBarHidden = true
            print("Task")
            print(isDemo)
            sanitizedNameForShareLinkPreview = receivedAudioImageModel.nameOfCreation
            sanitizedNameForShareLinkPreview.removeAll(where: { !$0.isLetter && !$0.isNumber })
            
            //            print(try! FileManager.default.contentsOfDirectory(atPath: dir.appending(path: "Exports").path))
            
            //            var fileName = "KD23&*£*@)4-@1/ED"
            //            fileName.removeAll(where: { !$0.isLetter && !$0.isNumber })
            //            print(fileName.addingPercentEncoding(withAllowedCharacters: .letters))
            //            print("File name-----")
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
                
//                print("Before Picked audio data, creationview")
                if !isDemo {
                    publicProperties.pickedAudioData = try Data(contentsOf: pickedAudioDataURL!)
//                    print("Picked audio data, creationview")
                    publicProperties.pickedImageData = try Data(contentsOf: pickedImageDataURL!)
//                    print("Picked image data creationviewer")
                } else {
                    let gotAudioData = NSDataAsset(name: "music")?.data
                    let gotImageData = NSDataAsset(name: "sampleImageData")?.data
                    publicProperties.pickedAudioData = gotAudioData!
//                    print("Picked demo audio data, creationview")
                    
                    publicProperties.pickedImageData = gotImageData!
//                    print("Picked demo image data creationviewer")
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
                
                transferableItem = getSharableData()
            } catch {
                print("Audio data not loaded on creation view err is: \(error)")
            }
            autoHideUIWhenNotpaused()
            
            // Start auto play audio on full screen
            publicProperties.audioPlayer.play()
            publicProperties.isPlaying = true
            
        }
        .onDisappear() {
            dissapearingActions()
        }
        
//        .onTapGesture {
//            showHideUI()
//        }
        //        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
            pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
//            print("Orientation changed")
            
        })
    }
    func dissapearingActions() {
//        print("<<<<<<Dissapearing>>>>>")
        publicProperties.audioPlayer.stop()
        publicProperties.isPlaying = false
        publicProperties.audioFileSelectedAndAdded = false
        publicProperties.isReadyToPlayFull = false
    }
    
    func getSharableData() -> TransferableItem {
        print("Sharable....")
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
        if FileManager.default.fileExists(atPath: dir.appending(path: "Exports").path(percentEncoded: false)) {
            do {
                try FileManager.default.removeItem(at: dir.appending(path: "Exports"))
            } catch {
                print("err on removing exports directory at sharelink start is: \(error)")
            }
        }
        
//        print("In ShareLINK....")
        let data = FileToSaveWith(nameOfCreation: receivedAudioImageModel.nameOfCreation, imagePickedData: publicProperties.pickedImageData, audioPickedData: publicProperties.pickedAudioData, createdDate: receivedAudioImageModel.createdDate, isImported: true, importedDate: Date.now)
        
        var fileName = receivedAudioImageModel.nameOfCreation
        fileName.removeAll(where: { !$0.isLetter && !$0.isNumber })
        let exportsPathURL = dir.appending(path: "Exports")
        let filePathURL = exportsPathURL.appending(component: "\(fileName).picmik")
        //        print(exportsPathURL.path(percentEncoded: false))
        if fileCreated == false {
            do {
                if !FileManager.default.fileExists(atPath: exportsPathURL.path(percentEncoded: false)) {
                    try FileManager.default.createDirectory(atPath: exportsPathURL.path(percentEncoded: false), withIntermediateDirectories: true)
                }
            } catch {
                print("err on creating directory for exporing content is: \(error)")
            }
            
            
            do {
                if FileManager.default.fileExists(atPath: filePathURL.path(percentEncoded: false)) {
                    try FileManager.default.removeItem(at: filePathURL)
                }
            } catch {
                print("err on deleting file for exporing content is: \(error)")
            }
            
            do {
                try data.write(to: filePathURL)
                fileCreated = true
            } catch {
                print("Error saving .picmik file for sharing: \(error)")
            }
        }
        //        do { // For if Data representation
        //            let fileData = try Data(contentsOf: filePathURL)
        //            return [TransferableItem(fileToShare: fileData)]
        //        } catch {
        //            print("err reading data for Sharelink Transferable is: \(error)")
        //        }
//        print(filePathURL)
        return TransferableItem(fileToShare: filePathURL)
    }
    
    func showHideUI() {
        withAnimation {
            showUI.toggle()
        }
        statusBarVal.statusBarHidden = !showUI
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
                    statusBarVal.statusBarHidden = true
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
