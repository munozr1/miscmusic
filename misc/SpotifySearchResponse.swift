//
//  SpotifySearchResponse.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/7/24.
//

import Foundation


struct SpotifySearchResponse: Codable {
    var tracks: Tracks
}

// MARK: - Tracks
struct Tracks: Codable {
    var href: String
    var items: [Item]
    var limit: Int
    var next: String?
    var offset: Int
    var previous: String?
    var total: Int
}

// MARK: - Item
struct Item: Codable , Identifiable{
    var album: Album
    var artists: [Artist]
    var availableMarkets: [String]
    var discNumber: Int
    var durationMs: Int
    var explicit: Bool
    var externalIds: ExternalIds
    var externalUrls: ExternalUrls
    var href, id: String
    var isPlayable: Bool?
    var linkedFrom: LinkedFrom?
    var restrictions: Restrictions?
    var name: String
    var popularity: Int
    var previewUrl: String?
    var trackNumber: Int
    var type, uri: String
    var isLocal: Bool

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case restrictions, name, popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type, uri
        case isLocal = "is_local"
    }
}

// MARK: - Album
struct Album: Codable {
    var albumType: String
    var totalTracks: Int
    var availableMarkets: [String]
    var externalUrls: ExternalUrls
    var href, id: String
    var images: [SpotifyImage]
    var name, releaseDate, releaseDatePrecision: String
    var restrictions: Restrictions?
    var type, uri: String
    var artists: [Artist]

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case restrictions, type, uri, artists
    }
}

// MARK: - Artist
struct Artist: Codable {
    var externalUrls: ExternalUrls
    var href, id, name, type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    var spotify: String
}

// MARK: - Image
struct SpotifyImage: Codable {
    var url: String
    var height, width: Int
}

// MARK: - Restrictions
struct Restrictions: Codable {
    var reason: String
}

// MARK: - ExternalIds
struct ExternalIds: Codable {
    var isrc: String?
    var ean: String?
    var upc: String?
}

// MARK: - LinkedFrom
struct LinkedFrom: Codable {}
