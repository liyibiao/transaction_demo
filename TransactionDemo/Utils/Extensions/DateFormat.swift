//
//  DateFormat.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/19.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit

public extension String {
    /// 时间戳格式化为 yyyy-MM-dd 字符串
    ///
    /// - Returns: 格式化后的时间
    func timestampToDateString() -> String {
        guard let timestamp = TimeInterval(self) else {
            return ""
        }
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
