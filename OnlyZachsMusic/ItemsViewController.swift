//
//  ItemsViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 10/25/21.
//

import UIKit

class ItemsViewController : UITableViewController, UITextFieldDelegate {
    
    let primaryBackgroundColor = UIColor(hex: 0x0E263D)
    let secondaryBackgroundColor = UIColor(hex: 0x1D4D7A)
    let tertiaryBackgroundColor = UIColor(hex: 0x27639C)
    let quaternaryBackgroundColor = UIColor.init(hex: 0x091826)
        
    /* Button and text field outlets*/
    @IBOutlet weak var favoriteFilterButton: UIButton!
    @IBOutlet var searchField: UITextField!
    
    /* Instance of SongItemStore to act as the model for application*/
    var songItemStore: SongItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    /* Override viewDidLoad to set ... */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85
        
        self.navigationController?.navigationBar.topItem?.title = "Only Zach's Music"
    }
    
    /* Override viewWillAppear to preform some formatting and styling of various components*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationBarAppearace = UINavigationBarAppearance()
        
        navigationBarAppearace.backgroundColor = quaternaryBackgroundColor
        navigationBarAppearace.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20.0, weight: .semibold), .foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearace
        navigationController?.navigationBar.compactAppearance = navigationBarAppearace
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearace

        
        // Change search field background to white
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Enter Search Query",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        // Modify search field border
        searchField.layer.cornerRadius = 5.0
        
        // Reload data
        tableView.reloadData()
        
        favoriteFilterButton.layer.borderWidth = 2.0
        favoriteFilterButton.layer.borderColor = secondaryBackgroundColor.cgColor
        favoriteFilterButton.layer.cornerRadius = 5.0
    }
    
    /* Allow keyboard to be dimissed by tapping on background*/
//    @IBAction func dimissKeyboard(_ sender: UITapGestureRecognizer) {
//        searchField.resignFirstResponder()
//    }
    
    /* Respond to search queries everytime the text field is edited*/
    @IBAction func searchQueryFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text {
            songItemStore.filterSearchTerm = text
            tableView.reloadData()
        }
    }
    
    /*
     * Add a new SongItem to the model
     */
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
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
//        disableAddOnFilter()
        tableView.reloadData()
    }
    
    /*
     * Gesture recognizer for dismissing keyboard will block cell delete buttons from being tapped
     * so this is neccessary to prevent this behavior
     */
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                                    shouldReceive touch: UITouch) -> Bool {
//        return true
//    }
    
    /*
     * Change attributes of a section header
     */
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.contentView.backgroundColor = secondaryBackgroundColor
//            headerView.contentView.layer.cornerRadius = 5.0
            
            let headerFont = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
            
            headerView.textLabel?.adjustsFontForContentSizeCategory = true
            headerView.textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: headerFont)
            headerView.layer.borderColor = primaryBackgroundColor.cgColor
            headerView.layer.borderWidth = 1
            headerView.layer.cornerRadius = 5.0
        }
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongItemCell", for: indexPath) as! SongItemCell
        let item = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
        
//        cell.titleLabel.text = "\(item.title) - \(item.genre)"
        cell.titleLabel.text = item.title

        cell.artistsLabel.text = item.artists

        cell.lengthLabel.text = item.length
        
        if item.isFavorite {
            cell.favoriteImg.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
            cell.favoriteImg.tintColor = .white
        } else {
            cell.favoriteImg.image = nil
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    /*
     * Allow user to delete a row, which will remove it from the model
     * Present alert to user to confirm deletion
     */
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        // If table view is asking to commit a delete command
        if editingStyle == .delete{
            let songItem = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
            
            // Present Alert
            let message = "Are you sure you want to delete '\(songItem.title)'"
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.modalPresentationStyle = .popover
            
            let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                // Delete Item
                self.songItemStore.removeItem(songItem)
                
                // If deletion removed a section, then update view
                if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    // Remove row from the table view with an animation
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                self.imageStore.deleteImage(forKey: songItem.itemKey)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
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
        favoriteAction.backgroundColor = tertiaryBackgroundColor
        
        if (item.isFavorite) {
            favoriteAction.image = UIImage(systemName: "heart.slash.fill")?.withTintColor(UIColor.white)
        } else {
            favoriteAction.image = UIImage(systemName: "heart.fill")?.withTintColor(UIColor.white)
        }
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    /*
     * Data preparation in response to seque
     */
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        switch  seque.identifier {
        case "showItem":
            if let indexPath = tableView.indexPathForSelectedRow {
                let songItem = songItemStore.modelItems[indexPath.section].songs[indexPath.row]
                
                let detailViewController = seque.destination as! DetailViewController
                detailViewController.songItem = songItem
                detailViewController.imageStore = imageStore
            }
            
        default:
            preconditionFailure("Unexpected seque identifier.")
        }
    }
    
    /*
     * Allow textField to be dismissed via return button
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

/*
 * Extending UIColor so that I can input hexadecimal color values
 * Apple is so supremely intelligent for not including this functionality by default
 * Or I am supremely intelligent for not being able to locate it easily
 */
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
