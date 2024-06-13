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


let demoTracksArray: [Item] = [
    
    Item(album: Album(albumType: "album", totalTracks: 10, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/1"), href: "https://api.spotify.com/v1/albums/ab67616d00004851f1adf3da211f271d27bd4c8a", id: "1", images: [SpotifyImage(url: "https://i.scdn.co/image/ab67616d0000b273d195ccf784713dbf548d9e92", height: 640, width: 640)], name: "Thriller", releaseDate: "1982-11-30", releaseDatePrecision: "day", type: "album", uri: "spotify:album:1", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 357213,
         explicit: false,
         externalIds: ExternalIds(isrc: "USSM19902921", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/1"),
         href: "https://api.spotify.com/v1/tracks/1",
         id: "1",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Billie Jean",
         popularity: 85,
         previewUrl: "https://p.scdn.co/mp3-preview/1",
         trackNumber: 6,
         type: "track",
         uri: "spotify:track:1",
         isLocal: false),
    Item(album: Album(albumType: "album", totalTracks: 11, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/2"), href: "https://api.spotify.com/v1/albums/ab67616d0000b273ba5db46f4b838ef6027e6f96", id: "2", images: [SpotifyImage(url: "https://i.scdn.co/image/ab67616d0000b273f1adf3da211f271d27bd4c8a", height: 640, width: 640)], name: "Back in Black", releaseDate: "1980-07-25", releaseDatePrecision: "day", type: "album", uri: "spotify:album:2", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 255386,
         explicit: false,
         externalIds: ExternalIds(isrc: "AUAP08000036", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/2"),
         href: "https://api.spotify.com/v1/tracks/2",
         id: "2",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Back in Black",
         popularity: 82,
         previewUrl: "https://p.scdn.co/mp3-preview/2",
         trackNumber: 7,
         type: "track",
         uri: "spotify:track:2",
         isLocal: false),
    Item(album: Album(albumType: "album", totalTracks: 10, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/1"), href: "https://api.spotify.com/v1/albums/ab67616d0000b273f1adf3da211f271d27bd4c8a", id: "3", images: [SpotifyImage(url: "https://i.scdn.co/image/ab67616d0000b2737ecbd3c7c449570ae31bd93d", height: 640, width: 640)], name: "Thriller", releaseDate: "1982-11-30", releaseDatePrecision: "day", type: "album", uri: "spotify:album:1", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 357213,
         explicit: false,
         externalIds: ExternalIds(isrc: "USSM19902921", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/3"),
         href: "https://api.spotify.com/v1/tracks/3",
         id: "1",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Billie Jean",
         popularity: 85,
         previewUrl: "https://p.scdn.co/mp3-preview/1",
         trackNumber: 6,
         type: "track",
         uri: "spotify:track:1",
         isLocal: false),
    Item(album: Album(albumType: "album", totalTracks: 11, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/2"), href: "https://api.spotify.com/v1/albums/2", id: "4", images: [SpotifyImage(url: "https://i.scdn.co/image/ab67616d0000b273f1adf3da211f271d27bd4c8a", height: 640, width: 640)], name: "Back in Black", releaseDate: "1980-07-25", releaseDatePrecision: "day", type: "album", uri: "spotify:album:2", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 255386,
         explicit: false,
         externalIds: ExternalIds(isrc: "AUAP08000036", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/4"),
         href: "https://api.spotify.com/v1/tracks/4",
         id: "2",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Back in Black",
         popularity: 82,
         previewUrl: "https://p.scdn.co/mp3-preview/2",
         trackNumber: 7,
         type: "track",
         uri: "spotify:track:2",
         isLocal: false),
    Item(album: Album(albumType: "album", totalTracks: 10, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/1"), href: "https://api.spotify.com/v1/albums/1", id: "5", images: [SpotifyImage(url: "https://i.scdn.co/image/ab67616d00001e02686c29818cd37e585c48e7ef", height: 640, width: 640)], name: "Thriller", releaseDate: "1982-11-30", releaseDatePrecision: "day", type: "album", uri: "spotify:album:1", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/1"), href: "https://api.spotify.com/v1/artists/1", id: "1", name: "Michael Jackson", type: "artist", uri: "spotify:artist:1")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 357213,
         explicit: false,
         externalIds: ExternalIds(isrc: "USSM19902921", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/5"),
         href: "https://api.spotify.com/v1/tracks/12",
         id: "1",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Billie Jean",
         popularity: 85,
         previewUrl: "https://p.scdn.co/mp3-preview/1",
         trackNumber: 6,
         type: "track",
         uri: "spotify:track:1",
         isLocal: false),
Item(album: Album(albumType: "album", totalTracks: 11, availableMarkets: ["US"], externalUrls: ExternalUrls(spotify: "https://open.spotify.com/album/2"), href: "https://api.spotify.com/v1/albums/2", id: "6", images: [SpotifyImage(url:"https://i.scdn.co/image/ab67616d0000b2731813ea8f590a0aab2820f922", height: 640, width: 640)], name: "Back in Black", releaseDate: "1980-07-25", releaseDatePrecision: "day", type: "album", uri: "spotify:album:2", artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")]),
         artists: [Artist(externalUrls: ExternalUrls(spotify: "https://open.spotify.com/artist/2"), href: "https://api.spotify.com/v1/artists/2", id: "2", name: "AC/DC", type: "artist", uri: "spotify:artist:2")],
         availableMarkets: ["US"],
         discNumber: 1,
         durationMs: 255386,
         explicit: false,
         externalIds: ExternalIds(isrc: "AUAP08000036", ean: nil, upc: nil),
         externalUrls: ExternalUrls(spotify: "https://open.spotify.com/track/2"),
         href: "https://api.spotify.com/v1/tracks/22",
         id: "2",
         isPlayable: true,
         linkedFrom: nil,
         restrictions: nil,
         name: "Back in Black",
         popularity: 82,
         previewUrl: "https://p.scdn.co/mp3-preview/2",
         trackNumber: 7,
         type: "track",
         uri: "spotify:track:2",
         isLocal: false)
        //Add more tracks to this array from the json i gave you
]
let demoTracks: SpotifySearchResponse = SpotifySearchResponse(tracks: Tracks(href: "href", items: demoTracksArray, limit: 10, next: "idk", offset: 10, previous: "idk", total: 50))
