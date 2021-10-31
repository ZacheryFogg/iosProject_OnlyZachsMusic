//
//  ItemsViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

class ItemsViewController : UITableViewController {
    var songItemStore: SongItemStore!
    
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create new item and add it to the itemStore
        let newSongItem = songItemStore.createSongItem()
        
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
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing{
            sender.setTitle("Edit", for: .normal)
            
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func toggleFilterOnFavorite(_ sender: UIButton){
        songItemStore.filterOnFavorites.toggle()
        tableView.reloadData()
    }
    // Called when most updates happen or could have happened
    override func numberOfSections(in tableView: UITableView) -> Int {
        return songItemStore.modelItems.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songItemStore.modelItems[section].genre
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItemStore.modelItems[section].songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
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
    
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If table view is asking to commit a delete command
        if editingStyle == .delete{
            let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
            // Remove item from the store
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        
        // update model
        songItemStore.moveItem(from: sourceIndexPath, to: destinationIndexPath)
        
        // update view to match model if genre has been updated
//        tableView.reloadSections(IndexSet(integer: destinationIndexPath.section), with: UITableView.RowAnimation.none)
        if sourceIndexPath.section != destinationIndexPath.section {
            tableView.reloadData()
        }
//        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
//        tableView.beginUpdates()
//        tableView.endUpdates()

    }
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
//        let actionTitle = songItemStore.allItems[indexPath.section].songs[indexPath.row].isFavorite ? "Remove Favorite" : "Favorite"
//        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .normal, title: actionTitle){
//            [weak self] _,_,_ in
//            let item = self?.songItemStore.allItems[indexPath.section].songs[indexPath.row]
//
//            item?.isFavorite.toggle()
//           tableView.reloadRows(at: [indexPath], with: .automatic)
//        }])
//
//    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Find the item being edited.
        let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]

        // Setup a handler to call when the user clicks on the button after swiping the item.
        let handler: (UIContextualAction, UIView, @escaping (Bool)-> Void) -> Void = {
            (action: UIContextualAction, view: UIView, completionHandler: @escaping (Bool)-> Void) -> Void in

            // Toggle the item's "isFavorite" value.
            self.songItemStore.modelItems[indexPath.section].songs[indexPath.row].isFavorite.toggle()
            // Reload the item, so that it will be updated to show/hide the favorite star.
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // Since a favorite was added/removed, we need to update the favorites button
            // at the top of the screen, to make sure it's properly shown or hidden based
            // on whether the data set has any favorites.
//            self.updateFavoritesButton()

            completionHandler(true)
        }
        
        // Finally, setup the Action on the row.
        let favoriteAction = UIContextualAction(style: .normal, title: "", handler: handler)
        favoriteAction.backgroundColor = UIColor.systemTeal
        if (item.isFavorite) {
            favoriteAction.image = UIImage(systemName: "heart.slash.fill")?.withTintColor(UIColor.white)
        } else {
            favoriteAction.image = UIImage(systemName: "heart.fill")?.withTintColor(UIColor.white)
        }
        
        // And return the action.
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    
//    override func tableView(_ tableView: UITableView,
//                            targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
//                            toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    
}
