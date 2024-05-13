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
    var nameOfObject: String
    var imagePicked: String
    var audioPicked: String
    var createdDate: Date
    var importedDate: Date
    
    init(nameOfObject: String, imagePicked: String, audioPicked: String, createdDate: Date, importedDate: Date) {
        self.nameOfObject = nameOfObject
        self.imagePicked = imagePicked
        self.audioPicked = audioPicked
        self.createdDate = createdDate
        self.importedDate = importedDate
    }
    
//    init(nameOfObject: String, imagePicked: String, audioPicked: String, createdDate: Date) {
//        self.nameOfObject = nameOfObject
//        self.imagePicked = imagePicked
//        self.audioPicked = audioPicked
//        self.createdDate = createdDate
//    }
//    init(nameOfObject: String, imagePicked: String, audioPicked: String) {
//        self.nameOfObject = nameOfObject
//        self.imagePicked = imagePicked
//        self.audioPicked = audioPicked
//    }
    
//    init(nameOfObject: String, imagePicked: String, audioPicked: String, createdDate: Date, importedDate: Date) {
//        self.nameOfObject = nameOfObject
//        self.imagePicked = imagePicked
//        self.audioPicked = audioPicked
//        self.createdDate = createdDate
//        self.importedDate = importedDate
//    }
    
//    init(nameOfObject: String, imagePicked: String) {
//        self.nameOfObject = nameOfObject
//        self.imagePicked = imagePicked
//    }
}
