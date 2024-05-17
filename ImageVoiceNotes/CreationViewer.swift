//
//  CreationViewer.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 17/05/24.
//

import SwiftUI
import PDFKit
import SwiftData


struct CreationViewer: View {
    //    var receivedAudioImageModel: AudioImageModel
    let receivedAudioImageModel = AudioImageModel(nameOfCreation: "Sample name", imagePicked: "sampleImage", audioPicked: "music", createdDate: Date.now, isImported: false, importedDate: Date.now)
    @Query private var aim: [AudioImageModel]
    @State private var pdfView = PDFView()
    
    var body: some View {
        ZStack {
            //            let imgToShow = UIImage(named: receivedAudioImageModel.imagePicked)
            
            //            let _ = print("djek")
            ////            let _ = print("\(aim[0])")
            ////            let _ = print("\(aim)")
            //            let _ = print("/djek")
            var imgToShow: UIImage {
                if !aim.isEmpty {
                    print("HEre")
                    if !aim[0].imagePicked.isEmpty {
                        return UIImage(named: aim[0].imagePicked)!
                        
                    } else {
                        return UIImage(named: receivedAudioImageModel.imagePicked)!
                    }
                } else {
                    print("HEre or")
                    return UIImage(named: receivedAudioImageModel.imagePicked)!
                }
            }
            
            imageViewerWithZoomEtc(image: imgToShow, view: pdfView)

            
            Button {
                print("fit")
                pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
//                fitImage.toggle()
//                print("\(fitImage)")
            } label: {
                Label("fit", systemImage: "square.dashed.inset.filled")
                    .foregroundStyle(.black)
            }
            .buttonStyle(.borderedProminent)
            //            Image(uiImage: imgToShow)
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .shadow(radius: 10)
            
            
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    
    //    return CreationViewer(receivedAudioImageModel: sampleModel)
    return CreationViewer()
}



struct imageViewerWithZoomEtc: UIViewRepresentable {
    
    var image: UIImage?
    var view = PDFView()
        
    func makeUIView(context: Context) -> PDFView {
        view.document = PDFDocument()
        guard let page = PDFPage(image: image!) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
//        view.scaleFactor = 1
        return view
    }
    
    func callingMe() {
        print(view.scaleFactor)
        view.scaleFactor = 1
//        view.scaleFactor = view.scaleFactorForSizeToFit
//        view.zoomOut(Any?)
        //        print("Callingme form creationViewer")
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
        
    }
}
