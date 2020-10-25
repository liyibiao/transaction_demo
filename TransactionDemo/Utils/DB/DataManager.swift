//
//  DataManager.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/20.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit


public class DataManager: NSObject {
    
    public static let shared = DataManager()
}

// MARK: - 订单相关的操作

extension DataManager {
    /// 增
    func insertMutiple(orders: [OrderEntity]) {
        CoreDataManager.shared.insertMutiple(orders: orders)
    }
    
    /// 删某一条
    func delete(order: OrderEntity) {
        CoreDataManager.shared.delete(order: order)
    }
    
    /// 删所有
    func deleteAllOrder() {
        CoreDataManager.shared.deleteAllOrder()
    }
    
    /// 改
    func update(order: OrderEntity) {
        CoreDataManager.shared.update(order: order)
    }
    
    /// 查所有
    func queryAllOrder() -> [OrderEntity] {
        return CoreDataManager.shared.queryAllOrder()
    }
    
    /// 获取订单总数
    func queryOrderCount() -> Int {
        return CoreDataManager.shared.queryOrderCount()
    }
}
