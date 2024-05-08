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
    var pickedItem: Data
    var audioPicked: Data
    init(pickedItem: PhotosPickerItem, audio: AVAudioPlayer) {
        do {
            self.pickedItem = try Data(from: pickedItem as! Decoder)
        } catch {
            fatalError("Unable to Load Audio \(error)")
        }
        do {
            self.audioPicked = try Data(from: audio as! Decoder)
        } catch {
            fatalError("Unable to Load Audio \(error)")
        }
    }
}
