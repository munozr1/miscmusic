//
//  CreatePartyView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct CreatePartyView: View {
    var db = FirestoreController.shared
    var spotify = SpotifyController.shared
    @State var name: String = ""
    @Binding var state: String
    @State var err: String = ""
    
    var body: some View {
        Text(err).foregroundColor(.red)
        VStack(alignment: .center){
            TextField("Party Name", text: $name)
                .multilineTextAlignment(.center)
                .font(.title)
                .frame(width: 250, height: 40)
                .shadow(radius: 20)
                .padding(.bottom)
            
            LongRoundButton(action: {
                if name.isEmpty { return }
                Task {
                    if let _ = await db.findParty(field: "name", val: name) {
                        err = "Name Taken"
                        return
                    }
                    await createNewParty()
                    db.shouldRun = true
                    db.startTimer()
                    db.isHost = true
                }
            }, label: "Create", background_color: .green)

            Button{
                if spotify.appRemote.isConnected {
                    spotify.disconnect()
                }
                state = "Join"
            } label: {
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: {
            print("Create Party View appeared")
            Task{
                await handleExistingParty()
            }
        })
        .ignoresSafeArea(.keyboard)
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
    
    func handleExistingParty() async {
        print("handleExistingParty()")
        db.isHost = true
        //guard let host = db.party?.host else { return }
        //if host == usr { state = "Host" }
        guard let uid = AuthenticationModel.shared.user?.uid else {return}
        guard let documents = await db.findParty(field: "host", val: uid) else { print("No existing parties found");return}
        if let firstDocument = documents.first {
            do {
                let party = try firstDocument.data(as: SpotifyParty.self)
                db.listenToParty(name: party.name)
                state = "Host"
                print("The first party name is: \(party.name)")
            } catch {
                print("Error decoding party: \(error)")
            }
        } else {
            print("No documents in the result.")
        }
        
    }
    
    
    
}

#Preview {
    @State var s: String = "Test"
    return CreatePartyView(state: $s)
}
