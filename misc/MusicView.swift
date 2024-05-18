//
//  AlbumCover.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

struct MusicView: View {
    @StateObject var spotify: SpotifyController = SpotifyController.shared
    var albumCoverImage: String = "https://i.scdn.co/image/ab67616d00001e027567ec7d3c07783e4f2111e0"
    var partyTitle: String = "The Dog House"
    @Binding var showMusicView: Bool
    var body: some View {
        ZStack{
            VStack {
                VStack{
                    HStack{
                        Spacer()
                        Text(partyTitle)
                            .font(.system(size: 15, design: .monospaced))
                        Spacer()
                        Button {
                            showMusicView.toggle()
                        } label: {
                            Label("music", systemImage: showMusicView ? "chevron.down" : "chevron.up")
                                .labelStyle(.iconOnly)
                        }
                        
                    }.foregroundColor(showMusicView ? .white : .gray)
                    .padding(.bottom, 15)
                    if showMusicView && spotify.appRemote.isConnected{
                        HStack {
                            Text(spotify.currentTrackName ?? " ")
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        HStack {
                            Text(spotify.currentTrackArtist ?? " ")
                                .padding(.bottom, 50)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                }.foregroundColor(.white)
                
                if showMusicView {
                    if spotify.currentTrackImage == nil{
                        AsyncImage(url: URL(string: albumCoverImage)) { image in
                            image
                                .shadow(radius: 10)
                        } placeholder: {
                            ProgressView()
                        }
                    }else{
                        Image(uiImage: spotify.currentTrackImage!)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .onChange(of: spotify.currentTrackURI, handleTrackChange)
        }
    }
    
    func handleTrackChange(){
        print(spotify.currentTrackURI!)
        print(spotify.currentTrackName!)
        print("changed")
    }
}

#Preview {
    @State var b = true
    return MusicView(showMusicView: $b)
}

