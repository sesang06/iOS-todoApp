//
//  RestuarantDAO.swift
//  iOS-todoApp
//
//  Created by 조세상 on 03/03/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import CoreData
import Foundation
import UIKit


class RestaurantData{
  var title : String?
  var detail : String?
  var objectID : NSManagedObjectID?
  
}

class TextFileDAO{
  static let `default` : TextFileDAO = TextFileDAO()
  init(){
    
  }
  lazy var context : NSManagedObjectContext = {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if #available(iOS 10.0, *) {
      return appDelegate.persistentContainer.viewContext
    }else {
      fatalError("init(coder:) has not been implemented")
    }
  }()
  
//  func fetch(fileURL : URL? = nil) -> RestaurantData?{
//    if let url = fileURL {
//      let format = NSPredicate(format: "fileURL == %@", url.path)
//      let RestaurantDatas = self.fetch(predicate: format)
//      if let RestaurantData = RestaurantDatas.first {
//        return RestaurantData
//      }
//
//    }
//    return nil
//  }
//  func fetchRecent() -> [RestaurantData]?{
//    let sortDescriptors = [NSSortDescriptor(key: "openDate", ascending: false)]
//    return self.fetch(sortDescriptors: sortDescriptors)
//  }
  func fetch(predicate : NSPredicate? = nil, sortDescriptors : [NSSortDescriptor]? = nil) -> [RestaurantData]{
    var textFileList = [RestaurantData]()
    let fetchRequest : NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
    if let pre = predicate {
      fetchRequest.predicate = pre
    }
    fetchRequest.sortDescriptors = sortDescriptors
    //        let reg = NSSortDescriptor(key: "a", ascending : false)
    //        fetchRequest.sortDescriptors = reg
    
    do {
      let resultset = try self.context.fetch(fetchRequest)
      
      for record in resultset {
        let data = RestaurantData()
        data.detail = record.detail
        data.title = record.title
        data.objectID = record.objectID
        textFileList.append(data)
      }
    } catch let e as NSError {
      NSLog("An error has occrued : %s", e.localizedDescription)
    }
    return textFileList
  }
  
  
  
  func insert(_ data : RestaurantData){
    let object = NSEntityDescription.insertNewObject(forEntityName: "RestaurantMO", into: self.context) as! RestaurantMO
    object.title = data.title
    object.detail = data.detail
    do {
      try self.context.save()
    } catch let e as NSError {
      NSLog("An error has occrued : %s", e.localizedDescription)
    }
  }

  
  func deleteAll()-> Bool{
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantMO")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    do
    {
      try context.execute(deleteRequest)
      try context.save()
      return true
    } catch let e as NSError {
      NSLog("An error has occrued : %s", e.localizedDescription)
      return false
    }
  }
  
  func delete(_ objectID : NSManagedObjectID) -> Bool {
    let object = self.context.object(with: objectID)
    self.context.delete(object)
    
    do {
      try self.context.save()
      return true
    }catch let e as NSError {
      NSLog("An error has occrued : %s", e.localizedDescription)
      return false
    }
  }
  func update(_ data : RestaurantData){
    let object =  self.context.object(with: data.objectID!)
    object.setValue(data.title, forKey: "title")
    object.setValue(data.detail, forKey: "detail")
    do {
      try self.context.save()
    } catch let e as NSError {
      NSLog("An error has occrued : %s", e.localizedDescription)
    }
  }
}
