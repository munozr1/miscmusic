//
//  ContentView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var spotify: SpotifyController = SpotifyController.shared
    @State var showMusicView: Bool = false
    @State var musicViewHeight = 390
    var partyTitle: String = "The Dog House"
    
    
    
    var body: some View {
        ZStack{
            if showMusicView{
                if spotify.currentTrackImage != nil {
                    Image(uiImage: spotify.currentTrackImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 25)
                }
                Rectangle()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.gray)
                    .opacity(0.3)
            }
            VStack {
                
                if !showMusicView{
                    HomeView(spotify: spotify)
                }
                MusicView(showMusicView: $showMusicView)
                .frame(width: 390)
                    .transition(.move(edge: .bottom))
                Controls()
                    .frame(width: 410)
                    .foregroundColor(showMusicView ? .white : .gray)
                    .padding(.bottom, 15)
            }
        }.onChange(of: spotify.accessToken, handleChange)
    }
    
    func handleChange(){
        print("Access Token: \(spotify.accessToken ?? String("none"))")
    }
    
}

#Preview {
    ContentView(spotify: SpotifyController())
}
