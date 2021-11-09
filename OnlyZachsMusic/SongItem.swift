//
//  SongItem.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

class SongItem: Equatable, Codable {
    var title: String       // title of the song
    var artists: String   // artists in song, too much hasel to make it an array of Strings
    var length: String         // the length of the song
    var genre: String   // a list of genres that the song falls into
    var desc: String?   // description of why Zach likes the song
    var isFavorite: Bool  // is this song a favorite
    var cover: String?      // albumn cover associated with the song
    let itemKey: String
    
    init(title: String,
         artists: String,
         length: String,
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
        self.itemKey = UUID().uuidString
        
    }
    
    convenience init(random: Bool = true){
        if random {
            let len = Int(arc4random_uniform(400))
            
            let lenStr = convertIntToTimeFmt(time: len)
            
            let possibleGenres = ["Rock", "Hip Hop", "Alternative Metal", "Country", "Alternative Rock", "Indie"]
            let possibleTitles = ["New", "Divide", "Bleed", "I've Done","Authority", "With You", "Pushing Me",
                                  "It out", "Numb", "End", "In the", "One Step", "Closer", "Away", "Runaway","Papercut",
                                  "Fogotten", "By Myself", "Given Up", "Shadow of the", "Day", "No More", "Sorrow"]
            let possibleArtists = ["Linkin Park", "Camila Cabello", "Halsey", "Three Days Grace", "Seether", "Rise Against",
                                   "The Offspring", "Breaking Benjamin", "Avenged Sevenfold", "Shinedown", "Bring Me The Horizon",
                                   "Motionless in White", "Late Night Savior", "Evans Blue", "Shinedown"]
            var title = ""
            let maxTitlePhrase = 1
            for i in 0...maxTitlePhrase{
                title += "\(possibleTitles[Int(arc4random_uniform(UInt32(possibleTitles.count)))])"
                if i != maxTitlePhrase{
                    title+=" "
                }
            }
            let genre = possibleGenres[Int(arc4random_uniform(UInt32(possibleGenres.count)))]
            
            var artists = ""
            
            let numArtists = Int.random(in:1...2)
            for i in 0..<numArtists{
//                if artists == ""{
//                    artists = "\(possibleArtists[Int.random(in:0..<possibleArtists.count)])\(i < numArtists - 1 ? ", " : "")"
//                } else {
//                    artists = "\(artists),\(possibleArtists[Int.random(in:0..<possibleArtists.count)])\(i < numArtists - 1 ? ", " : "")"
//                }
                artists += "\(possibleArtists[Int.random(in:0..<possibleArtists.count)])\(i < numArtists - 1 ? ", " : "")"
            }
            
            self.init(title: title, artists: artists, length: lenStr, genre: genre,
                      desc: "It's a good song", isFavorite: false, cover: "ur mom")
        } else {
            self.init(title: "New Divide", artists: "Linkin Park", length: "2:58", genre: "Rock",
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

func convertIntToTimeFmt(time: Int) -> String {
    var min = 0
    var intTime = time
    while intTime - 60 > 0{
        intTime -= 60
        min+=1
    }
    var seconds = "\(intTime)"
    if seconds.count == 1{
        seconds = "0\(seconds)"
    }
    return "\(min):\(seconds)"
}
