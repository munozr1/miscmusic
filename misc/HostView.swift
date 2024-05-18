//
//  HostView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI

struct HostView: View {
    var db = FirestoreController.shared
    var body: some View {
        VStack{
            Text("Party Code")
                .foregroundColor(.gray)
                .font(.system(size: 10))
            Text("123456")
                .font(.largeTitle)
                .padding(.bottom)
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
                        Text("1hr")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                        Text("Duration")
                    
                    }
                    Spacer()
                }.padding()
            }
            LongRoundButton(action: {print("end party")}, label: "End Party", background_color: .red)
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    HostView()
}
