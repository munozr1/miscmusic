//
//  Authentication.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var spotify = SpotifyController.shared
    @StateObject var db = FirestoreController.shared
    @State var party_code: String = ""
    @Binding var state: String
    
    
    var body: some View {
            VStack(alignment: .center){
                switch state {
                case "Create":
                    CreatePartyView(state: $state)
                case "Join":
                    JoinPartyView(state: $state)
                case "Host":
                    HostView(state: $state)
                case "Guest":
                    GuestView(state: $state)
                case "Spotify":
                    SpotifyAuthView(state: $state)
                default:
                    HostView(state: $state)
                    
                }
            }
            .onChange(of: spotify.appRemote.isConnected, handleChange)
    }
    
    func handleChange(){
        if spotify.appRemote.isConnected {
            state = "Create"
        }
        print("change")
    }
}

#Preview {
    @State var h = "Spotify"
    return HomeView(state: $h)
}
