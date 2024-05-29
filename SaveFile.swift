//
//  SaveFile.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 29/05/24.
//

import Foundation

func SaveFiles(audioData: Data, imageData: Data, uuidForAudio: String, uuidForImage: String) {
    let pickedAudioDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(uuidForAudio, conformingTo: .audio)
    let pickedImageDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(uuidForImage, conformingTo: .image)


    do {
        try audioData.write(to: pickedAudioDataURL)
        try imageData.write(to: pickedImageDataURL)
    } catch {
        print("On file saving err is: \(error)")
    }
}
