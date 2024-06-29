//
//  MusicPlayer.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/28/24.
//

import Foundation


protocol MusicPlayer {
    var name: String { get }
    var accessToken: String? { get set }
    var currentTrackURI: String? { get }
    var currentTrackImageURI: String { get }
    var currentTrackName: String? { get }
    var currentTrackArtist: String? { get }
    var currentTrackDuration: Int? { get }
    var currentTrackImage: UIImage? { get }
    var currentTrackPaused: Bool { get }
    var connected: Bool { get }
    
    func search(query: String, token: String) async
    func setAccessToken(from url: URL)
    func connect() async
    func reconnect()
    func disconnect()
    func skipTrack()
    func pause()
    func resume()
}
