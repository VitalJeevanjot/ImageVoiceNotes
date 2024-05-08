//
//  BaseView.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 22/04/24.
//

import SwiftUI

struct BaseView: View {
    
    var body: some View {
        
        NavigationSplitView {
            Text("Listing something")
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        ImageViewer()
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .padding(4.0)
                                .background(.black)
                                .clipShape(.rect(cornerRadius: 4))
                                .tint(.accent)
                        }
                            
                    }
                    
                }
                
            }
            
        } detail: {
            Text("Selected items")
        }
        .tint(.black)

    }
    
}

extension View {
    func apply<V: View> (@ViewBuilder _ block:(Self) -> V) -> V {block (self)}
}



#Preview {
    BaseView()
}
