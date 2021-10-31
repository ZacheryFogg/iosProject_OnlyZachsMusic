//
//  SongItemStore.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

/*
 * GenreSection is a data strucutre to represent a "genre" and all SongItems that fall into that genre.
 * A "genre" is just a string inputed by the user and is a way to logically group SongItems.
 *
 * Provides functionality to append or insert SongItems into a GenreSection
 */
struct GenreSection {
    var genre: String?
    var songs = [SongItem] ()
    
    /*
     * Append a SongItem to the array if it is not a duplicate
     */
    mutating func appendSong(_ songItem: SongItem){
        if let _ = songs.firstIndex(of: songItem) {
            print("Duplicate not added")
        } else {
            self.songs.append(songItem)
        }
    }
    
    /*
     * Inserta SongItem into the array at a given index if it is not a duplicate
     */
    mutating func insertSong(_ songItem: SongItem, at index: Int){
        if let _ = songs.firstIndex(of: songItem) {
            print("Duplicate not added")
        } else {
            self.songs.insert(songItem, at: index)
        }
    }
}
/*
 * SongItemStore acts as the model for this application.
 * Stores all SongItems in a private store, but only exposes a filtered subset to the controller.
 *
 * Provides functionality to: add, delete, move, and filter SongItems from respective GenreSections
 */
class SongItemStore {
    /*  Array of GenreSections to act as master list. Contains all SongItems. Is not directly exposed to the controller */
    private var masterItems = [GenreSection] ()
    
    /* Boolean to only expose SongItems that are favorited */
    var filterOnFavorites = false
    
    /* String filter term to only expose SongItems that contain the term */
    var filterSearchTerm: String = ""
    
    /* Closure that filters out SongItems that are not favorited */
    private var favoritefilter: (SongItem) -> Bool = {
        (songItem: SongItem) -> Bool in
        return songItem.isFavorite
    }
    
    /* Closure that filters out SongItems that does not contain a given search term
     * in it genre, title, artists, or description */
    private var searchTermFilter: (SongItem, String) -> Bool = {
        (songItem: SongItem, filterSearchTerm: String) -> Bool in
        let searchTerm = filterSearchTerm.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if searchTerm == "" { return true }
        if songItem.genre.lowercased().contains(searchTerm) { return true }
        if songItem.title.lowercased().contains(searchTerm) { return true }
        if (songItem.artists.reduce("") {$0 + $1}).lowercased().contains(searchTerm) { return true }
        if let desc = songItem.desc{ if desc.lowercased().contains(searchTerm) { return true } }
        return false
    }
    
    /* Array of GenreSections that has had all current filters applied to it - subset of masterItems.
     * Is the data that is exposed to the controller to be displayed.
     * Updated whenever filter conditions change or mastetItems is modified
     */
    var modelItems: [GenreSection]{
        var tempItems = [GenreSection]()
        for genreSec in self.masterItems{
            var genreSection = GenreSection(genre: genreSec.genre)
            for songItem in genreSec.songs{
                if (self.filterOnFavorites ? self.favoritefilter(songItem) : true) && self.searchTermFilter(songItem, self.filterSearchTerm){
                    genreSection.appendSong(songItem)
                }
            }
            if genreSection.songs.count > 0{
                tempItems.append(genreSection)
            }
        }
        // GenreSections should be alphabetically sorted
        tempItems.sort {$0.genre! < $1.genre!}
        return tempItems
    }
    
    /*
     * Initializer for SongItemStore.
     * Calls function to create semi-random SongItem and add it to the model 5 times
     */
    init() {
        for _ in 0..<5 {
            createSongItem(random: true)
        }
    }
    
    /*
     * Append a SongItem to masterItems in appropriate GenreSection.
     * If SongItem belongs to a new genre, then create new GenreSection and append SongItem
     */
    func appendSongItem(_ songItem: SongItem){
        if let genreIndex = masterItems.firstIndex(where: {$0.genre == songItem.genre}) {
            masterItems[genreIndex].appendSong(songItem)
        } else {
            var newGenreSection = GenreSection(genre: songItem.genre)
            newGenreSection.appendSong(songItem)
            masterItems.append(newGenreSection)
            // GenreSections should be alphabetically sorted
            masterItems.sort {$0.genre! < $1.genre!}
        }
    }
    
    /*
     * Insert SongItem at appropriate GenreSection at given index
     * If SongItem is inserted into a GenreSection that has a different genre then itself,
     * its genre will be changed to match the GenreSection
     */
    func insertSongItem(_ songItem: SongItem, at indexPath: IndexPath){
        if masterItems[indexPath.section].genre == songItem.genre{
            masterItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        } else {
            songItem.genre = masterItems[indexPath.section].genre!
            masterItems[indexPath.section].insertSong(songItem, at: indexPath.row)
        }
    }
    
    /*
     * Create a new SongItem and add it to masterItems
     *
     * Return new SongItem, discardable
     */
    @discardableResult func createSongItem(random: Bool) -> SongItem {
        let newSongItem = SongItem(random: random)
        appendSongItem(newSongItem)
        return newSongItem
    }
    
    /*
     * Remove the given SongItem from masterItems
     */
    func removeItem(_ songItem: SongItem) {
        if let genreIndex = masterItems.firstIndex(where: {$0.genre == songItem.genre}) {
            if let index = masterItems[genreIndex].songs.firstIndex(of: songItem) {
                masterItems[genreIndex].songs.remove(at: index)
                if masterItems[genreIndex].songs.count == 0 {
                    masterItems.remove(at: genreIndex)
                }
            }
        }
    }
    
    /*
     * Move a SongItem from its current index to a new given index
     * This function will not be called if modelItems != masterItems as repositioning would not make sense
     * when only a subset of results are being displayed
     */
    func moveItem(from fromIndex: IndexPath, to toIndex: IndexPath){
        if fromIndex == toIndex{
            return
        }
        let movedItem = masterItems[fromIndex.section].songs[fromIndex.row]
        removeItem(movedItem)
        insertSongItem(movedItem, at: toIndex)

    }
    
    /*
     * Return boolean representing whether or not modelItems is/could be different then masterItems
     */
    func isCurrentlyFiltered() -> Bool{
        return filterOnFavorites || filterSearchTerm != ""
    }

}

