//
//  SongItemStore.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

struct GenreSection {
    var genre: String?
    var songs = [SongItem] ()
    
    mutating func addSong(_ songItem: SongItem){
        if let _ = songs.firstIndex(of: songItem) {
            print("Duplicate not added")
        } else {
            self.songs.append(songItem)
        }
    }
    mutating func insertSong(_ songItem: SongItem, at index: Int){
        if let _ = songs.firstIndex(of: songItem) {
            print("Duplicate not added")
        } else {
            self.songs.insert(songItem, at: index)
        }
    }
}

class SongItemStore {
    // "Master List" - contains all items. Is not the model for view
    private var masterItems = [GenreSection] ()
    
    var filterOnFavorites = false
    var filterSearchTerm: String = ""
    
    // Filter out songItems that are not favorited
    private var favoritefilter: (SongItem) -> Bool = {
        (songItem: SongItem) -> Bool in
        return songItem.isFavorite
    }
    private var searchTermFilter: (SongItem, String) -> Bool = {
        (songItem: SongItem, filterSearchTerm: String) -> Bool in
        let searchTerm = filterSearchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchTerm == "" {
            return true
        }
        if songItem.genre.contains(searchTerm) {
            return true
        } else if songItem.title.contains(searchTerm){
            return true
        } else if (songItem.artists.reduce("") {$0 + $1}).contains(searchTerm) {
            return true
        } else {
            return false
        }
    }
    
    // Contains only items currently being modeled (due to filtering or searching). Subset of masterItems
    var modelItems: [GenreSection]{
        var tempItems = [GenreSection]()
        
        for genreSec in self.masterItems{
            var genreSection = GenreSection(genre: genreSec.genre)
            for songItem in genreSec.songs{
//                if (self.filterOnFavorites ? self.favoritefilter(songItem) : true) && self.searchTermFilter(songItem, self.filterSearchTerm){
//                    genreSection.addSong(songItem)
//                }
                if (true) && self.searchTermFilter(songItem, self.filterSearchTerm){
                    genreSection.addSong(songItem)
                }
            }
            if genreSection.songs.count > 0{
                tempItems.append(genreSection)
            }
        }
        tempItems.sort {$0.genre! < $1.genre!}
        return tempItems
    }
    
    init() {
        for _ in 0..<5 {
            createSongItem()
        }
    }
    
    func addItem(_ songItem: SongItem){
        if let genreIndex = masterItems.firstIndex(where: {$0.genre == songItem.genre}) {
            masterItems[genreIndex].addSong(songItem)
        } else {
            var newGenreSection = GenreSection()
            newGenreSection.genre = songItem.genre
            newGenreSection.addSong(songItem)
            masterItems.append(newGenreSection)
            
            masterItems.sort {$0.genre! < $1.genre!}
        }
    }
    

    func insertItem(_ songItem: SongItem, at indexPath: IndexPath){
        if masterItems[indexPath.section].genre == songItem.genre{
            masterItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        } else {
            songItem.genre = masterItems[indexPath.section].genre!
            masterItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        }
    }
    
    @discardableResult func createSongItem() -> SongItem {
        let newSongItem = SongItem(random: true)
        addItem(newSongItem)
        return newSongItem
    }
    
    func removeItem(_ songItem: SongItem) {
        // Use genre as key
        if let genreIndex = masterItems.firstIndex(where: {$0.genre == songItem.genre}) {
            if let index = masterItems[genreIndex].songs.firstIndex(of: songItem) {
                masterItems[genreIndex].songs.remove(at: index)
                if masterItems[genreIndex].songs.count == 0 {
                    masterItems.remove(at: genreIndex)
                }
            }
        }
    }
    // For now: Cannot move and item or add a new one when filtering
    func moveItem(from fromIndex: IndexPath, to toIndex: IndexPath){
        if fromIndex == toIndex{
            return
        }
        // Get reference to the object being moved so we can reinsert it
        let movedItem = modelItems[fromIndex.section].songs[fromIndex.row]
        
        // Remove item
        removeItem(movedItem)
        
        // Reinsert at new index
        insertItem(movedItem, at: toIndex)

    }

}

