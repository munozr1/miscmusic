//
//  Authentication.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var spotify = SpotifyController.shared
    @StateObject var db = FirestoreController.shared
    @State var party_code: String = ""
    @State var state: String = "Spotify"
    @Binding var hosting: Bool
    
    
//    init(hosting: Bool){
//        self.hosting = hosting
//        if spotify.appRemote.isConnected{
//            state = "Create"
//        }
//    }
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "person")
                Spacer()
                Image(systemName: "gearshape")
            }
            .padding(.top, 10)
            .frame(width: 350)
            Spacer()
            Spacer()
            Spacer()
            
            switch state {
            case "Create":
                CreatePartyView(state: $state)
                Button{
                    state = "Join"
                } label: {
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                }
            case "Join":
                JoinPartyView()
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
            case "Host":
                HostView(state: $state)
            case "Guest":
                GuestView()
            case "Spotify":
                Text("Host a party")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .frame(width: 250, height: 40)
                    .shadow(radius: 20)
                    .padding(.bottom)
                LongRoundButton(action: {
                    if !spotify.appRemote.isConnected {
                        spotify.connect()
                    }
                },icon: true ,label: "Sign in with Spotify", icon_name: "SpotifyLogo", system_icon: false)
                Button{
                    state = "Join"
                } label: {
                    Text("Join party instead")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            default:
                HostView(state: $state)
        
            }
            Spacer()
            Spacer()
            Spacer()
        }.onChange(of: spotify.appRemote.isConnected, handleChange)
    }
    
    func handleChange(){
        if spotify.appRemote.isConnected {
            state = "Create"
        }
        print("change")
    }
}

#Preview {
    @State var h = false
    return HomeView(hosting: $h)
}
