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
    @State var tracks: SpotifySearchResponse?
    @State private var selectedTracks: Set<String> = []

    
    //MARK: Start View
    var body: some View {
        VStack{
            if (showQueue){
                VStack(alignment: .leading){
                    HStack{
                        TextField("Search Track Name", text: $input)
                            .focused($searchIsFocused)
                            .onSubmit {
                                handleInputChange()
                                Task {
                                    do{
                                        guard let token = FirestoreController.shared.party?.token else { return }
                                        let res = try await SpotifyController.shared.search(query: input, token: token)
                                        tracks = res
                                        selectedTracks = []
                                        print("Search res = \(res)")
                                    } catch {
                                        print("Search Error: \(error)")
                                    }
                                }
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
                    
// Mark: - tracks list
                    ScrollView{
                        VStack{
                            if let items = tracks?.tracks.items {
                                ForEach(items, id: \.href){ track in
                                    HStack{
                                        AsyncImage(url: URL(string: track.album.images[0].url)) {
                                            image in
                                            image.image?.resizable()
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(5)
                                        }
                                        VStack(alignment: .leading){
                                            Text(truncate(str: track.name))
                                                .font(.system(size: 16))
                                            Text(track.artists[0].name)
                                                .font(.system(size: 12))
                                        }
                                        Spacer()
                                        VStack(alignment: .center){
                                            Image(systemName: selectedTracks.contains(track.href) ? "checkmark" : "plus")
                                                .resizable()
                                                .foregroundColor(selectedTracks.contains(track.href) ? .green : .primary)
                                                .frame(width: 17, height: 15)
                                                .contentTransition(.symbolEffect(.replace))
//                                                .transition(.scale)
                                        }
                                        .onTapGesture {
                                            withAnimation{
                                                if !selectedTracks.contains(track.href) {
                                                    selectedTracks.insert(track.href)
                                                    if FirestoreController.shared.isHost {
                                                        SpotifyController.shared.appRemote.playerAPI?.enqueueTrackUri(track.uri)
                                                    }
                                                    else{
                                                        FirestoreController.shared.addToQueue(party: FirestoreController.shared.party!.name, track: track.uri)
                                                    }
                                                }
                                            }
                                        }

                                    }.padding()
                                }
                            }
                        }
                    }.ignoresSafeArea(.keyboard)
                }
                .background()
                .clipShape(TopRoundedCorners(radius: 25))
                .shadow(radius: 10)
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring, value: showQueue)
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
//
//#Preview {
//    ContentView(spotify: SpotifyController(), authModel: AuthenticationModel())
//}
