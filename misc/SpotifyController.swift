//
//  SpotifyController.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI
import SpotifyiOS
import Combine

class SpotifyController: NSObject, ObservableObject {
    static let shared = SpotifyController()
    let spotifyClientID = "19fb01c4d73d4f8bacf062b88aa9e846"
    let spotifyRedirectURL = URL(string: "misc://spotify-login-callback")!
    var accessToken: String? = nil
    var playURI = ""
    @Published var currentTrackURI: String?
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
        fetchImage()
    }
}
