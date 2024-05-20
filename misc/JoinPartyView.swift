//
//  CreatePartyView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct JoinPartyView: View {
    var db = FirestoreController.shared
    @State var name: String = ""
    @Binding var state: String
    var body: some View {
        TextField("Party Name", text: $name)
            .multilineTextAlignment(.center)
            .font(.title)
            .frame(width: 250, height: 40)
            .shadow(radius: 20)
            .padding(.bottom)
        
        LongRoundButton(action: {
            if name.isEmpty { return }
            joinParty()
        }, label: "Join", background_color: .green)
    }
    
    func joinParty() {
        db.listenToParty(name: name)
        db.incrementListener(name: name)
        print("Join Party View")
        state = "Guest"
    }
    
    
    
}

#Preview {
    @State var s = "Join"
    return JoinPartyView(state: $s)
}
