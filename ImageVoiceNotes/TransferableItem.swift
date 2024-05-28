//
//  TransferableItem.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 28/05/24.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct transferData: Transferable {
    var data: Data
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .imageSong) { transferData in
            return transferData.data
        } importing: { Data in
            return .init(data: Data)
        }

    }
}


extension UTType {
    static var imageSong: UTType {
        .init(exportedAs: "com.jeevanjotsinghvital.imageSong")
    }
}
