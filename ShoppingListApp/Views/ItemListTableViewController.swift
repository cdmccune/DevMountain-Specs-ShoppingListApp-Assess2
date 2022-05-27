//
//  ItemListTableViewController.swift
//  ShoppingListApp
//
//  Created by Curt McCune on 5/27/22.
//

import UIKit

class ItemListTableViewController: UITableViewController {

    
    //MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.shared.loadFromPersistentStorage()
    }

    //MARK: - Button Functionality
    
    @IBAction func addButtonDidClick(_ sender: Any) {
        
        
        
        let addAlertController = UIAlertController(title: "Add Shopping Item", message: "Please enter the item you wish to add", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            let textField = addAlertController.textFields![0]
            ItemController.shared.addItem(name: textField.text!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addAlertController.addTextField {textField in
            textField.placeholder = "Your item..."
        }
        [addAction, cancelAction].forEach({addAlertController.addAction($0)})
        self.present(addAlertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source & editing

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ItemController.shared.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemListTableViewCell else {return UITableViewCell()}
        
        cell.item = ItemController.shared.items[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = ItemController.shared.items[indexPath.row]
            ItemController.shared.deleteItem(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//Inside of this delegate extension, we want to build out the functionality we want to happen when the button is tapped, only then will the tableviewcontroller truly act as a delegate.

extension ItemListTableViewController: ItemCompletionDelegate {
    func itemCellButtonTapped(_ sender: ItemListTableViewCell) {
        guard let item = sender.item else {return}
        ItemController.shared.toggleIsComplete(item: item)
        sender.updateViews()
    }
    
    
}
