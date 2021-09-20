//
//  ImageCell.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 19/09/2021.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
