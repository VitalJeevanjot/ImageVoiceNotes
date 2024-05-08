//
//  AddNewImage.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 24/04/24.
//

import SwiftUI
import PhotosUI



struct AddNewImage: View {

   
    @ObservedObject var viewModel: VoicedImageModel
    @Environment (\.dismiss) private var dismiss
    var inToolbar = false

    var body: some View {
        
        PhotosPicker(
            selection: $viewModel.pickedItem,
            matching: .images,
            preferredItemEncoding: .current,
            photoLibrary: .shared()
        ) {
            VStack {
                Image(systemName: "photo.badge.plus.fill")
                    .symbolRenderingMode(.monochrome)
                    .apply {
                        if !inToolbar {
                            $0.font(.system(size: 100))
                        } else {
                            $0.font(.system(size: 24))
                                .offset(x:0, y: 2)
                        }
                    }
                
                if !inToolbar
                {
                    Text("Add image")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                }
                    
//                    .fontDesign()
            }
            .foregroundStyle(.black)

            
        }
    }
}



#Preview {
    @StateObject var vm = VoicedImageModel()
    return AddNewImage(viewModel: vm)
}

#Preview("in toolbar") {
    @StateObject var vm = VoicedImageModel()
    return AddNewImage(viewModel: vm, inToolbar: true)
}
