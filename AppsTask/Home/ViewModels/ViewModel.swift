//
//  HomeViewModel.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 23/09/2021.
//

import Foundation
import CoreData

protocol ViewModelDelegate: class {
    func getHomeProductDidSuccess()
   
    func showCheckSizeAlert()
    
    func itemAddedToCartSuccessfullly()
    
    func getFavoriteProductsDidSuccess()
    
    func getCartProductsDidSuccess()
    
    func deleteProductFromCartDidSuccess()
    
    func showCheckQuantityAlert(id : String)

    func upadetPrice(price : Double , plus : Bool)
    
    func checkoutDidSuccess()

}

extension ViewModelDelegate {
    func getHomeProductDidSuccess(){}
    
    func showCheckSizeAlert(){}
    
    func itemAddedToCartSuccessfullly(){}
    
    func getFavoriteProductsDidSuccess(){}
    
    func getCartProductsDidSuccess(){}
    
    func deleteProductFromCartDidSuccess(){}
    
    func showCheckQuantityAlert(id : String){}

    func upadetPrice(price : Double , plus : Bool){}
    
    func checkoutDidSuccess(){}
}


class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    var kinds = [String]()
    var filteredFood = [Food]()
    var food = [Food]()
    var favorite = [Food]()
    var cartProoducts = [Cart]()
    func storeInit(){
        kinds.append("Burger")
        kinds.append("Pizza")
        kinds.append("Pasta")
        kinds.append("Salad")
        
        if !UserDefaults.standard.bool(forKey: "firstTime") {
            UserDefaults.standard.set(true, forKey: "firstTime")
            addFoodtoStore(id: "0", name: "Cheese Burger", price: 20.0, isFavorite: true, backgroundImage: "orange", foodImage: "burger", foodType: "0" , mediumPrice : 15 , smallPrice: 10)
            addFoodtoStore(id: "1", name: "Cheese Burger", price: 20.0, isFavorite: false, backgroundImage: "green", foodImage: "burger1", foodType: "0" , mediumPrice : 15 , smallPrice: 10)
            addFoodtoStore(id: "2", name: "Cheese Burger", price: 20.0, isFavorite: true, backgroundImage: "orange", foodImage: "burger", foodType: "0", mediumPrice : 15 , smallPrice: 10)
            
            addFoodtoStore(id: "3", name: "Pizza", price: 30.0, isFavorite: false, backgroundImage: "orange", foodImage: "pizza", foodType: "1", mediumPrice : 15 , smallPrice: 10)
            addFoodtoStore(id: "4", name: "Hawiian Pizza", price: 10.0, isFavorite: true, backgroundImage: "green", foodImage: "pizza1", foodType: "1", mediumPrice : 15 , smallPrice: 10)
        }
    }
    
    func addFoodtoStore (id : String,name: String, price: Double, isFavorite: Bool, backgroundImage: String, foodImage: String , foodType : String , mediumPrice : Double , smallPrice : Double ){
        let food = Food(context: DataController.shared.viewContext)
        food.id = id
        food.name = name
        food.price = price
        food.isFavorite = isFavorite
        food.backgroundImage = backgroundImage
        food.foodImage = foodImage
        food.foodType = foodType
        food.mediumPrice = mediumPrice
        food.smallPrice = smallPrice
        try? DataController.shared.viewContext.save()
    }
    
    func fetchFood(foodType : String){
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "foodType == %@",foodType )
        fetchRequest.predicate = predicate
        food = try! DataController.shared.viewContext.fetch(fetchRequest)
        filteredFood = food
        self.delegate?.getHomeProductDidSuccess()
        print(food)
    }
    
    func fetchProduct(id : String) -> [Food]{
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "id == %@",id )
        fetchRequest.predicate = predicate
        return try! DataController.shared.viewContext.fetch(fetchRequest)
    }

    func toggleFavorite(id : String , isFavorite : Bool){
        let index = food.firstIndex(where:  { (food) -> Bool in
            food.id == id
        })
        food[index!].isFavorite = isFavorite
        let foodToDelete  = fetchProduct(id: id)
        foodToDelete.first?.isFavorite = isFavorite
//        foodTV.reloadData()
        try? DataController.shared.viewContext.save()
        
    }
    
    func fetchProductFromCart(foodId: String) -> [Cart]{
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "id == %@",foodId  )
        fetchRequest.predicate = predicate
        return try! DataController.shared.viewContext.fetch(fetchRequest)
    }
    
    func checkIfInCart(foodId: String) -> Bool{
        print("Check")
        let result = fetchProductFromCart(foodId: foodId)
        if result.count < 1 {
            return false
        }else{
            return true
        }
    }
    
    func addFoodtoCart(food: Food , selctedSizePrice : Double , quantity : Double , size : String){
        let cart = Cart(context: DataController.shared.viewContext)
        cart.id = food.id ?? "0"
        cart.name = food.name ?? ""
        cart.price = selctedSizePrice
        cart.count = quantity
        cart.image = food.foodImage ?? ""
        cart.size = size
        try? DataController.shared.viewContext.save()
        self.delegate?.itemAddedToCartSuccessfullly()
    }
    
    func checkSize (foodId: String ,size : String ,price : Double , quantity : Double){
        let result = fetchProductFromCart(foodId: foodId)
        if result.first!.size != size {
            self.delegate?.showCheckSizeAlert()
        }else{
            editProduct(foodId: foodId, size: size, price: price, quantity: quantity)
        }
    }
    
    func editProduct(foodId: String ,size : String ,price : Double , quantity : Double){
        let result = fetchProductFromCart(foodId: foodId)
//        if result.first!.size != sizeLabel.text! {
//            let alert = UIAlertController(title: nil, message: "Do you want to change the size ?", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "No", style: .default, handler: nil)
//            let signin = UIAlertAction(title: "Yes", style: .default) { (action) in
                result.first!.size = size
                result.first?.price = price
//            }
//
//            alert.addAction(ok)
//            alert.addAction(signin)
//            present(alert, animated: true, completion: nil)
//        }else{
            result.first?.count = (result.first?.count ?? 0) + quantity
//        }
        try? DataController.shared.viewContext.save()
        self.delegate?.itemAddedToCartSuccessfullly()

    }
    
    func fetchFavoriteFood(){
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == true",true )
        fetchRequest.predicate = predicate
        favorite = try! DataController.shared.viewContext.fetch(fetchRequest)
        self.delegate?.getFavoriteProductsDidSuccess()
//        favoriteTV.reloadData()
    }
    
    func deleteFromFavorite(id : String){
        let index = favorite.firstIndex(where:  { (food) -> Bool in
            food.id == id
        })
        favorite.remove(at: index!)
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "id == %@",id )
        fetchRequest.predicate = predicate
        let foodToDelete  = try! DataController.shared.viewContext.fetch(fetchRequest)
        foodToDelete.first?.isFavorite = false
        self.delegate?.getFavoriteProductsDidSuccess()
