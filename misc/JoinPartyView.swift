//
//  CreatePartyView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/18/24.
//

import SwiftUI

struct JoinPartyView: View {
    var db = FirestoreController.shared
    var spotify = SpotifyController.shared
    @State var name: String = ""
    @Binding var state: String
    @State var err: String = " "
    
    
    
    var body: some View {
        VStack(alignment: .center){
            Text(err).foregroundColor(.red)
            TextField("Party Name", text: $name)
                .multilineTextAlignment(.center)
                .font(.title)
                .frame(width: 250, height: 40)
                .shadow(radius: 20)
                .padding(.bottom)
            
            LongRoundButton(action: {
                if name.isEmpty { return }
                Task{
                    print("Finding: \(name)")
                    guard var _ = await db.findParty(field: "name", val: name) else { err = "Party Not Found" ; return }
                    await joinParty()
                }
            }, label: "Join", background_color: .green)
            Button{
                if spotify.appRemote.isConnected {
                    state = "Create"
                }else{
                    state = "Spotify"
                }
            } label: {
                Text("Host party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            db.isHost = false
            db.stopTimer()
        })
    }
    
    func joinParty() async {
        db.listenToParty(name: name)
        db.incrementListener(name: name)
        state = "Guest"
    }
    
    
    
}

#Preview {
    @State var s = "Join"
    return JoinPartyView(state: $s)
}
