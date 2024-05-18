//
//  Authentication.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var spotify: SpotifyController
    @State var party_code: String = ""
    var hosting: Bool = true
    @State var creatingParty = true
    
    
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
            if spotify.appRemote.isConnected && hosting {
                if creatingParty {
                    CreatePartyView(presentView: $creatingParty)
                }else{
                    HostView()
                }
            }
            else{
                Text("Host a party")
                LongRoundButton(action: {
                    if !spotify.appRemote.isConnected {
                        spotify.connect()
                    }
                },icon: true ,label: "Sign in with Spotify", icon_name: "SpotifyLogo", system_icon: false)
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            Spacer()
            Spacer()
            Spacer()
        }.onChange(of: spotify.appRemote.isConnected, handleChange)
    }
    
    func handleChange(){
        print("change")
    }
}

#Preview {
    HomeView(spotify: SpotifyController())
}
