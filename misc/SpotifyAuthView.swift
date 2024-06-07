//
//  SpotifyAuthView.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/4/24.
//

import SwiftUI

struct SpotifyAuthView: View {
    var db = FirestoreController.shared
    @ObservedObject var spotify = SpotifyController.shared
    @Binding var state: String
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
            Button{
                state = "Join"
            } label: {
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
        }// end outermost vstack
    }// end body
    
} // end view
#Preview {
    @State var s = "Spotify"
    return HomeView(state: $s)
}
