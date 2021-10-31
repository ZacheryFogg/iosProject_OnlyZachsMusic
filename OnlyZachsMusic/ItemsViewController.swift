//
//  ItemsViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

class ItemsViewController : UITableViewController {
    
    /* Instance of SongItemStore to act as the model for application*/
    var songItemStore: SongItemStore!
    
    /*
     * Add a new SongItem to the model
     */
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create new item and add it to the itemStore
        let newSongItem = songItemStore.createSongItem(random: true)
        
        // Determine where new item is in array
        if let genreIndex = songItemStore.modelItems.firstIndex(where: {$0.genre == newSongItem.genre}) {
            if let index = songItemStore.modelItems[genreIndex].songs.firstIndex(of: newSongItem) {
                let indexPath = IndexPath(row: index, section: genreIndex)
            
                // If this is true, then a new section has been created
                if songItemStore.modelItems.count != tableView.numberOfSections {
                    let indexSet = IndexSet(integer: indexPath.section)
                    tableView.insertSections(indexSet, with: .fade)

                } else {
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    /*
     * Handle action on "Edit" button
     * Will allow SongItems to be moved or deleted
     */
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        sender.setTitle("All", for: .normal)
        if isEditing{
            sender.setTitle("Edit", for: .normal)
            
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            
            setEditing(true, animated: true)
        }
    }
    
    /*
     * Handle action on button associated with filtering on isFavorite
     * Will update model to only give SongItems based on isFavorite property of SongItem
     */
    @IBAction func toggleFilterOnFavorite(_ sender: UIButton){
        
        songItemStore.filterOnFavorites.toggle()
        if songItemStore.filterOnFavorites{
            sender.setTitle("Show All", for: .normal)
        } else {
            sender.setTitle("Show Favorites", for: .normal)
        }
        tableView.reloadData()
    }

    /*
     * Return the number or sections; equal to the number of unique genres
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return songItemStore.modelItems.count
    }
    
    /*
     * Return the title for a section; title will be the sections genre
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songItemStore.modelItems[section].genre
    }
    
    /*
     * Return the number of rows (SongItems) in a section (GenreSection)
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItemStore.modelItems[section].songs.count
    }
    
    /*
     * Create a cell to represent a SongItem at a given index
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
        
        cell.textLabel?.text = "\(item.title) - \(item.genre)"
        cell.detailTextLabel?.text = "\(item.length)"
        
        if item.isFavorite {
            cell.imageView?.image = UIImage(systemName: "heart")?.withTintColor(UIColor.systemCyan)
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    /*
     * Allow user to delete a row, which will remove it from the model
     */
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        // If table view is asking to commit a delete command
        if editingStyle == .delete{
            let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
            songItemStore.removeItem(item)
            
            // If deletion removed a section, then update view
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                // Remove row from the table view with an animation
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    /*
     * Allow user to move an SongItem inter-sectionally or intra-sectionally
     * Moving a SongItem inter-sectionally will switch the SongItems genre to
     * the genre of the new section
     */
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        
        songItemStore.moveItem(from: sourceIndexPath, to: destinationIndexPath)
        
        // If move was inter-sectional, then data representing SongItem will have changed, so reload row to match model
        if sourceIndexPath.section != destinationIndexPath.section {
            tableView.reloadData()
            //        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
            //        tableView.beginUpdates()
            //        tableView.endUpdates()
        }
    }
    
    /*
     * When user attempts to move a SongItem, if there are filters currently being applied then
     * movement is not allowed; It is not logical to reposition elements when positioning
     * is entirely dependent on filters.
     */
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt: IndexPath,
                            toProposedIndexPath: IndexPath) -> IndexPath {
        if songItemStore.isCurrentlyFiltered(){
            return targetIndexPathForMoveFromRowAt
        } else {
            return toProposedIndexPath
        }
    }
    
    /*
     * Allow user to left swipe on a SongItem to favorite or un-favorite a SongItem
     * Sets the isFavorite property on a SongItem
     */
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
        
        // Setup a handler to call when the user clicks on the button after swiping the item
        let handler: (UIContextualAction, UIView, @escaping (Bool)-> Void) -> Void = {
            (action: UIContextualAction, view: UIView, completionHandler: @escaping (Bool)-> Void) -> Void in

            self.songItemStore.modelItems[indexPath.section].songs[indexPath.row].isFavorite.toggle()
            
            // Reload the affected row to display new isFavorite status
            tableView.reloadRows(at: [indexPath], with: .automatic)
 
            completionHandler(true)
        }
        
        // Setup action on the row.
        let favoriteAction = UIContextualAction(style: .normal, title: "", handler: handler)
        favoriteAction.backgroundColor = UIColor.systemMint
        
        if (item.isFavorite) {
            favoriteAction.image = UIImage(systemName: "heart.slash.fill")?.withTintColor(UIColor.white)
        } else {
            favoriteAction.image = UIImage(systemName: "heart.fill")?.withTintColor(UIColor.white)
        }
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
