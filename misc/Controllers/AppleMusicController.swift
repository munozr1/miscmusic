//
//  AppleMusicController.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/28/24.
//

import Foundation
import MusicKit



@Observable class AppleMusicController: MusicPlayer {
    
    var name: String = "Apple"
    
    var accessToken: String?
    
    var currentTrackURI: String?
    
    var currentTrackImageURI: String = "uhhh"
    
    var currentTrackName: String?
    
    var currentTrackArtist: String?
    
    var currentTrackDuration: Int?
    
    var currentTrackImage: UIImage?
    
    var currentTrackPaused: Bool = true
    
    var connected: Bool = false
    
    func search(query: String, token: String) async {
        //
    }
    
    func setAccessToken(from url: URL) {
        //
    }
    
    func reconnect() {
        //
    }
    
    func disconnect() {
        //
    }
    
    func skipTrack() {
        //
    }
    
    func pause() {
        //
    }
    
    func resume() {
        //
    }

    // Requesting user consent for MusicKit
    func connect() async {
        let authorizationStatus = await MusicAuthorization.request()
        if authorizationStatus == .authorized {
            self.connected = true
            print("Authorized to use apple music")
        } else {
            print("User denied permission to Apple Music")
        }
        
    }//End requestMusicAuthorization
    
    
}// end of AppleMusicController

