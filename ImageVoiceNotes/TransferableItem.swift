//
//  TransferableItem.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 28/05/24.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct TransferableItem: Codable, Transferable {
    var nameOfCreation: String
    var imagePickedData: Data
    var audioPickedData: Data
    var createdDate: Date
    var isImported: Bool
    var importedDate: Date
    
    init(nameOfCreation: String, imagePickedData: Data, audioPickedData: Data, createdDate: Date, isImported: Bool, importedDate: Date) {
        self.nameOfCreation = nameOfCreation
        self.imagePickedData = imagePickedData
        self.audioPickedData = audioPickedData
        self.createdDate = createdDate
        self.isImported = isImported
        self.importedDate = importedDate
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .imageSong)
//        DataRepresentation(contentType: .imageSong) { Transferable in
//            return TransferableItem(data1: Transferable.data1, data2: Transferable.data2)
//        } importing: { <#Data#> in
//            <#code#>
//        }

//        DataRepresentation(contentType: .imageSong) { transferData in
//            return transferData.data
//        } importing: { Data in
//            return .init(data1: Data, data2: Data)
//        }

    }
}





extension UTType {
    static var imageSong: UTType {
        .init(exportedAs: "com.jeevanjotsinghvital.imageSong")
    }
}
