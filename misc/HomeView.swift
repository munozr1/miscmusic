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
    @Binding var state: String
    @State private var menu: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Button{
                        menu.toggle()
                    } label : {Image(systemName: "person")}
                        .foregroundColor(.black)
                        
                }
//                .padding(.leading, 24)
                Spacer()
//                Image(systemName: "gearshape")
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
                    if spotify.appRemote.isConnected {
                        spotify.disconnect()
                    }
                    state = "Join"
                } label: {
                Text("Join party instead")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                }
            case "Join":
                JoinPartyView(state: $state)
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
                GuestView(state: $state)
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
            default:
                HostView(state: $state)
        
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .overlay(
                    VStack {
                        if menu {
                            VStack {
                                Button{
                                    state = "Spotify"
                                    AuthenticationModel.shared.signout()
                                } label: {
                                    Text("Sign out")
                                        .padding(.top, 7)
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(width: 70, height: 50)
                            .background(.white)
                            .clipShape(Menu())
                            .cornerRadius(5)
                            .shadow(radius: 2)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: menu)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, 50) // Adjust the padding as needed
//                    .padding(.leading, 5)
                )
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
