//
//  ItemListTableViewCell.swift
//  ShoppingListApp
//
//  Created by Curt McCune on 5/27/22.
//

import UIKit

protocol ItemCompletionDelegate: AnyObject {
    func itemCellButtonTapped (_ sender: ItemListTableViewCell)
}

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var completedButton: UIButton!
    
    weak var delegate: ItemCompletionDelegate?
    
    var item: Item? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let item = item {
            itemLabel.text = item.itemName
            
            switch item.isComplete {
            case 1:
                completedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            case 0:
                completedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            default: print("This should never happen")
            }
        
        }
    }
    
   
    
    @IBAction func completedButtonDidClick(_ sender: Any) {
// Do we need a delegate here? Because this code below accomplishes the same thing without it.
        
//        if let item = item {
//
//            ItemController.shared.toggleIsComplete(item: item)
//
//
//            switch item.isComplete {
//            case true:
//                print("true")
//                completedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            case false:
//                completedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
//            }
//        }
        
        if let delegate = delegate {
            delegate.itemCellButtonTapped(self)
        }
    }
}
