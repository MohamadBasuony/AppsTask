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
    
    var cart = [Cart]()
    var totalAmount = 0.0
    var total = 0.0
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTV.delegate = self
        cartTV.dataSource = self
        cartTV.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        fetchCartProducts()
        // Do any additional setup after loading the view.
    }
    
    func fetchCartProducts(){
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        cart = try! DataController.shared.viewContext.fetch(fetchRequest)
        cartTV.reloadData()
    }
    
    func fetchProduct(id : String) -> [Cart]{
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "id == %@",id )
        fetchRequest.predicate = predicate
        return try! DataController.shared.viewContext.fetch(fetchRequest)
    }
    
    func updateQuantity(id : String , quantity : Double , plus : Bool){
        let result = fetchProduct(id: id)
       
        if quantity == 0  {
                let alert = UIAlertController(title: nil, message: "Are you sure you want to remove this product from cart?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "No", style: .default, handler: nil)
                let signin = UIAlertAction(title: "Yes", style: .default) { (action) in
                    self.deleteFromCart(id : id)
                }
                alert.addAction(ok)
                alert.addAction(signin)
                present(alert, animated: true, completion: nil)
        }else{
            result.first?.count = quantity
            try? DataController.shared.viewContext.save()

            if plus {
                totalAmount = totalAmount + ((result.first?.price ?? 0))
            }else{
                totalAmount = totalAmount - ((result.first?.price ?? 0))
            }
            total = totalAmount
            orderAmountLabel.text = "\(totalAmount)"
            totalOrderLabel.text = "\(total)"
            checkOutButton.setTitle("Checkout $\(total)", for: .normal)
            
        }
        
    }
    
    func deleteFromCart(id : String){
        totalAmount = 0.0
        let index = cart.firstIndex(where:  { (food) -> Bool in
            food.id == id
        })
        cart.remove(at: index!)
        let foodToDelete  = fetchProduct(id: id)
        if cart.count == 0 {
            self.orderAmountLabel.text = "\(self.totalAmount)"
            self.totalOrderLabel.text = "\(0.0)"
            self.checkOutButton.setTitle("Checkout", for: .normal)
        }
        DataController.shared.viewContext.delete(foodToDelete.first!)
        try? DataController.shared.viewContext.save()
        cartTV.reloadData()
    }
    
    func checkout(){
        totalAmount = 0.0
        self.orderAmountLabel.text = "\(self.totalAmount)"
        self.totalOrderLabel.text = "\(0.0)"
        self.checkOutButton.setTitle("Checkout", for: .normal)
        for x in cart {
            DataController.shared.viewContext.delete(x)
            try? DataController.shared.viewContext.save()
        }
        cart.removeAll()
        cartTV.reloadData()
    }
    
    @IBAction func checkOutButton(_ sender: Any) {
        checkout()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CartVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTV.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.cart = cart[indexPath.row]
        cell.vc = self
        totalAmount = totalAmount + (cart[indexPath.row].price * cart[indexPath.row].count)
        total = totalAmount + 10.02
        if (indexPath.row + 1) == cart.count {
            orderAmountLabel.text = "\(totalAmount)"
            totalOrderLabel.text = "\(total)"
            checkOutButton.setTitle("Checkout $\(total)", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
        deleteFromCart(id : cart[indexPath.row].id ?? "")
       }
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
