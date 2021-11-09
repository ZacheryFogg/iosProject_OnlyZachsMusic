//
//  DetailViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 11/6/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var artistsTextField: UITextField!
    @IBOutlet var genreTextField: UITextField!
    @IBOutlet var lengthTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    
    @IBOutlet var albumImg: UIImageView!

    @IBOutlet weak var toolbar: UIToolbar!
    
    let quaternaryBackgroundColor = UIColor.init(hex: 0x091826)
    
    var songItem: SongItem! {
        didSet {
            navigationItem.title = songItem.title
        }
    }
    
    var imageStore: ImageStore!
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        let message = "Are you sure you want to delete '\(songItem.title)'"
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.modalPresentationStyle = .popover
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            // Delete Item
            let itemViewController = self.navigationController?.viewControllers.first as! ItemsViewController
            itemViewController.songItemStore!.removeItem(self.songItem)
            itemViewController.imageStore!.deleteImage(forKey: self.songItem.itemKey)
            // Pop stack view
            self.navigationController!.popViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        songItem.isFavorite.toggle()
        if songItem.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.white), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate).withTintColor(.white), for: .normal)
        }
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.text = songItem.title
        artistsTextField.text = songItem.artists
        genreTextField.text = songItem.genre
        lengthTextField.text = songItem.length
        descTextField.text = songItem.desc
        
        if songItem.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.white), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate).withTintColor(.white), for: .normal)
        }
        
        let key = songItem.itemKey
        
        let imageToDisplay = imageStore.image(forKey: key)
        albumImg.image = imageToDisplay
        
        toolbar.barTintColor = quaternaryBackgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newTitle = titleTextField.text ?? "Unknown"
        songItem.title = newTitle != "" ? newTitle : "Unknown"
        
        let newArtists = artistsTextField.text ?? "Unknown"
        songItem.artists = newArtists != "" ? newArtists : "Unknown" //todo: split input on comma maybe
        
        // If genre changed then songItem will need to be reinserted to another genre section
        if songItem.genre != genreTextField.text{
            var newGenre = genreTextField.text ?? "Undecided"
            newGenre = newGenre != "" ? newGenre : "Undecided"
            
            let itemViewController = self.navigationController?.viewControllers.first as! ItemsViewController
            itemViewController.songItemStore.reinsertToCorrectGenre(songItem: songItem, newGenre: newGenre)
        }
        
        let newLength = lengthTextField.text ?? "0:00"
        songItem.length = newLength != "" ? newLength : "Unknown"
        songItem.desc = descTextField.text ?? "He must no like it very much"
                        
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as! UIImage
        
        imageStore.setImage(image, forKey: songItem.itemKey)
        
        albumImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
}
