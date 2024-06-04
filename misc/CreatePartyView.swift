//
//  CreatePartyView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct CreatePartyView: View {
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
            Task {
                await createNewParty()
            }
            db.shouldRun = true
            db.startTimer()
            
        }, label: "Create", background_color: .green)
    }
    
    func createNewParty() async {
        await withCheckedContinuation { continuation in
            db.newParty(name: name) { result in
                continuation.resume()
                switch result {
                    case .success:
                        print("Party successfully created!")
                        state = "Host"
                    case .failure(let error):
                        print("Error creating party: \(error)")
                }
            }
        }
    }
    
    
    
}

#Preview {
    @State var s: String = "Test"
    return CreatePartyView(state: $s)
}
