//
//  TableViewController.swift
//  contact_book
//
//  Created by Oleksii Kolakovskyi on 1/22/20.
//  Copyright © 2020 Aleksey. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AlamofireImage

class TableViewController: UITableViewController {
    
    var contacts = [Contact]()
    var dict: [String: [Contact]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

            
            let data = contactsJson.data(using: .utf8)
            contacts = try! JSONDecoder().decode([Contact].self, from: data!)
            
            for contact in contacts {
                dict["\(contact.first_name?.first ?? contact.last_name?.first ?? contact.email?.first)"] = []
            }
            
            for contact in contacts {
                dict["\(contact.first_name?.first ?? contact.last_name?.first ?? contact.email?.first)"]?.append(contact)
            }
            
            
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dict.keys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(dict.keys).sorted()[section]
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(dict.keys).sorted()[section]
        return dict[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell?
        
        let key = Array(dict.keys).sorted()[indexPath.section]
               let collectionFromDict = dict[key]
               
               let contact = collectionFromDict![indexPath.row]
        
        cell?.avatarImageView.loadImages(contact.avatar ?? "https://image.flaticon.com/icons/png/512/64/64572.png")
        cell?.nameLabel.text = "\((contact.first_name ?? "") + " " + (contact.last_name ?? ""))"
        cell?.emailLabel.text = contact.email
        cell?.phoneNumberLabel.text = contact.phone_number

        return cell!
    }
    
}

let imageCache = NSCache < NSString, UIImage>()

extension UIImageView {
    func loadImages(_ urlString: String) {
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        Alamofire.request(urlString)
            .responseImage {responce in
                if let downloadedImage = responce.result.value {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
        }
    }
}

