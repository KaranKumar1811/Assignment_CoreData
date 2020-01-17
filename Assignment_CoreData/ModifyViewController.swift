//
//  ModifyViewController.swift
//  Assignment_CoreData
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ModifyViewController: UIViewController {
    
    var contacts: [Contact]?
    var index1: Int = 0
    var fname = " ";
    var lname = " ";
    var phno = " ";
    var mail = " ";
    var id = " ";
    
    @IBOutlet weak var textFields3: UITextField!
    @IBOutlet weak var textFields2: UITextField!
    @IBOutlet weak var textFields1: UITextField!
    @IBOutlet weak var textFields0: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        textFields0.text = fname
        textFields1.text = lname
        textFields2.text = phno
        textFields3.text = mail
        
    }
    func setIndex(index: Int,data: String){
        print(data);
        id = data
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
                    
                    if (phonenumber == data)
                    {
                        print(firstname)
                        contacts?.append(Contact(firstname: firstname, lastname: lastname, email: email, phonenumber: phonenumber))
                        fname = firstname
                        lname = lastname
                        phno = phonenumber
                        mail = email
                        
                    }
                    
                    
                }
            }
        } catch  {
            print(error)
        }
        
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
    
    @IBAction func modifyPressed(_ sender: Any) {
        let firstn = textFields0.text ?? ""
        let lastn = textFields1.text ?? ""
        let phonen = textFields2.text ?? ""
        let emailn = textFields3.text ?? ""
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModel")

        fetchRequest.returnsObjectsAsFaults = false

        
        let predicate = NSPredicate(format: "phonenumber contains[c] '\(id)'")
        fetchRequest.predicate = predicate
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        loadCoreData()
        let contact = Contact(firstname: firstn, lastname: lastn, email: emailn, phonenumber: phonen)
        self.contacts?.append(contact)
        saveCoreData()
        let alert = UIAlertController(title: "Congratulations", message: "Modify Successfull", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @objc func saveCoreData() {
        clearCoreData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let contactEntityDescription = NSEntityDescription.entity(forEntityName: "ContactModel", in: managedContext)!
        for contact in contacts! {
            let contactEntity = NSManagedObject(entity: contactEntityDescription, insertInto: managedContext)
            contactEntity.setValue(contact.firstname, forKey: "firstname")
            contactEntity.setValue(contact.lastname, forKey: "lastname")
            contactEntity.setValue(contact.phonenumber, forKey: "phonenumber")
            contactEntity.setValue(contact.email, forKey: "email")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
        
        
        
    }
    
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactModel")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    
   
}
