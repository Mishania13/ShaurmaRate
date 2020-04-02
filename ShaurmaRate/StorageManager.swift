//
//  StorageManager.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 30.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
