//
//  HttpManager.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/18.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import Foundation

public enum API {
    case live
    case historical
    
    var url: String {
        switch self {
        case .live:
            return "http://api.currencylayer.com/live"
        case .historical:
            return "http://api.currencylayer.com/historical"
        }
    }
}

fileprivate let access_key = "292f6423073add4d105048295703d78e"

typealias SuccessResponse = (([String: Any]) -> Void)
typealias FailureResponse = ((String) -> Void)

public class HttpManager: NSObject {
    public static let shared = HttpManager()
    
    /// GET请求
    func request_get(urlString: String, params: [String: Any]?, success: @escaping SuccessResponse, failure: FailureResponse? = nil) {

        var mergedParams: [String: Any] = ["access_key": access_key]
        
        if let _params = params {
            mergedParams.merge(_params) { (current, _) in current }
        }
        let paramString = mergedParams.compactMap({ "\($0.key)=\($0.value)" }).joined(separator: "&")
        
        guard let url = URL(string: "\(urlString)?\(paramString)") else {
            return
        }
  
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let _data = data, let _response = response else {
                DispatchQueue.main.async {
                    failure?("请求失败")
                }
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: _data, options: .allowFragments) as? [String: Any] {
                DispatchQueue.main.async {
                    success(json)
                }
            } else {
                DispatchQueue.main.async {
                    failure?("解析失败")
                }
            }
        })
        
        task.resume()
    }
}
