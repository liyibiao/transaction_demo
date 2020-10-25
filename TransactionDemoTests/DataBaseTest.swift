//
//  DataBaseTest.swift
//  TransactionDemoTests
//
//  Created by 李艺彪 on 2020/10/20.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit
import XCTest
@testable import TransactionDemo

class DataBaseTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInset() throws {
        var orders = [OrderEntity]()
        
        for i in 1...10 {
            let order = OrderEntity()
            order.id = 10000 + i
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
        
        SQLiteManager.shared.insertMutiple(orders: orders)
    }
    
    func testQueryAllOrder() throws {
        let orders = DataManager.shared.queryAllOrder()
        print(orders)
    }
    
    func testQueryOrderCount() throws {
        let count = DataManager.shared.queryOrderCount()
        XCTAssertTrue(count > 0)
    }
    
    func testDeleteOrder() throws {
        let order = OrderEntity()
        order.id = 2
        SQLiteManager.shared.delete(order: order)
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
        SQLiteManager.shared.update(order: order)
    }
    
    func testdeleteAllOrder() throws {
        SQLiteManager.shared.deleteAllOrder()
    }
    
    func testCloseDatabase() throws {
        let result = SQLiteManager.shared.closeDatabase()
        XCTAssertTrue(result)
    }
    
}
