//
//  Controls.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI

struct Controls: View {
    @ObservedObject var spotify = SpotifyController.shared
    var db = FirestoreController.shared
    @State var voted: Bool = false
    @Binding var state: String
    @Binding var showQueue: Bool
    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Button{
                print("show queue")
                showQueue.toggle()
            } label:{
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 27, height: 20)
                    .padding()
            }
            Spacer()
            HStack{
                Button {
                    if db.isHost && !spotify.appRemote.isConnected{
                        spotify.connect()
                    }
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
                if state == "Host" {
                    spotify.skipTrack()
                }else if state == "Guest"{
                    handleGuestSkip(s: true)
                }
            }label :{
                Image(systemName: !voted ? "forward.end" : "forward.end.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Spacer()
            Spacer()
        }
        .onChange(of: db.party?.currentTrack){ voted = false }
        .onChange(of: db.party?.voteSkips,{
            if db.isHost != true { return }
            guard let votes = db.party?.voteSkips else { return }
            guard let listeners = db.party?.listeners else { return }
            print("checking if skips surpass 50%")
            if Float(votes)/Float(listeners) > 0.45 {
                spotify.skipTrack()
                db.incrementSkipped()
                resetSkips()
            }
        })
        .onChange(of: db.party?.queue, {
            guard let tracks = db.party?.queue else { return }
            guard let api = SpotifyController.shared.appRemote.playerAPI else { return }
            for track in tracks {
                api.enqueueTrackUri(track)
                db.removeToQueue(party: db.party!.name, track: track)
            }
        })
       
    }
    
    func resetSkips() {
        if let party = db.party {
                db.updateParty(name: party.name, data: [
                    "voteSkips": 0
                ])
        }
        print("changed")
    }
    
    func handleGuestSkip(s: Bool) {
        if (db.party != nil) {
            db.voteToSkip()
            voted = true
        }
        print("changed")
    }
}

#Preview {
    @State var h = "Host"
    @State var b = true
    return Controls(state: $h, showQueue: $b)
}
