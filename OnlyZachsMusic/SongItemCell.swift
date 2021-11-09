//
//  SongItemCell.swift
//  OnlyZachsMusic
//
//  Created by Zach Fogg on 11/5/21.
//

import UIKit

class SongItemCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistsLabel: UILabel!
    @IBOutlet var lengthLabel: UILabel!
    @IBOutlet var favoriteImg: UIImageView!
    
    let primaryBackgroundColor = UIColor(hex: 0x0E263D)
    
    private var myReorderImage : UIImage? = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = primaryBackgroundColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let titleFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
//
//        titleLabel.adjustsFontForContentSizeCategory = true
//        titleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)
//
//        let secondaryFont = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
//
//        artistsLabel.adjustsFontForContentSizeCategory = true
//        lengthLabel.adjustsFontForContentSizeCategory = true
//
//        artistsLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: secondaryFont)
//        lengthLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: secondaryFont)
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)  )
    }
    
    /* https://stackoverflow.com/questions/45967210/change-reorder-controls-color-in-table-view-cell */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        for subViewA in self.subviews {
            if (subViewA.classForCoder.description() == "UITableViewCellReorderControl") {
                for subViewB in subViewA.subviews {
                    if (subViewB.isKind(of: UIImageView.classForCoder())) {
                        let imageView = subViewB as! UIImageView;
                        if (self.myReorderImage == nil) {
                            let myImage = imageView.image;
                            myReorderImage = myImage?.withRenderingMode(.alwaysTemplate);
                        }
                        imageView.image = self.myReorderImage;
                        imageView.tintColor = .white;
                        break;
                    }
                }
                break;
            }
        }
    }
}
