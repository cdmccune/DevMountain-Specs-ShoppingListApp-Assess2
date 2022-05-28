//
//  Item.swift
//  ShoppingListApp
//
//  Created by Curt McCune on 5/27/22.
//

import Foundation

class Item: Codable {
    init( withName itemName: String, id: UUID = UUID(), isComplete: Int = 0) {
        self.itemName = itemName
        self.id = id
        self.isComplete = isComplete
    }
    
    var itemName: String
    var id: UUID
    var isComplete: Int
}

extension Item: Equatable {}
    
func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.id == rhs.id
}
    

