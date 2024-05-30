//
//  AlertBeforeDeletion.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 30/05/24.
//

import SwiftUI

struct AlertBeforeDeletion: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var item: AudioImageModel
    @Binding var showDeletionAlert: Bool
    var direc: URL
    
    var body: some View {
        
        Button(role: .cancel) {
            showDeletionAlert = false
        } label: {
            Text("Cancel")
        }
        
        Button(role: .destructive) {
            dismiss()
            do {
                try FileManager.default.removeItem(at: direc.appending(path: item.audioPicked))
            } catch {
                print("err while deleting audio file is: \(error)")
            }
            
            do {
                try FileManager.default.removeItem(at: direc.appending(path: item.imagePicked))
            } catch {
                print("err while deleting image file is: \(error)")
            }
            
            modelContext.delete(item)
            showDeletionAlert = false
        } label: {
            Text("Delete")
        }
    }
}

//#Preview {
//    AlertBeforeDeletion()
//}
