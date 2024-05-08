//
//  PickedImageSampleData.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 29/04/24.
//

import Foundation
import PhotosUI
import SwiftUI
import SwiftData

@Model
class PickedImageSampleData {
    var pickedItem: PhotosPickerItem
    init(picked: PhotosPickerItem) {
        self.pickedItem = picked
    }
    
}



