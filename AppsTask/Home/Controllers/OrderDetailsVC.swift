//
//  OrderDetailsVC.swift
//  AppsTask
//
//  Created by Mohamad Basuony on 19/09/2021.
//

import UIKit
import CoreData

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var flipImage: UIImageView!
    @IBOutlet weak var orderImagesCV: UICollectionView!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var quantity = 0.0
    var selctedSizePrice = 0.0
    var food : Food?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderImagesCV.dataSource = self
        orderImagesCV.delegate = self
        orderImagesCV.isPrefetchingEnabled = false
        orderImagesCV.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        let layOut = UICollectionViewFlowLayout()
        layOut.sectionInset = UIEdgeInsets.init(top: 10 , left: 0, bottom: 10, right: 0)
        layOut.itemSize = CGSize(width: self.view.frame.width, height:300)
        layOut.minimumInteritemSpacing = 0
        layOut.minimumLineSpacing = 0
        layOut.scrollDirection = .horizontal
        orderImagesCV.collectionViewLayout = layOut

        // Do any additional setup after loading the view.
    }
    
    func UIInit (){
        
    }
    
    func configureCell() {
        orderImagesCV.reloadData()
    }
    
    func fetchProduct() -> [Cart]{
        let fetchRequest : NSFetchRequest<Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "id == %@",food!.id!  )
        fetchRequest.predicate = predicate
        return try! DataController.shared.viewContext.fetch(fetchRequest)
    }
    
    func checkIfInCart() -> Bool{
        print("Check")
        let result = fetchProduct()
        if result.count < 1 {
            return false
        }else{
            return true
        }
    }
    
    func addFoodtoCart(){
        let cart = Cart(context: DataController.shared.viewContext)
        cart.id = food?.id ?? "0"
        cart.name = food?.name ?? ""
        cart.price = selctedSizePrice
        cart.count = quantity
        cart.image = food?.foodImage ?? ""
        cart.size = sizeLabel.text ?? ""
        try? DataController.shared.viewContext.save()
    }
    
    func editProduct(){
        let result = fetchProduct()
        if result.first!.size != sizeLabel.text! {
            let alert = UIAlertController(title: nil, message: "Do you want to change the size ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "No", style: .default, handler: nil)
            let signin = UIAlertAction(title: "Yes", style: .default) { (action) in
                result.first!.size = self.sizeLabel.text ?? ""
                result.first?.price = self.selctedSizePrice
            }
            
            alert.addAction(ok)
            alert.addAction(signin)
            present(alert, animated: true, completion: nil)
        }else{
            result.first?.count = (result.first?.count ?? 0) + quantity
        }
        try? DataController.shared.viewContext.save()

    }
    
    @IBAction func plusButton(_ sender: Any) {
        quantity = quantity + 1
        quantityLabel.text = "\(quantity)"
    }
    
    
    @IBAction func minusButton(_ sender: Any) {
        if quantity == 0 {
            quantityLabel.text = "\(quantity)"
        }else{
            quantity = quantity - 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    @IBAction func orderButton(_ sender: Any) {
        flipImage.image = UIImage(named: "whiteFllipped")
        orderButton.isHidden = true
        addToCartButton.isHidden = false
        UIView.transition(with: flipImage, duration: 1, options: .transitionFlipFromBottom, animations: nil, completion: nil)
        UIView.animate(withDuration: 1) {
            self.counterView.isHidden = false
            self.addButtonBottomConstraint.constant = 30
            self.labelTopConstraint.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    @IBAction func addToCartButton(_ sender: Any) {
        print("ADD To Cart")
        if checkIfInCart() {
            print("Edit To Cart")
            editProduct()
        }else{
            print("ADD To Cart")

            addFoodtoCart()
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orderImagesCV.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.orderImage.image = UIImage(named: food?.foodImage ?? "")
        switch indexPath.row {
        case 0 :
            cell.imageWidth.constant = 300
            cell.imageHeight.constant = 300
            sizeLabel.text = "Big"
            priceLabel.text = "\(food?.price ?? 0)"
            selctedSizePrice = food?.price ?? 0.0
            
        case 1 :
            cell.imageWidth.constant = 250
            cell.imageHeight.constant = 250
            sizeLabel.text = "Medium"
            priceLabel.text = "\(food?.mediumPrice ?? 0)"
            selctedSizePrice = food?.mediumPrice ?? 0.0

        case 2 :
            cell.imageWidth.constant = 200
            cell.imageHeight.constant = 200
            sizeLabel.text = "Small"
            priceLabel.text = "\(food?.smallPrice ?? 0)"
            selctedSizePrice = food?.smallPrice ?? 0.0

        default:
            break
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width, height: 300)
//    }
    
    
}
