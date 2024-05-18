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
                spotify.skipTrack()
            }label :{
                Image(systemName: "forward.end")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    return Controls()
}
