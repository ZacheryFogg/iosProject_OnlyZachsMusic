//
//  SongItem.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

class SongItem: Equatable {
    var title: String       // title of the song
    var artists: [String]   // a list of artists of the song, len >= 1
    var length: Int         // the length of the song
    var genre: String   // a list of genres that the song falls into
    var desc: String?   // description of why Zach likes the song
    var isFavorite: Bool  // is this song a favorite
    var cover: String?      // albumn cover associated with the song
    
    init(title: String,
         artists: [String],
         length: Int,
         genre: String,
         desc: String?,
         isFavorite: Bool,
         cover: String?) {
        
        self.title = title
        self.artists = artists
        self.length = length
        self.genre = genre
        self.desc = desc
        self.isFavorite = isFavorite
        self.cover = cover
        
    }
    
    convenience init(random: Bool = true){
        if random {
            let len = Int(arc4random_uniform(400))
            let possibleGenres = ["Rock", "Hip Hop", "Alternative Metal", "Country", "Alternative Rock", "Indie"]
            let genre = possibleGenres[Int(arc4random_uniform(UInt32(possibleGenres.count)))]
            
            self.init(title: "New Divide", artists: ["Linkin Park"], length: len, genre: genre,
                      desc: "It's a good song", isFavorite: false, cover: "ur mom")
        } else {
            self.init(title: "New Divide", artists: ["Linkin Park"], length: 268, genre: "Rock",
                      desc: "It's a good song", isFavorite: false, cover: "ur mom")
        }
    }
    
    static func ==(lhs: SongItem, rhs: SongItem) -> Bool {
        return lhs.title == rhs.title
        && lhs.genre == rhs.genre
        && lhs.artists == rhs.artists
        && lhs.length == rhs.length
    }
}
