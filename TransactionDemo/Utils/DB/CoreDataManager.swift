//
//  CoreDataManager.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/25.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit
import CoreData

fileprivate let kEntityName: String = "OrderRecord"

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ATPCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: - 订单相关的操作

extension CoreDataManager {
    /// 增
    func insertMutiple(orders: [OrderEntity]) {
        guard !orders.isEmpty else { return }
        
        // 当前最大id
        let maxId = queryAllOrder().map({ $0.id} ).max() ?? 1
        
        for (i, entity) in orders.enumerated() {
            if let record = NSEntityDescription.insertNewObject(forEntityName: kEntityName, into: context) as? OrderRecord {
                record.config(entity: entity)
                if entity.id <= 0 {
                    // id自增
                    let newId: Int = maxId + i + 1
                    record.id = Int64(newId)
                }
                saveContext()
                print("保存成功：\(record.id)")
            }
        }
    }
    
    /// 删某一条
    func delete(order: OrderEntity) {
        let fetchRequest: NSFetchRequest = OrderRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", order.id)
        
        guard let fetchResult = try? context.fetch(fetchRequest) else {
            return
        }
        
        for order in fetchResult {
            context.delete(order)
            print("删除：\(order.id)")
        }
        saveContext()
    }
    
    /// 删除所有
    func deleteAllOrder() {
        let fetchRequest: NSFetchRequest = OrderRecord.fetchRequest()
        
        guard let fetchResult = try? context.fetch(fetchRequest) else {
            return
        }
        
        for record in fetchResult {
            context.delete(record)
        }
        
        saveContext()
    }
    
    /// 改
    func update(order: OrderEntity) {
        let fetchRequest: NSFetchRequest = OrderRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", order.id)
        guard let fetchResult = try? context.fetch(fetchRequest) else {
            return
        }
        
        for record in fetchResult {
            record.config(entity: order)
            print("修改：\(order.id)")
        }
        saveContext()
    }
    
    /// 查询所有
    func queryAllOrder() -> [OrderEntity] {
        var entities = [OrderEntity]()
        let fetchRequest: NSFetchRequest = OrderRecord.fetchRequest()
        
        guard let records = try? context.fetch(fetchRequest) else {
            return entities
        }
        
        for record in records {
            let entity = OrderEntity()
            entity.config(record: record)
            entities.append(entity)
        }
        
        return entities
    }
    
    /// 获取订单总数
    func queryOrderCount() -> Int {
        let fetchRequest: NSFetchRequest = OrderRecord.fetchRequest()
        
        guard let records = try? context.fetch(fetchRequest) else {
            return 0
        }
        
        return records.count
    }
}

// MARK: - 模型转换

extension OrderRecord {
    func config(entity: OrderEntity) {
        self.id = Int64(entity.id)
        self.orderNo = entity.orderNo
        self.createTime = entity.createTime
        self.updateTime = entity.updateTime
        self.productId = Int64(entity.productId)
        self.productName = entity.productName
        self.originalCurrency = entity.originalCurrency
        self.originalPrice = Float(entity.originalPrice)
        self.realCurrency = entity.realCurrency
        self.realPrice = Float(entity.realPrice)
    }
}

extension OrderEntity {
    func config(record: OrderRecord) {
        self.id = Int(record.id)
        self.orderNo = record.orderNo ?? ""
        self.createTime = record.createTime ?? ""
        self.updateTime = record.updateTime ?? ""
        self.productId = Int(record.productId)
        self.productName = record.productName ?? ""
        self.originalCurrency = record.originalCurrency ?? ""
        self.originalPrice = CGFloat(record.originalPrice)
        self.realCurrency = record.realCurrency ?? ""
        self.realPrice = CGFloat(record.realPrice)
    }
}
