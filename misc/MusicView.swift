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
        VStack(alignment: .center){
                    HStack{
                        Button {
                            // invisible just to balance out the title
                        } label: {
                            Text(" ")
                        }
//                        Spacer()
                        Text(db.party?.name ?? "The Dog House")
                            .font(.system(size: 15, design: .monospaced))
//                        Spacer()
                        Button {
                            showMusicView.toggle()
                        } label: {
                            Label("music", systemImage: showMusicView ? "chevron.down" : "chevron.up")
                                .labelStyle(.iconOnly)
                        }
                        
                    }.foregroundColor(showMusicView ? .white : .gray)
                
                if showMusicView {
                    VStack(alignment: .leading){
                        HStack{
                            Text(spotify.appRemote.isConnected ? spotify.currentTrackName ?? "Track Name" : db.party?.currentTrack ?? "Track Name")
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                        }.padding(.leading)
                            .foregroundColor(.white)
                        HStack {
                            Text(spotify.appRemote.isConnected ? spotify.currentTrackArtist ?? "Artist" : db.party?.artist ?? "Artist")
                                .fontWeight(.semibold)
                        }.padding(.leading)
                            .foregroundColor(.white)
                        HStack {
                            Spacer()
                            if spotify.currentTrackImage == nil{
                                AsyncImage(url: URL(string: db.party != nil ? "https://i.scdn.co/image/\(String(db.party!.image.split(separator: ":").last!))" : albumCoverImage)) { image in
                                    image
                                        .shadow(radius: 10)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            }else{
                                Image(uiImage: spotify.currentTrackImage!)
                                    .shadow(radius: 10)
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }.padding(.top)
                        
                        Spacer()
                    }.padding().gesture(
                        DragGesture().onEnded { gesture in
                            if gesture.translation.height < 0 {
                                // Swipe Up
                            } else if gesture.translation.height > 0 {
                                // Swipe Down
                                showMusicView = false
                            }
                        }
                    )
                }// end if showMusic
                    
            }
            .onChange(of: spotify.currentTrackURI, {handleTrackChange()})
            
        
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

