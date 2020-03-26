//
//  ShaurmaTVC.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 25.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class ShaurmaTVC: UITableViewController {
    
    var popShavaPlaces = [ "Евро Кебаб", "Мастер Кебаб" , "На Лиговском",
                           "Хорошая шаверма", "У Захара", "Гирос", "Шеф шаверма"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: - Table view data source
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        popShavaPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellForShawa
        
        cell.shawaName.text = popShavaPlaces[indexPath.row]
        cell.imageOfPlace?.image = UIImage(named: popShavaPlaces[indexPath.row])
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace?.clipsToBounds = true
        
        return cell
    }
    
    
    
}
