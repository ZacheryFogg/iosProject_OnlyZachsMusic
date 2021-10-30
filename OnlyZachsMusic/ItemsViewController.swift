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
        if let genreIndex = songItemStore.allItems.firstIndex(where: {$0.genre == newSongItem.genre}) {
            if let index = songItemStore.allItems[genreIndex].songs.firstIndex(of: newSongItem) {
                let indexPath = IndexPath(row: index, section: genreIndex)
                
                // If this is true, then a new section has been created
                if songItemStore.allItems.count != tableView.numberOfSections {
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
    // Called when most updates happen or could have happened
    override func numberOfSections(in tableView: UITableView) -> Int {
        return songItemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songItemStore.allItems[section].genre
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItemStore.allItems[section].songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = songItemStore.allItems[indexPath.section].songs[indexPath.row]
        
        cell.textLabel?.text = "\(item.title) - \(item.genre)"
        cell.detailTextLabel?.text = "\(item.length)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If table view is asking to commit a delete command
        if editingStyle == .delete{
            let item = songItemStore.allItems[indexPath.section].songs[indexPath.row]
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
}