//        favoriteTV.reloadData()
        try? DataController.shared.viewContext.save()

    }
    
    func fetchCartProducts(){
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        cartProoducts = try! DataController.shared.viewContext.fetch(fetchRequest)
//        cartTV.reloadData()
    }
    
//    func fetchProduct(id : String) -> [Cart]{
//        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
//        let predicate = NSPredicate(format: "id == %@",id )
//        fetchRequest.predicate = predicate
//        return try! DataController.shared.viewContext.fetch(fetchRequest)
//    }
    
    func updateQuantity(id : String , quantity : Double , plus : Bool){
        let result = fetchProductFromCart(foodId: id)
       
        if quantity == 0  {
//                let alert = UIAlertController(title: nil, message: "Are you sure you want to remove this product from cart?", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "No", style: .default, handler: nil)
//                let signin = UIAlertAction(title: "Yes", style: .default) { (action) in
//                    self.deleteFromCart(id : id)
//                }
//                alert.addAction(ok)
//                alert.addAction(signin)
//                present(alert, animated: true, completion: nil)
            self.delegate?.showCheckQuantityAlert(id : id)
        }else{
            result.first?.count = quantity
            try? DataController.shared.viewContext.save()
//
//            if plus {
            self.delegate?.upadetPrice(price : ((result.first?.price ?? 0) ) , plus : plus)
//                totalAmount = totalAmount + ((result.first?.price ?? 0))
//            }else{
//                self.delegate?.upadetPrice(price : (-(result.first?.price ?? 0) ))

//                totalAmount = totalAmount - ((result.first?.price ?? 0))
//            }
//            total = totalAmount
//            orderAmountLabel.text = "\(totalAmount)"
//            totalOrderLabel.text = "\(total)"
//            checkOutButton.setTitle("Checkout $\(total)", for: .normal)
//
        }
        
    }
    
    func deleteFromCart(id : String){
//        totalAmount = 0.0
        let index = cartProoducts.firstIndex(where:  { (food) -> Bool in
            food.id == id
        })
        cartProoducts.remove(at: index!)
        let foodToDelete  = fetchProductFromCart(foodId: id)
//        if cart.count == 0 {
//            self.orderAmountLabel.text = "\(self.totalAmount)"
//            self.totalOrderLabel.text = "\(0.0)"
//            self.checkOutButton.setTitle("Checkout", for: .normal)
//        }
        
        DataController.shared.viewContext.delete(foodToDelete.first!)
        try? DataController.shared.viewContext.save()
        self.delegate?.deleteProductFromCartDidSuccess()

    }
    
    func checkout(){
        for x in cartProoducts {
            DataController.shared.viewContext.delete(x)
            try? DataController.shared.viewContext.save()
        }
        cartProoducts.removeAll()
        
        self.delegate?.checkoutDidSuccess()

    }
}
