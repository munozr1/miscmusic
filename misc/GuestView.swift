//
//  GuestView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct GuestView: View {
    var db = FirestoreController.shared
    var body: some View {
        VStack{
            Spacer()
            LongRoundButton(action: db.resetListener, label: "Leave Party", background_color: .red)
            Spacer()
        }
    }
    
    
}

#Preview {
    GuestView()
}
