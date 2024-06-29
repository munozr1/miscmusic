//
//  SpotifyAuthView.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/4/24.
//

import SwiftUI

struct MusicPlayerAuthView: View {
    var db = FirestoreController.shared
    @ObservedObject var spotify = SpotifyController.shared
    @Binding var state: String
    @Binding var musicPlayer: (any MusicPlayer)?
    var body: some View {
        VStack{
            HStack{
                Text(" ")
                Spacer()
            }
            Text("Host a party")
                .multilineTextAlignment(.center)
                .font(.title)
                .shadow(radius: 20)
                .padding(.bottom)
            LongRoundButton(action: {
                if !spotify.appRemote.isConnected {
                    spotify.connect()
                } else {
                    state = "Create"
                }
            },icon: true ,label: "Sign in with Spotify", icon_name: "SpotifyLogo", system_icon: false)
            LongRoundButton(action: {
                musicPlayer = AppleMusicController()
                Task{
                    print("connecting to apple music")
                    await musicPlayer?.connect()
                }
                state = "Create"
            },icon: true ,label: "Sign in with Apple Music", icon_name: "apple.logo", system_icon: true)
            Button{
                state = "Join"
            } label: {
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
        }// end outermost vstack
        .onAppear(perform: {
            if(AuthenticationModel.shared.demo) {
                state = "Create"
            }
        })
    }// end body
    
} // end view

