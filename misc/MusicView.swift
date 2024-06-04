//
//  AlbumCover.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

struct MusicView: View {
    @StateObject var spotify: SpotifyController = SpotifyController.shared
    var db = FirestoreController.shared
    var albumCoverImage: String = "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
    @Binding var showMusicView: Bool
    var body: some View {
        ZStack{
            VStack {
                VStack{
                    HStack{
                        Button {
                            // invisible just to balance out the title
                        } label: {
                            Text(" ")
                        }
                        Spacer()
                        Text(db.party?.name ?? "The Dog House")
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
                            Text(spotify.currentTrackName ?? "  ")
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
                        AsyncImage(url: URL(string: db.party != nil ? "https://i.scdn.co/image/\(String(db.party!.image.split(separator: ":").last!))" : albumCoverImage)) { image in
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
            .onChange(of: spotify.currentTrackURI, {
                 handleTrackChange()
            })
        }
    }
    
    func handleTrackChange () {
            if let party = db.party {
                 db.updateParty(name: party.name, data: [
                        "currentTrack": spotify.currentTrackName!,
                        "image": spotify.currentTrackImageURI
                    ])
                db.incrementPlayed()
            }
        }
}

#Preview {
    @State var b = true
    return MusicView(showMusicView: $b)
}

