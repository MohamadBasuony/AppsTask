//
//  CartVC.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 20/09/2021.
//

import UIKit
import CoreData

class CartVC: UIViewController {

    
    @IBOutlet weak var cartTV: UITableView!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var totalOrderLabel: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    
    
    var viewModel = ViewModel()
    
//    var cart = [Cart]()
    var totalAmount = 0.0
    var total = 0.0
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        cartTV.delegate = self
        cartTV.dataSource = self
        cartTV.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        viewModel.fetchCartProducts()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func checkOutButton(_ sender: Any) {
        viewModel.checkout()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CartVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartProoducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTV.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.cart = viewModel.cartProoducts[indexPath.row]
        cell.viewModel = viewModel
        totalAmount = totalAmount + (viewModel.cartProoducts[indexPath.row].price * viewModel.cartProoducts[indexPath.row].count)
        total = totalAmount + 10.02
        if (indexPath.row + 1) == viewModel.cartProoducts.count {
            orderAmountLabel.text = "\(totalAmount)"
            totalOrderLabel.text = "\(total)"
            checkOutButton.setTitle("Checkout $\(total)", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
        viewModel.deleteFromCart(id : viewModel.cartProoducts[indexPath.row].id ?? "")
       }
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension CartVC : ViewModelDelegate {
    func getCartProductsDidSuccess(){
        cartTV.reloadData()
    }
    
    func checkoutDidSuccess() {
        cartTV.reloadData()
        totalAmount = 0.0
        self.orderAmountLabel.text = "\(self.totalAmount)"
        self.totalOrderLabel.text = "\(0.0)"
        self.checkOutButton.setTitle("Checkout", for: .normal)
    }
    
    func deleteProductFromCartDidSuccess() {
        totalAmount = 0.0
//        let index = cart.firstIndex(where:  { (food) -> Bool in
//            food.id == id
//        })
//        cart.remove(at: index!)
//        let foodToDelete  = fetchProductFromCart(foodId: id)
        if viewModel.cartProoducts.count == 0 {
            self.orderAmountLabel.text = "\(self.totalAmount)"
            self.totalOrderLabel.text = "\(0.0)"
            self.checkOutButton.setTitle("Checkout", for: .normal)
        }
        cartTV.reloadData()
        
    }
    
    func showCheckQuantityAlert(id : String) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to remove this product from cart?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.viewModel.deleteFromCart(id : id)
        }
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)

    }
    
    func upadetPrice(price : Double , plus : Bool){
        if plus {
            totalAmount = totalAmount + price
            total = total + price
        }else{
            
            totalAmount = totalAmount - price
            total = total - price
        }
        
        
        orderAmountLabel.text = "\(totalAmount)"
        totalOrderLabel.text = "\(total)"
        checkOutButton.setTitle("Checkout $\(total)", for: .normal)
    }

}
