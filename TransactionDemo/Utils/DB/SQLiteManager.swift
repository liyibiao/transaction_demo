//
//  SQLiteManager.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/25.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit
import SQLite3

class SQLiteManager: NSObject {
    public static let shared = SQLiteManager()
    
    var dbPath: String {
        guard let libraryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else {
            return ""
        }
        let pathURL = URL(fileURLWithPath: libraryPathString).appendingPathComponent("atp.sqlite")
        return pathURL.path
    }
    
    var db: OpaquePointer?
    
    let orderTableName = "Order"
    
    public override init() {
        super.init()
        db = openDatabase()
        createOrderTableIfNeeded()
    }
    
    deinit {
        closeDatabase()
    }
    
    public func openDatabase() -> OpaquePointer? {
        var _db: OpaquePointer?
        if sqlite3_open(dbPath, &_db) == SQLITE_OK {
            print("成功打开数据库，路径：\(dbPath)")
            return _db
        } else {
            print("打开数据库失败")
            return nil
        }
    }
    
    @discardableResult
    public func closeDatabase() -> Bool {
        guard let _db = db else {
            print("数据库不存在")
            return true
        }
        
        let result = sqlite3_close(_db)
        print("数据库已关闭：\(result) \(SQLITE_OK)")
        return result == SQLITE_OK
    }
    
    /// 建表
    public func createOrderTableIfNeeded() {
        let createTableString = "CREATE TABLE IF NOT EXISTS \"\(orderTableName)\" ( \"Id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"orderNo\" CHAR(255), \"createTime\" CHAR(255), \"updateTime\" CHAR(255), \"productId\" Int, \"productName\" CHAR(255), \"originalPrice\" Float, \"originalCurrency\" CHAR(255), \"realPrice\" Float, \"realCurrency\" CHAR(255) );"
        var createTableStatement: OpaquePointer?
        print(createTableString)
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("成功创建表")
            } else {
                print("未成功创建表")
            }
        }
        
        sqlite3_finalize(createTableStatement)
    }

}

// MARK: - 订单相关的操作

extension SQLiteManager {
    /// 增
    func insertMutiple(orders: [OrderEntity]) {
        guard !orders.isEmpty else { return }
        createOrderTableIfNeeded()
        
        for (_, order) in orders.enumerated() {
            let insertRowString = "INSERT INTO \"\(orderTableName)\" ( \"orderNo\", \"createTime\", \"updateTime\", \"productId\", \"productName\", \"originalPrice\", \"originalCurrency\", \"realPrice\", \"realCurrency\") VALUES (\"\(order.orderNo)\", \"\(order.createTime)\", \"\(order.updateTime)\", \(order.productId), \"\(order.productName)\", \(order.originalPrice), \"\(order.originalCurrency)\", \(order.realPrice), \"\(order.realCurrency)\");"
            var insertStatement: OpaquePointer?
            print(insertRowString)
            
            if sqlite3_prepare_v2(db, insertRowString, -1, &insertStatement, nil) == SQLITE_OK {
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("插入数据\(order.id)成功")
                } else {
                    print("插入数据\(order.id)失败")
                }
            }
            
            sqlite3_reset(insertStatement)
            sqlite3_finalize(insertStatement)
        }
    }
    
    /// 删某一条
    func delete(order: OrderEntity) {
        let deleteString = "DELETE FROM \"\(orderTableName)\" WHERE Id = \(order.id);"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("删除成功")
            }
        }
        sqlite3_finalize(deleteStatement)
    }
    
    /// 删所有
    func deleteAllOrder() {
        let deleteString = "DELETE FROM \"\(orderTableName)\";"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("删除所有订单成功")
            }
        }
        sqlite3_finalize(deleteStatement)
    }
    
    /// 改
    func update(order: OrderEntity) {
        let updateString = "UPDATE \"\(orderTableName)\" SET orderNo = \"\(order.orderNo)\", createTime = \"\(order.createTime)\", updateTime = \"\(order.updateTime)\", productId = \(order.productId), productName = \"\(order.productName)\", originalPrice = \(order.originalPrice), originalCurrency = \"\(order.originalCurrency)\", realPrice = \(order.realPrice), realCurrency = \"\(order.realCurrency)\" WHERE Id = \(order.id);"
        var updateStatement: OpaquePointer?
        print(updateString)
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("更新\(order.id)成功")
            } else {
                print("更新\(order.id)失败")
            }
        }
        sqlite3_finalize(updateStatement)
    }
    
    /// 查所有
    func queryAllOrder() -> [OrderEntity] {
        let queryString = "SELECT * FROM \"\(orderTableName)\";"
        var queryStatement: OpaquePointer?
        var orders = [OrderEntity]()

        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {

            while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                let order = OrderEntity()
                order.id = Int(sqlite3_column_int(queryStatement, 0))
                order.orderNo = String(cString: sqlite3_column_text(queryStatement, 1))
                order.createTime = String(cString: sqlite3_column_text(queryStatement, 2))
                order.updateTime = String(cString: sqlite3_column_text(queryStatement, 3))
                order.productId = Int(sqlite3_column_int(queryStatement, 4))
                order.productName = String(cString: sqlite3_column_text(queryStatement, 5))
                order.originalPrice = CGFloat(sqlite3_column_double(queryStatement, 6))
                order.originalCurrency = String(cString: sqlite3_column_text(queryStatement, 7))
                order.realPrice = CGFloat(sqlite3_column_double(queryStatement, 8))
                order.realCurrency = String(cString: sqlite3_column_text(queryStatement, 9))
                
                orders.append(order)
            }
        }
        sqlite3_finalize(queryStatement)
        
        return orders
    }
    
    /// 获取订单总数
    func queryOrderCount() -> Int {
        let queryString = "SELECT COUNT(*) FROM \"\(orderTableName)\";"
        var queryStatement: OpaquePointer?
        var count = 0
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(queryStatement, 0))
                print("查询到的数量:\(count)")
            }
            sqlite3_finalize(queryStatement)
        }
        return count
    }
}
