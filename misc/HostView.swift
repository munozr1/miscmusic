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
                        Text("\( readableDuration(from: db.party?.duration ?? 0))")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                        Text("Duration")
                        
                    }
                    Spacer()
                }.padding()
            }
            LongRoundButton(action: {
                spotify.disconnect()
                db.shouldRun = false
                Task {
                    await db.endParty()
                    state = "Create"
                }
            }, label: "End Party", background_color: .red)
            Spacer()
            Spacer()
        }
    }
    
    func readableDuration(from duration: Float) -> String {
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return "\(hours)hr"
        } else if minutes > 0 {
            return "\(minutes)min"
        } else {
            return "\(seconds)s"
        }
    }
}

#Preview {
    @State var s = "test"
    return HostView(state: $s)
}
