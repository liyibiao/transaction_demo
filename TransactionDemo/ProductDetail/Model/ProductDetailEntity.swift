//
//  ProductDetailEntity.swift
//  TransactionDemo
//
//  Created by user on 2020/10/19.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Entity

class ProductDetailEntity {}

// 商品
class ProductEntity {
    /// 商品Id
    var id: Int = 0
    /// 商品名称
    var name: String = ""
    /// 价格
    var price: CGFloat = 0
    /// 币种
    var currency: CurrencyEnum = .CNY
    
}

// 货币类型
public enum CurrencyEnum: Int {
    /// 人民币
    case CNY
    /// 美元
    case USD
    
    public var name: String {
        switch self {
        case .CNY:
            return "CNY"
        case .USD:
            return "USD"
        }
    }
    
    
}

/// 汇率
struct USDRateEntity {
    /// 美元汇率
    var USDUSD: CGFloat
    /// 人民币汇率
    var USDCNY: CGFloat
    
}
