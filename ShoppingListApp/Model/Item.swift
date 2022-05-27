//
//  Item.swift
//  ShoppingListApp
//
//  Created by Curt McCune on 5/27/22.
//

import Foundation

class Item: Codable {
    init( withName itemName: String, id: UUID = UUID()) {
        self.itemName = itemName
        self.id = id
    }
    
    var itemName: String
    var id: UUID
    var isComplete = false
}

extension Item: Equatable {}
    
func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.id == rhs.id
}
    

