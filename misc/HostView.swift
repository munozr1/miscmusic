//
//  HostView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI

struct HostView: View {
    var db = FirestoreController.shared
    @ObservedObject var spotify = SpotifyController.shared
    @Binding var state: String
    var body: some View {
        VStack{
            Spacer()
            VStack{
                HStack{
                    HStack{
                        Text("\(db.party?.listeners ?? 0)")
                            .font(.system(size: 70))
                            .fontWeight(.heavy)
                            .padding(.leading, 72)
                        Text("Listeners")
                            .padding(.top, 37)
                            .font(.system(size: 15))
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    VStack{
                        Text("\( db.skipRate )%")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                            .foregroundColor(db.skipRate < 30 ? .green : .red)
                        Text("Skip Rate")
                        
                    }
                    Spacer()
                    Spacer()
                    VStack{
                        Text("\(db.party?.duration ?? 0)")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                        Text("Duration")
                        
                    }
                    Spacer()
                }.padding()
            }
            LongRoundButton(action: {
                state = "Create"
                print("end party")
                spotify.disconnect()
                db.shouldRun = false
                Task {
                    await db.endParty()
                }
            }, label: "End Party", background_color: .red)
            Spacer()
            Spacer()
        }/*.onChange(of: db.party?.voteSkips,{
            print("checking if skips surpass 50%")
            if Float(db.party!.voteSkips)/Float(db.party!.listeners) > 0.5 {
                spotify.skipTrack()
                db.incrementSkipped()
                resetSkips()
            }
        })*/
    }
    
    /*func resetSkips() {
        if let party = db.party {
                db.updateParty(name: party.name, data: [
                    "voteSkips": 0
                ])
        }
        print("changed")
    }
     */
}

#Preview {
    @State var s = "test"
    return HostView(state: $s)
}
