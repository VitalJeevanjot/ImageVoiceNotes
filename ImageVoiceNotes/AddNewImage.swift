//
//  AddNew.swift
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
                            $0.font(.system(size: 20))
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
//        .onChange(of: viewModel.pickedItemIdentifier) { oldValue, newValue in
//                dismiss()
//        }
//        .onChange(of: $viewModel.pickedItem) { oldValue, newValue in
//            viewModel.pickedItemIdentifier = newValue.wrappedValue?.itemIdentifier ?? ""
//        }
//        .onChange(of: $viewModel.pickedItem) { newValue in
//            newValue?.loadTransferable(type: Data.self) {
//                result in
//                switch result {
//                case .success(let dt):
//                    uiimage = UIImage(data: dt!)
//                    isImported = true
//                case .failure(let err):
//                    print(err)
//                }
//            }
//        }
        
    }
}

extension View {
    func apply<V: View> (@ViewBuilder _ block:(Self) -> V) -> V {block (self)}
}

#Preview {
    @StateObject var vm = VoicedImageModel()
    return AddNewImage(viewModel: vm)
}

#Preview("in toolbar") {
    @StateObject var vm = VoicedImageModel()
    return AddNewImage(viewModel: vm, inToolbar: true)
}
