//
//  FavouriteItem.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 27/08/2023.
//

import Foundation
import Realm
import RealmSwift

class FavouriteItem: Object {
    @Persisted(primaryKey: true) var currencyCode: String
    @Persisted var imageUrl: String
    convenience init(currencyCode: String, imageUrl: String) {
        self.init()
        self.currencyCode = currencyCode
        self.imageUrl = imageUrl
    }
}
