//
//  OrderTableViewCell.swift
//  liyibiao
//
//  Created by 李艺彪 on 2020/10/25.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    static let CellId = "OrderTableViewCellId"
    static var CellHeight: CGFloat = 100

    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    public func setup(order: OrderEntity) {
        orderNoLabel.text = "订单编号：\(order.orderNo)"
        productNameLabel.text = "商品名称：\(order.productName)"
        priceLabel.text = "花费：\(order.realPriceShowString) \(order.realCurrency)"
        timeLabel.text = "交易时间：\(order.updateTime.timestampToDateString())"
    }
    
}
