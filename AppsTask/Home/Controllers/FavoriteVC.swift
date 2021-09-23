//
//  FavoriteVC.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 20/09/2021.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController {

    @IBOutlet weak var favoriteTV: UITableView!
    
//    var favorite = [Food]()
    
    var viewModel = ViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchFavoriteFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        favoriteTV.delegate = self
        favoriteTV.dataSource = self
        favoriteTV.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        // Do any additional setup after loading the view.
    }
    
    

    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavoriteVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTV.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.viewModel = viewModel
        cell.food = viewModel.favorite[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFromFavorite(id : viewModel.favorite[indexPath.row].id ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension FavoriteVC : ViewModelDelegate {
    func getFavoriteProductsDidSuccess() {
        favoriteTV.reloadData()
    }
    
    
}
