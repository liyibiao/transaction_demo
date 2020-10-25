//
//  ProductDetailProductDetailInteractor.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//


// MARK: - Interactor

class ProductDetailInteractor {

    weak var output: ProductDetailInteractorOutput?
}

extension ProductDetailInteractor: ProductDetailInteractorInput {
    func doFetchExchangeRate() {
        var params = [String: Any]()
        params["currencies"] = "USD,AUD,CAD,PLN,MXN,CNY"
        params["format"] = "1"
        HttpManager.shared.request_get(urlString: API.live.url, params: params, success: {[weak self] res in
            self?.output?.handleFetchExchageRate(resultDic: res)
        }, failure: { [weak self] msg in
            self?.output?.handleNetworkError(msg: msg)
        })
    }
}
