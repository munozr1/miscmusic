//
//  QueueView.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/6/24.
//

import SwiftUI

struct Track: Identifiable{
    var id: Int
    var title: String
    var artist: String
    var img: String
}

struct QueueView: View {
    @Binding var showQueue: Bool
    @FocusState var searchIsFocused: Bool
    @State var expand: Bool = false
    @State var input: String = ""
    var tracks: [Track] = [
        Track(id: Int(0),title: "Wonderwall - Remastered", artist: "Oasis", img: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228" ),
        Track(id: Int(1),title: "Cool Kids", artist: "Echosmith", img: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228" ),
        Track(id: Int(2),title: "Compartir- Remastered", artist: "Carla Morrison", img: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228" ),
        Track(id: Int(3),title: "Compartir- Remastered", artist: "Carla Morrison", img: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228" ),
    ]
    
    
    //MARK: Start View
    var body: some View {
        ZStack(alignment: .bottom){
            if (showQueue){
                VStack(alignment: .leading){
                    HStack{
                        //TODO: the search placeholder should be the users most searched location / category
                        TextField("Search Track Name", text: $input)
                            .focused($searchIsFocused)
                            .onSubmit {
                                handleInputChange()
                            }
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        Image(systemName: input.count == 0 ? "magnifyingglass" : "x.circle.fill").foregroundColor(.gray).onTapGesture {
                            if input.count > 0 {
                                input = ""
                            }
                        }.padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .onChange(of: input, handleInputChange)
                            .onChange(of: searchIsFocused){
                                if searchIsFocused {
                                    expand = true
                                }
                            }
                        
                    }.padding()
                    
                    //MARK: tracks list
                    ScrollView{
                        VStack{
                            ForEach(tracks){ track in
                                HStack{
                                    AsyncImage(url: URL(string: track.img)) {
                                        image in
                                        image.image?.resizable()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(5)
                                    }
                                    VStack(alignment: .leading){
                                        Text(truncate(str: track.title))
                                            .font(.system(size: 16))
                                        Text(track.artist)
                                            .font(.system(size: 12))
                                    }
                                    Spacer()
                                    VStack(alignment: .center){
                                        Image(systemName: "line.3.horizontal")
                                            .resizable()
                                            .foregroundColor(.primary)
                                            .frame(width: 22, height: 15)
                                    }
                                }.padding()
                            }
                        }
                    }.ignoresSafeArea(.keyboard)
                }
                .background()
                .clipShape(TopRoundedCorners(radius: 25))
                .shadow(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: 500)
                .transition(.move(edge: .bottom))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .gesture(
                DragGesture().onEnded { gesture in
                    if gesture.translation.height < 0 {
                        // Swipe Up
                    } else if gesture.translation.height > 0 {
                        // Swipe Down
                        showQueue = false
                    }
                }
            )
            .animation(.easeInOut, value: showQueue)
            .ignoresSafeArea()
    }
    
    func truncate(str: String) -> String {
        if str.count > 20 {
            let truncatedString = String(str.prefix(17))
            return truncatedString + "  . . ."
        }
        return str
    }
    
    func handleInputChange() {
        //TODO: handle search
    }

}

#Preview {
    @State var sq = true
    return QueueView(showQueue: $sq)
}
