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
    
    var viewModel = ViewModel()

    var selectedIndex = 0
    
    var currentIndex = IndexPath(item: 0, section: 0)
    var previousIndex = IndexPath(item: 0, section: 0)

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchFood(foodType: "\(selectedIndex)")

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
        
        viewModel.delegate = self
        
        viewModel.storeInit()

//        viewModel.fetchFood(foodType: "\(selectedIndex)")

        // Do any additional setup after loading the view.
    }


    

    

    
//   
    
    func filterArr(searchTxt :String){
   
        self.viewModel.filteredFood = self.viewModel.food.filter { $0.name?.localizedCaseInsensitiveContains(searchTxt) ?? true }
        self.foodTV.reloadData()

    }

    @IBAction func cartButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.kinds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = kindsCV.dequeueReusableCell(withReuseIdentifier: "KindCell", for: indexPath) as! KindCell
        if indexPath.row == 0 {
            cell.customBackgroundView.backgroundColor = TaskColors.lightOrange.color
        }
        cell.kindNameLabel.text = viewModel.kinds[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        previousIndex = currentIndex
        currentIndex = indexPath
        let cell = kindsCV.cellForItem(at: indexPath) as! KindCell
        let previousCell = kindsCV.cellForItem(at: previousIndex) as! KindCell
        cell.customBackgroundView.backgroundColor = TaskColors.lightOrange.color
        previousCell.customBackgroundView.backgroundColor = UIColor.white
        viewModel.fetchFood(foodType: "\(selectedIndex)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 40)
    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTV.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        cell.viewModel = viewModel
        cell.food = viewModel.filteredFood[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodTV.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.food = viewModel.filteredFood[indexPath.row]
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
            self.viewModel.filteredFood = self.viewModel.food
            self.foodTV.reloadData()
        }else{
            self.filterArr(searchTxt: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension ViewController : ViewModelDelegate {
    
    func getHomeProductDidSuccess() {
        foodTV.reloadData()
    }
    
}
