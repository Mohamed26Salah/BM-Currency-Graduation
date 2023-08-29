//
//  FavoritesManager.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 27/08/2023.
//

import Foundation
import RealmSwift

class FavouritesManager {
    private init() {}
    
    private static let sharedInstance = FavouritesManager()
    private let realm = try! Realm()

    static func shared() -> FavouritesManager {
        return FavouritesManager.sharedInstance
    }
   
    func addToFavorites(item: FavouriteItem) {
        try! realm.write {
            if let existingItem = realm.object(ofType: FavouriteItem.self, forPrimaryKey: item.currencyCode) {
                if !existingItem.isInvalidated {
                    realm.delete(existingItem)
                }
            }

            let newItem = FavouriteItem(currencyCode: item.currencyCode, imageUrl: item.imageUrl)
            realm.add(newItem, update: .modified)
        }
    }

    func isItemFavorited(item: FavouriteItem) -> Bool {
        return realm.object(ofType: FavouriteItem.self, forPrimaryKey: item.currencyCode) != nil
    }

    func removeFromFavorites(item: FavouriteItem) {
        if let itemToDelete = realm.object(ofType: FavouriteItem.self, forPrimaryKey: item.currencyCode) {
            try! realm.write {
                realm.delete(itemToDelete)
            }
        }
    }
//    func removeFromFavorites(item: FavouriteItem) {
//        if let itemToDelete = realm.object(ofType: FavouriteItem.self, forPrimaryKey: item.currencyCode) {
//            if !itemToDelete.isInvalidated {
//                try! realm.write {
//                    if !itemToDelete.isInvalidated {
//                        realm.delete(itemToDelete)
//                    }
//                }
//            }
//        }
//    }

    func getAllFavoriteItems() -> [FavouriteItem] {
        let favoriteItems = realm.objects(FavouriteItem.self)
        return Array(favoriteItems)
    }
    func returnDataBaseURL() -> String {
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            return ("Realm database URL: \(realmURL)")
        }
        return "Couldn't Find the Database"
    }
}
