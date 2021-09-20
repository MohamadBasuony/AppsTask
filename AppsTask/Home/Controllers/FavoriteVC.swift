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
    
    var favorite = [Food]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTV.delegate = self
        favoriteTV.dataSource = self
        favoriteTV.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        // Do any additional setup after loading the view.
    }
    
    
    func fetchFood(){
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == true",true )
        fetchRequest.predicate = predicate
        favorite = try! DataController.shared.viewContext.fetch(fetchRequest)
        favoriteTV.reloadData()

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
        favoriteTV.reloadData()
        try? DataController.shared.viewContext.save()

    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavoriteVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTV.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.food = favorite[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromFavorite(id : favorite[indexPath.row].id ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
