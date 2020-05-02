
//  Created by Akanksha Thakur on 2/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import Foundation
import CoreData
import UIKit
 
func save(id: Int, quarter: String, data: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
    return
  }
    
  let managedContext = appDelegate.persistentContainer.viewContext
  let entity = NSEntityDescription.entity(forEntityName: "Records", in: managedContext)!
  let records = NSManagedObject(entity: entity, insertInto: managedContext)
    records.setValue(id, forKeyPath: "id")
    records.setValue(quarter, forKeyPath: "quarter")
    records.setValue(data, forKeyPath: "data")
  do {
    try managedContext.save()
  } catch let error as NSError {
    print("Could not save. \(error), \(error.userInfo)")
  }
}
func getRequest() -> [Records]? {
 guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
    return nil
 }
 let managedContext = appDelegate.persistentContainer.viewContext
 do {
    let record = try managedContext.fetch(Records.fetchRequest()) as [Records]
    return record
 } catch let error as NSError {
   print("Could not fetch. \(error), \(error.userInfo)")
 }
    return nil
}
func deleteRecord() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
    return
  }
    
  let managedContext = appDelegate.persistentContainer.viewContext
   do {
     let record = try managedContext.fetch(Records.fetchRequest()) as [Records]
    for rec in record {
    managedContext.delete(rec)
    }
  } catch let error as NSError {
    print("Could not fetch. \(error), \(error.userInfo)")
  }
  do {
    try managedContext.save()
  } catch let error as NSError {
    print("Could not save. \(error), \(error.userInfo)")
  }
}
