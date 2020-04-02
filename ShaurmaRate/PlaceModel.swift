//
//  PlaceModel.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 28.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var price: String?
    @objc dynamic var imgData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0

    
    convenience init (
        name: String, location: String?, price: String?, imgData: Data?, rating: Double
    ) {
        self.init()
        self.name = name
        self.location = location
        self.price = price
        self.imgData = imgData
        self.rating = rating
    }
}

