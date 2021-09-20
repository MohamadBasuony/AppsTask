//
//  ViewController.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 19/09/2021.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var kindsCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodTV: UITableView!
    
    var kinds = [String]()
    var filteredFood = [Food]()

    var food = [Food]()
    var selectedIndex = 0
    
    var currentIndex = IndexPath(item: 0, section: 0)
    var previousIndex = IndexPath(item: 0, section: 0)

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kindsCV.delegate = self
        kindsCV.dataSource = self
        kindsCV.register(UINib(nibName: "KindCell", bundle: nil), forCellWithReuseIdentifier: "KindCell")
        
        foodTV.delegate = self
        foodTV.dataSource = self
        foodTV.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
        
        searchBar.delegate = self
        
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

        fetchFood(foodType: "0")

        // Do any additional setup after loading the view.
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
        foodTV.reloadData()
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
        foodTV.reloadData()
        try? DataController.shared.viewContext.save()

    }
    func filterArr(searchTxt :String){
   
        self.filteredFood = self.food.filter { $0.name?.localizedCaseInsensitiveContains(searchTxt) ?? true }
        self.foodTV.reloadData()

    }

    @IBAction func cartButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kinds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = kindsCV.dequeueReusableCell(withReuseIdentifier: "KindCell", for: indexPath) as! KindCell
        if indexPath.row == 0 {
            cell.customBackgroundView.backgroundColor = TaskColors.lightOrange.color
        }
        cell.kindNameLabel.text = kinds[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        previousIndex = currentIndex
        currentIndex = indexPath
        print(previousIndex , currentIndex)
        let cell = kindsCV.cellForItem(at: indexPath) as! KindCell
        let previousCell = kindsCV.cellForItem(at: previousIndex) as! KindCell

        cell.customBackgroundView.backgroundColor = TaskColors.lightOrange.color
        previousCell.customBackgroundView.backgroundColor = UIColor.white
        fetchFood(foodType: "\(indexPath.item)")
//        foodTV.reloadData()
//        foodTV.scrollToRow(at: IndexPath(row: 0, section: indexPath.section ), at: .top, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 40)
    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTV.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        cell.vc = self
        cell.food = filteredFood[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodTV.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.food = filteredFood[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        if searchText == ""{
            self.view.endEditing(true)
            self.filteredFood = self.food
            self.foodTV.reloadData()
        }else{
            self.filterArr(searchTxt: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
