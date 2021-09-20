//
//  FoodCell.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 19/09/2021.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodNameLabel1: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var vc : ViewController?
    var food : Food? {
        didSet {
            backgroundImage.image = UIImage(named: food?.backgroundImage ?? "")
            foodImage.image = UIImage(named: food?.foodImage ?? "")
            foodPriceLabel.text = "\(food!.price)$"
            foodNameLabel.text = food?.name ?? ""
            foodNameLabel1.text = food?.name ?? ""
            if food!.isFavorite {
                favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
            }else {
                favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
            }
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
        if food!.isFavorite {
            vc?.toggleFavorite(id: food?.id ?? "", isFavorite: false)
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }else {
            vc?.toggleFavorite(id: food?.id ?? "", isFavorite: true)
            favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
    }
    
}
