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
    var fileToShare: URL
    
    init(fileToShare: URL) {
        self.fileToShare = fileToShare
    }
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .imagesong) { Transferable in
            SentTransferredFile(Transferable.fileToShare)
        } importing: { ReceivedTransferredFile in
            print(">>>>>>>>>Importing<<<<<<<<<")
            return TransferableItem(fileToShare: ReceivedTransferredFile.file)
        }

//        CodableRepresentation(contentType: .imageSong)
//        DataRepresentation(contentType: .imageSong) { Transferable in
//            return TransferableItem(data1: Transferable.data1, data2: Transferable.data2)
//        } importing: { <#Data#> in
//            <#code#>
//        }

//        DataRepresentation(contentType: .imageSong) { transferData in
//            return transferData.fileToShare
//        } importing: { Data in
//            return TransferableItem(fileToShare: Data)
//        }

    }
}

struct FileToSaveWith: Codable {
    var nameOfCreation: String
    var imagePickedData: Data
    var audioPickedData: Data
    var createdDate: Date
    var isImported: Bool
    var importedDate: Date
}





extension UTType {
    static var imagesong: UTType {
        .init(exportedAs: "com.jeevanjotsinghvital.imagesong")
    }
}
