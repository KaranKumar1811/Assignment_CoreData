//
//  ViewController.swift
//  Assignment_CoreData
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController {
    var contacts: [Contact]?

    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        
        self.loadCoreData()
    }

    @IBAction func savePressed(_ sender: UIButton) {
        let firstname = textFields[0].text ?? ""
        let lastname = textFields[1].text ?? ""
        let phonenumber = textFields[2].text ?? ""
        let email = textFields[3].text ?? ""
        
        let contact = Contact(firstname: firstname, lastname: lastname, email: email, phonenumber: phonenumber)
        self.contacts?.append(contact)
        saveCoreData()
        let alert = UIAlertController(title: "Congratulations", message: "Save Successfull", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
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
        
        for textField in textFields {
            textField.text = ""
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

