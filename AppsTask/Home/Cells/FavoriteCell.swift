//
//  FavoriteCell.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 20/09/2021.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodNameLabel1: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var viewModel : ViewModel?

    var food : Food? {
        didSet {
            foodImage.image = UIImage(named: food?.foodImage ?? "")
            priceLabel.text = "\(food!.price)$"
            foodNameLabel.text = food?.name ?? ""
            foodNameLabel1.text = food?.name ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        viewModel?.deleteFromFavorite(id : food?.id ?? "")
    }
}
