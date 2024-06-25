//
//  GuestView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct GuestView: View {
    var db = FirestoreController.shared
    @Binding var state: String
    var body: some View {
        VStack{
            Spacer()
            LongRoundButton(action: leave, label: "Leave Party", background_color: .red)
            Spacer()
        }
    }
    
    func leave(){
        db.resetListener()
        state = "Join"
    }
    
}

#Preview {
    @State var s = "Guest"
    return GuestView(state: $s)
}
