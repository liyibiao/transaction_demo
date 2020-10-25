//
//  ProductDetailPresenter.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

import UIKit

typealias ProductDetailPresenterView = ProductDetailViewOutput
typealias ProductDetailPresenterInteractor = ProductDetailInteractorOutput

class ProductDetailPresenter {

    weak var view: ProductDetailViewInput!
    weak var transitionHandler: UIViewController!
    var interactor: ProductDetailInteractorInput!
    var outer: ProductDetailModuleOutput?
    
    private var _product = ProductEntity()
    
    var rate: USDRateEntity?
}

extension ProductDetailPresenter {

    var nav: UINavigationController? {
        return transitionHandler.navigationController
    }
}

// MARK: - ProductDetailPresenterView

extension ProductDetailPresenter: ProductDetailPresenterView {
    
    var product: ProductEntity {
        return _product
    }
    
    func getProductInfo() {        
        // 制造假数据
        _product.id = 1
        _product.name = "一条中国鱼 🐟"
        _product.price = 30.0
        _product.currency = .CNY
        
        // 更新view层
        view.didGetProductInfo()
    }
    
    func getRate() {
        interactor.doFetchExchangeRate()
    }
    
    func buy(currency: CurrencyEnum) {
        guard let _rate = rate, _rate.USDCNY > 0 else {
            return
        }
        let order = OrderEntity()
        order.orderNo = "000\(Int(Date().timeIntervalSince1970))"
        order.productName = product.name
        order.productId = product.id
        order.createTime = "\(Date().timeIntervalSince1970)"
        order.updateTime = "\(Date().timeIntervalSince1970)"
        order.originalCurrency = product.currency.name
        order.originalPrice = product.price
        order.realCurrency = currency.name
        order.realPrice = (product.currency == currency) ? product.price : CGFloat(product.price / _rate.USDCNY)
        DataManager.shared.insertMutiple(orders: [order])
        
        view.didBuySuccess()
    }
    
    func openOrderListScene() {
        let (orderListVC, _) = OrderListModuleBuilder.setupModule()
        nav?.pushViewController(orderListVC, animated: true)
    }
}

// MARK: - ProductDetailPresenterInteractor

extension ProductDetailPresenter: ProductDetailPresenterInteractor {
    
    func handleFetchExchageRate(resultDic: [String : Any]) {
        print(resultDic)
        if let quotes = resultDic["quotes"] as? [String : Any] {
            if let USD = quotes["USDUSD"] as? CGFloat, let CNY = quotes["USDCNY"] as? CGFloat {
                rate = USDRateEntity(USDUSD: USD, USDCNY: CNY)
                view.didGetRate()
            }
        }
    }
    
    func handleNetworkError(msg: String) {
        print(msg)
    }
}

// MARK: - ProductDetailModuleInput

extension ProductDetailPresenter: ProductDetailModuleInput {}
