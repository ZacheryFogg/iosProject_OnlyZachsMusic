//
//  SongItemStore.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

struct GenreSection {
    var genre = "Unspecified Genre"
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
    var allItems = [GenreSection] ()
        
    init() {
        for _ in 0..<5 {
            createSongItem()
        }
    }
    
    func addItem(_ songItem: SongItem){
        if let genreIndex = allItems.firstIndex(where: {$0.genre == songItem.genre}) {
            allItems[genreIndex].addSong(songItem)
        } else {
            var newGenreSection = GenreSection()
            newGenreSection.genre = songItem.genre
            newGenreSection.addSong(songItem)
            allItems.append(newGenreSection)
            
            allItems.sort {$0.genre < $1.genre}
        }
    }
    
    func insertItem(_ songItem: SongItem, at indexPath: IndexPath){
        if allItems[indexPath.section].genre == songItem.genre{
            allItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        } else {
            songItem.genre = allItems[indexPath.section].genre
            allItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        }
    }
    
    @discardableResult func createSongItem() -> SongItem {
        let newSongItem = SongItem(random: true)
        addItem(newSongItem)
        return newSongItem
    }
    
    func removeItem(_ songItem: SongItem) {
        // Use genre as key
        if let genreIndex = allItems.firstIndex(where: {$0.genre == songItem.genre}) {
            if let index = allItems[genreIndex].songs.firstIndex(of: songItem) {
                allItems[genreIndex].songs.remove(at: index)
                if allItems[genreIndex].songs.count == 0 {
                    allItems.remove(at: genreIndex)
                }
            }
        }
    }
    
    func moveItem(from fromIndex: IndexPath, to toIndex: IndexPath){
        if fromIndex == toIndex{
            return
        }
        // Get reference to the object being moved so we can reinsert it
        let movedItem = allItems[fromIndex.section].songs[fromIndex.row]
        
        // Remove item
        removeItem(movedItem)
        
        // Reinsert at new index
        insertItem(movedItem, at: toIndex)

    }

}

