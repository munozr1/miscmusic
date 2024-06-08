//
//  SpotifyController.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI
import SpotifyiOS
import Combine
import Gzip

class SpotifyController: NSObject, ObservableObject {
    static let shared = SpotifyController()
    let spotifyClientID: String = String(Secrets.SpotifyClientID)
    let spotifyRedirectURL = URL(string: String(Secrets.SpotifyRedirectURL))!
    var accessToken: String? = nil
    var playURI = ""
    @Published var currentTrackURI: String?
    @Published var currentTrackImageURI: String = "spotify:image:ab67616d00001e02ff9ca10b55ce82ae553c8228"
    @Published var currentTrackName: String?
    @Published var currentTrackArtist: String?
    @Published var currentTrackDuration: Int?
    @Published var currentTrackImage: UIImage?
    @Published var currentTrackPaused: Bool = true
    
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
//                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
//                self.disconnect()
            }
    }
    
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    func search(query: String, token: String ) async throws -> SpotifySearchResponse {
        // Replace with your actual Bearer token
        
        
        // Encode the query to be URL-safe
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        // Construct the URL
        let urlString = "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for valid response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("Response Headers: \(httpResponse.allHeaderFields)")
        print("Data: \(data)")

   
        let searchResult = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
        return searchResult
    }
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    func connect() {
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            self.appRemote.authorizeAndPlayURI("")
            objectWillChange.send()

            return
        }
        appRemote.connect()
        objectWillChange.send()

    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
    
    
    func skipTrack() {
        appRemote.playerAPI?.skip(toNext: { (_, error) in
            if let error = error {
                print("Error skipping track: \(error.localizedDescription)")
            }
        })
    }
    
    func pause() {
        appRemote.playerAPI?.pause { (_, error) in
            if let error = error {
                print("Error pausing playback: \(error.localizedDescription)")
            }
        }
    }
    
    func resume() {
        appRemote.playerAPI?.resume { (_, error) in
            if let error = error {
                print("Error resuming playback: \(error.localizedDescription)")
            }
        }
    }

    func fetchImage() {
        appRemote.playerAPI?.getPlayerState { (result, error) in
            if let error = error {
                print("Error getting player state: \(error)")
            } else if let playerState = result as? SPTAppRemotePlayerState {
                print("Track: \(playerState.track.imageIdentifier) URI: \(playerState.track.uri)")
                self.appRemote.imageAPI?.fetchImage(forItem: playerState.track, with: CGSize(width: 300, height: 300), callback: { (image, error) in
                    if let error = error {
                        print("Error fetching track image: \(error.localizedDescription)")
                    } else if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.currentTrackImage = image
                        }
                    }
                })
            }
        }
    }
}


extension SpotifyController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.currentTrackURI = playerState.track.uri
        self.currentTrackName = playerState.track.name
        self.currentTrackArtist = playerState.track.artist.name
        self.currentTrackDuration = Int(playerState.track.duration) / 1000
        self.currentTrackPaused = playerState.isPaused
        self.currentTrackImageURI = playerState.track.imageIdentifier
        fetchImage()
    }
}

