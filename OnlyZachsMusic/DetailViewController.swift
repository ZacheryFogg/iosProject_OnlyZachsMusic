//
//  DetailViewController.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 11/6/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteImg: UIImageView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var artistsTextField: UITextField!
    @IBOutlet var genreTextField: UITextField!
    @IBOutlet var lengthTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    
    @IBOutlet var albumImg: UIImageView!

    var songItem: SongItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = songItem.title
        
        titleTextField.text = songItem.title
        artistsTextField.text = songItem.artists.reduce(" ") {$0 + $1}
        genreTextField.text = songItem.genre
        lengthTextField.text = songItem.length
        descTextField.text = songItem.desc
        
        if songItem.isFavorite {
            favoriteImg.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
            favoriteImg.tintColor = .white
        } else {
            favoriteImg.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
            favoriteImg.tintColor = .white
        }
        
    }
    
}
