//
//  ContactTableViewController.swift
//  Assignment_CoreData
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//

import UIKit
import CoreData
class ContactTableViewController: UITableViewController {
       var contacts: [Contact]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCoreData()

    }

    func loadCoreData() {
        contacts = [Contact]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModel")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject]{
                for result in (results as! [NSManagedObject]) {
                    let firstname = result.value(forKey: "firstname") as! String
                    let lastname = result.value(forKey: "lastname") as! String
                    let phonenumber = result.value(forKey: "phonenumber") as! String
                    
                    let email = result.value(forKey: "email") as! String
                    
                    contacts?.append(Contact(firstname: firstname, lastname: lastname, email: email, phonenumber: phonenumber))
                }
            }
        } catch  {
            print(error)
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadCoreData()
        tableView.reloadData()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contacts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = self.contacts![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        cell.textLabel?.text = contact.firstname + " " + contact.lastname
        cell.detailTextLabel?.text = "\(contact.phonenumber)  - \(contact.email)"
        // Configure the cell...

        return cell
        
    }
    func deleteCoreData(index: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModel")
        requestDel.returnsObjectsAsFaults = false
        do {
            let arr = try managedContext.fetch(requestDel)
            let obj = arr as! [NSManagedObject]
            managedContext.delete(obj[index])
        } catch  {
            print(error)
        }
        do {
            try managedContext.save()
           
        } catch  {
            print(error)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if let controller = segue.destination as? ModifyViewController
                {
                    let contactIndexPath = self.tableView.indexPath(for: (sender as! UITableViewCell))!
                    let object = contacts![contactIndexPath.row]
                    controller.setIndex(index: contactIndexPath.row ,data: object.phonenumber)
                    
                
            }
        
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            deleteCoreData(index: indexPath.row)
        }
    
        
    
        }
    

 


}
