//
//  DeduplicationViewController.swift
//  SDKCheck
//
//  Created by ganesh on 18/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import SCLAlertView

class DeduplicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet var myTable: UITableView!
    
    // local variables
    var cidaas = Cidaas.shared
    var track_id: String = ""
    var deduplicationList: [DuplicationList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTable.rowHeight = 100
        
        getDeduplicationList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDeduplicationList() {
        
        // show loader
        showLoader()
        
         // call get deduplication details API
        cidaas.getDeduplicationDetails(track_id: track_id) {
            switch $0 {
                case .failure(let error):
                    
                    // hide loader
                    self.hideLoader()
                    self.showAlert(message: error.errorMessage, style: .info)
                
                case .success(let response):
                    print("EMAIL : \(response.data.email)")
                    self.deduplicationList = response.data.deduplicationList
                    self.myTable.reloadData()
                    
                    // hide loader
                    self.hideLoader()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deduplicationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeduplicationTableViewCell", for: indexPath) as! DeduplicationTableViewCell
        cell.name.text = deduplicationList[indexPath.row].displayName
        cell.email.text = deduplicationList[indexPath.row].email
        return cell
    }
    
    // show alert
    func showAlert(title: String = "Warning", message: String, style: SCLAlertViewStyle) {
        
        var colorStyle : UInt = 0xFD9226
        
        if (style == .info) {
            colorStyle = 0xFD9226
        }
        else if (style == .success) {
            colorStyle = 0x2DB475
        }
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: message, // String of view
            style: style, // Styles - see below.
            closeButtonTitle: "OK",
            colorStyle: colorStyle,
            colorTextButton: 0xFFFFFF
        )
    }
    
    @IBAction func register(_ sender: Any) {
        
        // show loader
        showLoader()
        
        // call register user API
        cidaas.registerUser(track_id: track_id) {
            switch $0 {
            case .failure(let error):
                
                // hide loader
                self.hideLoader()
                self.showAlert(message: error.errorMessage, style: .info)
                
            case .success(let response):
                print("SUB : \(response.data.sub)")
                
                // hide loader
                self.hideLoader()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSuccessViewController") as! RegisterSuccessViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { _ in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }
}
