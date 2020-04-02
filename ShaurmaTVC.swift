//
//  ShaurmaTVC.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 25.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
import RealmSwift

class ShaurmaTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var places: Results<Place>!
    private var filtredPlaces: Results<Place>!
    private var ascendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltred: Bool {return searchController.isActive && !searchBarIsEmpty}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var reverseSortingButton: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltred { return filtredPlaces.count  }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellForShawa
        
        
        var place = Place()
        
        if isFiltred {place = filtredPlaces[indexPath.row]}
        else { place = places[indexPath.row]}
        
        cell.imageOfPlace.image = UIImage(data: place.imgData!)
        cell.shawaName.text = place.name
        cell.locationLable.text = place.location
        cell.shawaPrice.text = place.price
        
        cell.cosmosView.rating = place.rating
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            _, _, complete in
            let place = self.places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place: Place
           
            if isFiltred {
                place = filtredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as? NewShawa
            newPlaceVC?.currentPlace = place
            
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newShawaVC = segue.source as? NewShawa else {return}
        
        newShawaVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection (_ sender: UISegmentedControl) {
       sorting()
    }
    
    @IBAction func reverseSorting (_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverseSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverseSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControll.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension ShaurmaTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredPlaces = places.filter(
            "name CONTAINS[c] %@ or location CONTAINS[c] %@", searchText, searchText
        )
        tableView.reloadData()
    }
    
}
