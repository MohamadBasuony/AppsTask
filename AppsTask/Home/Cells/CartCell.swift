//
//  CartCell.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 20/09/2021.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodNameLabel1: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    var qunatity = 0.0
    var price = 0.0
    var viewModel : ViewModel?
    var cart : Cart? {
        didSet {
            foodImage.image = UIImage(named: cart?.image ?? "")
            foodNameLabel.text = cart?.name ?? ""
            foodNameLabel1.text = cart?.name ?? ""
            quantityLabel.text = "\(cart?.count ?? 0.0)"
            qunatity = (cart?.count ?? 0.0)
            price =  qunatity * (cart?.price ?? 0)
            priceLabel.text = "\(price)$"

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

    @IBAction func plusButton(_ sender: Any) {
        price = price + (cart?.price ?? 0)
        priceLabel.text = "\(price)$"
        qunatity = qunatity + 1
        quantityLabel.text = "\(qunatity)"
        viewModel?.updateQuantity(id: cart?.id ?? "0", quantity: qunatity, plus: true)
        
    }
    
    @IBAction func minusButton(_ sender: Any) {
        
        if (qunatity - 1) == 0 {
            quantityLabel.text = "\(1)"
            viewModel?.updateQuantity(id: cart?.id ?? "0", quantity: 0, plus: false)
        }else{
            price = price - (cart?.price ?? 0)
            priceLabel.text = "\(price)$"
            qunatity = qunatity - 1
            quantityLabel.text = "\(qunatity)"
            viewModel?.updateQuantity(id: cart?.id ?? "0", quantity: qunatity, plus: false)

        }
    }
}
