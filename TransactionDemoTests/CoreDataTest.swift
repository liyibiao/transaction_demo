//
//  CoreDataTest.swift
//  TransactionDemoTests
//
//  Created by 李艺彪 on 2020/10/25.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit
import XCTest
@testable import TransactionDemo

class CoreDataTest: XCTestCase {
    
    func testInset() throws {
        var orders = [OrderEntity]()
        
        for i in 1...10 {
            let order = OrderEntity()
//            order.id = 10000 + i
            order.orderNo = "000\(i)"
            order.createTime = "\(Date().timeIntervalSince1970)"
            order.updateTime = order.createTime
            order.productName = "一条鱼"
            order.productId = 1
            order.originalPrice = 30.0
            order.originalCurrency = CurrencyEnum.CNY.name
            order.realPrice = 30.0
            order.realCurrency = CurrencyEnum.CNY.name
            
            orders.append(order)
        }
        
        CoreDataManager.shared.insertMutiple(orders: orders)
    }
    
    func testQueryAllOrder() throws {
        let orders = CoreDataManager.shared.queryAllOrder()
        print("查询结果：\(orders)")
    }
    
    func testDeleteOrder() throws {
        let order = OrderEntity()
        order.id = 2
        CoreDataManager.shared.delete(order: order)
    }
    
    func testUpdateOrder() throws {
        let order = OrderEntity()
        order.id = 5
        order.orderNo = "0005"
        order.createTime = "\(Date().timeIntervalSince1970)"
        order.updateTime = order.createTime
        order.productName = "一条狗"
        order.productId = 1
        order.originalPrice = 30.0
        order.originalCurrency = CurrencyEnum.CNY.name
        order.realPrice = 30.0
        order.realCurrency = CurrencyEnum.CNY.name
        CoreDataManager.shared.update(order: order)
    }
    
    func testdeleteAllOrder() throws {
        CoreDataManager.shared.deleteAllOrder()
    }

}
