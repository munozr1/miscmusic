//
//  Controls.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

import SwiftUI

struct Controls: View {
    @ObservedObject var spotify = SpotifyController.shared
    var db = FirestoreController.shared
    @State var voted: Bool = false
    @Binding var host: Bool
    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Button{
                print("show queue")
            } label:{
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            }
            Spacer()
            HStack{
                Button {
//                    pause.toggle()
                    if spotify.currentTrackPaused {
                        spotify.resume()
                    }else{
                        spotify.pause()
                    }
                } label: {
                    Image(systemName: !spotify.currentTrackPaused ? "pause"  : "play")
                        .resizable()
                        .padding(.leading, spotify.currentTrackPaused ? 5 : 0)
                        .frame(width: 30, height: 30)
                }
                .padding()
                .background(.opacity(0.03))
                .clipShape(Circle())
            }
            
            Spacer()
            
            Button{
                if spotify.appRemote.isConnected {
                    spotify.skipTrack()
                }else{
//                    Task{
                        handleGuestSkip(s: true)
//                    }
                }
            }label :{
                Image(systemName: "forward.end")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Spacer()
            Spacer()
        }.onChange(of: db.party?.voteSkips, {
            if host && Float(db.party!.listeners) / Float(db.party!.voteSkips)  > 0.5 {
                spotify.skipTrack()
            }
        })
    }
    
    func handleGuestSkip(s: Bool) {
        if (db.party != nil) {
            db.voteToSkip()
        }
        print("changed")
    }
}

#Preview {
    @State var h = false
    return Controls(host: $h)
}
