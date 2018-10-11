//
//  LoginSuccessViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 05/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cidaas

class LoginSuccessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTable: UITableView!
    
    // local variables
    var cidaas = Cidaas.shared
    var timer: Timer!
    var sub: String = ""
    var userDefaults = UserDefaults.standard
    
    var itemList : [Cart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTable.rowHeight = 132
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        getItemList()
        cidaas.delegate = self
    }
    
    func getItemList() {
        var cart1 = Cart()
        cart1.image = UIImage(named: "iphone1")!
        cart1.body = "50% offer!!"
        cart1.color = "Grey"
        cart1.name = "iPhone XS MAX"
        cart1.prize = "Rs.46,000"
        cart1.rating = 4
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphone2")!
        cart1.body = "EMI starts from Rs.7000/month"
        cart1.color = "Silver"
        cart1.name = "iPhone X"
        cart1.prize = "Rs.81,599"
        cart1.rating = 3
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "honor9")!
        cart1.body = "No Cost EMI available"
        cart1.color = "Black"
        cart1.name = "Honor 9 Lite"
        cart1.prize = "Rs.14,599"
        cart1.rating = 5
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "motog5")!
        cart1.body = "EMI not available"
        cart1.color = "Lunar Grey"
        cart1.name = "Moto G5S Plus"
        cart1.prize = "Rs.12,599"
        cart1.rating = 4
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphone6splus")!
        cart1.body = "3% offer!!"
        cart1.color = "Grey"
        cart1.name = "iPhone 6S Plus"
        cart1.prize = "Rs.42,999"
        cart1.rating = 2
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphonese")!
        cart1.body = "Save Rs.2,000"
        cart1.color = "Rose Gold"
        cart1.name = "iPhone SE"
        cart1.prize = "Rs.18,999"
        cart1.rating = 5
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "oneplus3t")!
        cart1.body = "Save Rs.12,000"
        cart1.color = "Dark Black"
        cart1.name = "One Plus 3T"
        cart1.prize = "Rs.26,799"
        cart1.rating = 3
        cart1.favourites = true
        
        itemList.append(cart1)
        
        myTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemsTableViewCell", for: indexPath) as! CartItemsTableViewCell
        cell.cartImage.image = itemList[indexPath.row].image
        cell.name.text = itemList[indexPath.row].name
        cell.color.text = itemList[indexPath.row].color
        cell.prize.text = itemList[indexPath.row].prize
        cell.body.text = itemList[indexPath.row].body
        cell.rating.rating = itemList[indexPath.row].rating
        if itemList[indexPath.row].favourites == true {
            cell.favourites.image = UIImage(named: "orangeheart")
        }
        else {
            cell.favourites.image = UIImage(named: "blackheart")
        }
        cell.favourites.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeFavourites(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.favourites.isUserInteractionEnabled = true
        cell.favourites.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func changeFavourites(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        if imgView.image == UIImage(named: "orangeheart") {
//            cell.favourites.image = UIImage(named: "blackheart")
        }
        else {
//            cell.favourites.image = UIImage(named: "orangeheart")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sub = ((userDefaults.object(forKey: "sub") ?? "") as? String) ?? ""
        if sub == "" {
            self.navigationItem.rightBarButtonItem?.title = "Login"
        }
        else {
            self.navigationItem.rightBarButtonItem?.title = "Logout"
            self.cidaas.startTracking(sub: sub)
        }
    }
    
    @IBAction func rightBarButtonItemClick(_ sender: Any) {
        if self.navigationItem.rightBarButtonItem?.title == "Logout" {
            self.cidaas.stopTracking()
            userDefaults.removeObject(forKey: "sub")
            userDefaults.synchronize()
            self.navigationItem.rightBarButtonItem?.title = "Login"
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
