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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("number of rows \(ItemController.shared.items[section].count) in section \(section)")
        return ItemController.shared.items[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 15, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = .lightGray
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width-15, height: 40))
        
        if section == 0 {
            lbl.text = "Not Purchased"
        } else {
            lbl.text = "Purchased"
        }
        
        view.addSubview(lbl)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemListTableViewCell else {return UITableViewCell()}
        print(ItemController.shared.items[indexPath.section][indexPath.row].isComplete)
        
        cell.item = ItemController.shared.items[indexPath.section][indexPath.row]
        cell.delegate = self
        return cell
       
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = ItemController.shared.items[indexPath.section][indexPath.row]
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




extension ItemListTableViewController: ItemCompletionDelegate {
    func itemCellButtonTapped(_ sender: ItemListTableViewCell) {
        
        //Completes the toggle function on the item
        //Defines the old and new index paths
        //Deletes the items from one "section" array in item controller and appends them
        //Moves the cell over to the other section
        
        guard let item = sender.item else {return}
        
        
        //All of the row manipulation
        
        guard let oldRow = ItemController.shared.items[item.isComplete].firstIndex(of: item) else {
            return
        }
        let oldIsComplete = item.isComplete
        let newIsComplete: Int
        
        if oldIsComplete == 1 {
            newIsComplete = 0
        } else {
            newIsComplete = 1
        }
        
        let oldIndex = IndexPath(row: oldRow , section: oldIsComplete)
        
        let newRow = ItemController.shared.items[newIsComplete].count
        let newIndex = IndexPath(row: newRow, section: newIsComplete)


        tableView.beginUpdates()
        ItemController.shared.items[oldIsComplete].remove(at: oldRow)
        ItemController.shared.items[newIsComplete].append(item)
        tableView.moveRow(at: oldIndex, to: newIndex)
        tableView.endUpdates()

        
        //Calling the function to toggle the value
        
        ItemController.shared.toggleIsComplete(item: item)
        sender.updateViews()
        
    }
    
    
}
