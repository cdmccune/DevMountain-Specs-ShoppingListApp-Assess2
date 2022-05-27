//
//  ItemController.swift
//  ShoppingListApp
//
//  Created by Curt McCune on 5/27/22.
//

import Foundation

//We want this item controller to be the bridge between the item and the views. It will contain the source of truth. Log the changes into the persistent storage. House the functions to add and delete items from the list.

class ItemController {
    
    //Shared property that can always be accessed
    static var shared = ItemController()
    
    //The source of truth within the static instance
    var items = [Item]()
    
    
    //MARK: - ItemList Changing Functions
    
    func addItem (name: String) {
        let item = Item(itemName: name)
        items.append(item)
        saveToPersistentStorage()
    }
    
    func deleteItem (item: Item) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
        saveToPersistentStorage()
    }
    
    func toggleIsComplete(item: Item) {
        item.isComplete.toggle()
        saveToPersistentStorage()
    }
    
    
    //MARK: - Data Storage Functions
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "item.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    func saveToPersistentStorage() {
        let je = JSONEncoder()
        
        do {
            let data = try je.encode(items)
            try data.write(to: fileURL())
        } catch let e {print("Error encoding item: \(e)")}
    }
    
    func loadFromPersistentStorage() {
        let jd = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let items = try jd.decode([Item].self, from: data)
            self.items = items
        } catch let e {print("Error decoding data: \(e)")}
    }
}
