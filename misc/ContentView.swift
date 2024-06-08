//
//  ContentView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var spotify: SpotifyController = SpotifyController.shared
    var db = FirestoreController.shared
    @State var showMusicView: Bool = false
    @State var musicViewHeight = 390
    @State var isHost: Bool = false
    @State var showQueue: Bool = false
    @State var state = "Spotify"
    @State var timer: Timer?
    @State var menu: Bool = false
    var authModel: AuthenticationModel
    var albumCover: String = "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
    
    var body: some View {
        ZStack(alignment: .bottom){
            if authModel.authenticated == .loggedin{
                
                if showMusicView{
                        if spotify.currentTrackImage != nil {
                            Image(uiImage: spotify.currentTrackImage!)
                                .resizable()
                                .blur(radius: 25)
                        }else {
                            AsyncImage(url: URL(string: db.party?.image != nil ? "https://i.scdn.co/image/\(String(db.party!.image.split(separator: ":").last!) )" : albumCover)) { image in
                                image
                                    .resizable()
                                    .ignoresSafeArea()
                                    .blur(radius: 25)
                            } placeholder: {}
                        }
                    Rectangle()
//                            .aspectRatio(contentMode: .fill)
//                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(.gray)
                            .opacity(0.3)
                            .ignoresSafeArea()
//                    }.transition(.move(edge: .bottom))
                }// END If showMusicView
                
//                ZStack{
                    VStack(alignment: .center) {
                        if !showMusicView{
                            HStack{
                                Button{
                                    menu.toggle()
                                } label: {
                                    Image(systemName: "line.3.horizontal")
                                        .resizable()
                                        .foregroundColor(.primary)
                                        .frame(width: 22, height: 15)
                                }.padding()
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            HomeView(state: $state)
                        }
                        
                        Spacer()
                        MusicView(showMusicView: $showMusicView)
                        Controls(state: $state, showQueue: $showQueue)
                            .frame(width: 430)
                            .foregroundColor(showMusicView ? .white : .gray)
                            .padding(.bottom, 15)
                    }
//                }
                
            }// END If Auth
            else{
                AuthView(model: authModel)
            }
            QueueView(showQueue: $showQueue).frame(maxWidth: .infinity, maxHeight: 500).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            SideMenu(isShowing: $menu, content: AnyView(SideMenuView(presentSideMenu: $menu, state: $state)))
            
        }// END ZStack
//        .frame(maxWidth: 393)
        .animation(.easeInOut, value: showMusicView)
        .ignoresSafeArea(.keyboard)
        .onChange(of: spotify.accessToken, handleChange)
        
    }
    
    func handleChange(){
        print("Access Token: \(spotify.accessToken ?? String("none"))")
    }
    
    
    
    
}

#Preview {
    ContentView(spotify: SpotifyController(), authModel: AuthenticationModel())
}
