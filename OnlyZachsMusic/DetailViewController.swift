//
//  DetailViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 11/6/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var artistsTextField: UITextField!
    @IBOutlet var genreTextField: UITextField!
    @IBOutlet var lengthTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    
    @IBOutlet var albumImg: UIImageView!

    var songItem: SongItem! {
        didSet {
            navigationItem.title = songItem.title
        }
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        songItem.title = titleTextField.text ?? ""
        songItem.artists = artistsTextField.text ?? "" //todo: split input on comma maybe
        songItem.genre = genreTextField.text ?? ""
        songItem.length = lengthTextField.text ?? ""
        songItem.desc = descTextField.text ?? ""
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
