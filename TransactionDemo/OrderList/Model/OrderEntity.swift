//
//  OrderEntity.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/19.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Entity

// 订单
public class OrderEntity: NSObject {
    public var id: Int = 0
    /// 订单编号
    public var orderNo: String = ""
    /// 创建时间（时间戳 秒）
    public var createTime: String = ""
    /// 更新时间（时间戳 秒）
    public var updateTime: String = ""
    /// 产品ID
    public var productId: Int = 0
    /// 产品名称
    public var productName: String = ""
    /// 原始价格
    public var originalPrice: CGFloat = 0
    /// 原始货币
    public var originalCurrency: String = ""
    /// 实际价格
    public var realPrice: CGFloat = 0
    /// 实际货币
    public var realCurrency: String = ""

    public override var description: String {
        return "OrderEntity(id=\(id) orderNo=\(orderNo) productName=\(productName))"
    }
}

extension OrderEntity {
    /// UI上显示的价格
    var realPriceShowString: String {
        return String(format: "%.2f", realPrice)
    }
}
