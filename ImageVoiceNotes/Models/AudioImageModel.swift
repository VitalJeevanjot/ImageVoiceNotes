//
//  AudioImageModel.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 03/05/24.
//

import Foundation
import PhotosUI
import SwiftUI
import SwiftData


@Model
class AudioImageModel {
    var nameOfCreation: String
    var imagePicked: String
    var audioPicked: String
    var createdDate: Date
    var isImported: Bool
    var importedDate: Date?
    
    init(nameOfCreation: String, imagePicked: String, audioPicked: String, createdDate: Date, isImported: Bool, importedDate: Date? = nil) {
        self.nameOfCreation = nameOfCreation
        self.imagePicked = imagePicked
        self.audioPicked = audioPicked
        self.createdDate = createdDate
        self.isImported = isImported
        self.importedDate = importedDate
    }
}


