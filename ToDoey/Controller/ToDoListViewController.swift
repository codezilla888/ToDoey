//
//  ViewController.swift
//  ToDoey
//
//  Created by Bagrat Arutyunov on 23.11.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {
     
    var itemArray = [Item]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView Delegate Methoods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item  = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTaskTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = newTaskTextField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            newTaskTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
}

