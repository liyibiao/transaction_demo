//
//  ProductDetailProductDetailProtocols.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

// MARK: - ModuleProtocol

/// OuterSide -> ProductDetail
protocol ProductDetailModuleInput: class {}

/// ProductDetail -> OuterSide
protocol ProductDetailModuleOutput: class {}

// MARK: - SceneProtocol

/// Presenter -> View
protocol ProductDetailViewInput: class {
    func didGetProductInfo()
    func didGetRate()
    func didBuySuccess()
}

/// View -> Presenter
protocol ProductDetailViewOutput {
    var product: ProductEntity { get }
    var rate: USDRateEntity? { get }
    
    /// 获取商品信息
    func getProductInfo()
    
    /// 获取当前汇率
    func getRate()
    
    /// 购买
    func buy(currency: CurrencyEnum)
    
    /// 打开交易记录页面
    func openOrderListScene()
}

/// Presenter -> Interactor
protocol ProductDetailInteractorInput {
    func doFetchExchangeRate()
}

/// Interactor -> Presenter
protocol ProductDetailInteractorOutput: class {
    func handleFetchExchageRate(resultDic: [String: Any])
    func handleNetworkError(msg: String)
}
