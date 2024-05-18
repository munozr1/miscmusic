//
//  CreatePartyView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct CreatePartyView: View {
    var db = FirestoreController.shared
    @Binding var presentView: Bool
    @State var name: String = ""
    var body: some View {
        TextField("Party Name", text: $name)
            .multilineTextAlignment(.center)
            .frame(width: 200)
            .shadow(radius: 20)
        
        LongRoundButton(action: {
            if name.isEmpty { return }
            Task {
                await createNewParty()
            }
        }, label: "Create", background_color: .green)
    }
    
    func createNewParty() async {
        await withCheckedContinuation { continuation in
            db.newParty(name: name) { result in
                continuation.resume()
                switch result {
                    case .success:
                        print("Party successfully created!")
                        presentView = false
                    case .failure(let error):
                        print("Error creating party: \(error)")
                }
            }
        }
    }
    
    
    
}

#Preview {
    @State var p = true
    return CreatePartyView(presentView: $p)
}
