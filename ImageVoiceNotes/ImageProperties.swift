//
//  ImageProperties.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 24/04/24.
//

import SwiftUI
import PhotosUI

@MainActor final class ImageProperties: ObservableObject {

    @Published var pickedItem = Optional(PhotosPickerItem(itemIdentifier: "")) {
        didSet {
//            print(pickedItem!)
//            print(pickedItem!.itemIdentifier ?? "Nothing..")
            imageStatus = nil
            if pickedItem != nil {
                pickedItemIdentifier = pickedItem!.identifier
            }
        }
    }
    
    
    @Published var pickedItemIdentifier: String = ""
    
    @Published var imageStatus: Status?
    
    
        
    enum Status {
        case loading
        
        case finished(Image)
        
        case failed(Error)
        
        var isFailed:Bool {
            return switch self {
            case .failed: true
            default: false
            }
        }
    }
    
    enum LoadingError: Error {
        case contentTypeNotSupportedForTheApp
    }
    
    func loadImage() async {
        guard imageStatus == nil  || imageStatus?.isFailed == true else {
            return
        }
        
//        print("passed guard")
        imageStatus = .loading
        
        do {
            if let data = try await pickedItem?.loadTransferable(type: Data.self)
            {
                PublicAudioImageProperties.shared.pickedImageData = data
                if let uiImage = UIImage(data: PublicAudioImageProperties.shared.pickedImageData) {
                    imageStatus = .finished(Image(uiImage: uiImage))
                }
            } else {
                throw LoadingError.contentTypeNotSupportedForTheApp
            }
        } catch {
            imageStatus = .failed(error)
        }
    }
    
}

private extension PhotosPickerItem {
    var identifier: String {
        guard let identifier = itemIdentifier else {
            fatalError("Failed to load a photo library")
        }
        return identifier
    }
}
