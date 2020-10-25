//
//  ProductDetailViewController.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var output: ProductDetailViewOutput!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!

    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        
        output.getProductInfo()
        output.getRate()
    }
}

// MARK: - Assistant

extension ProductDetailViewController {

    func setupNavItems() {
        self.navigationItem.title = "商品详情"
        
        let rightBarItem = UIBarButtonItem(title: "订单记录", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onClickRightBarItem))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
}

// MARK: - show alert

extension ProductDetailViewController {
    func showActionSheet() {
        guard let _rate = output.rate, _rate.USDCNY > 0 else {
            return
        }
        let alert = UIAlertController(title: "确认花费的金额", message: "点击直接购买", preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionForCNY = UIAlertAction(title: "\(output.product.price) CNY", style: UIAlertAction.Style.default) {[weak self] (_) in
            print("CNY")
            self?.output.buy(currency: .CNY)
        }
        
        let actionForUSD = UIAlertAction(title: String(format: "%.2f USD", output.product.price / _rate.USDCNY), style: UIAlertAction.Style.default) {[weak self] (_) in
            print("USD")
            self?.output.buy(currency: .USD)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (_) in
            
        }
        alert.addAction(actionForCNY)
        alert.addAction(actionForUSD)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getRateAlert() {
        let alert = UIAlertController(title: "提示", message: "暂未获取汇率，请重试", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "重试", style: .default, handler: {[weak self] (_) in
            self?.output.getRate()
        }))
    }
}

// MARK: - Delegate

extension ProductDetailViewController {}

// MARK: - Selector

@objc extension ProductDetailViewController {
    @IBAction func onClickBuy(_ sender: UIButton) {
        if output.rate == nil {
            getRateAlert()
        } else {
            showActionSheet()
        }
    }
    
    func onClickRightBarItem() {
        output.openOrderListScene()
    }
}

// MARK: - ProductDetailViewInput

extension ProductDetailViewController: ProductDetailViewInput {
    func didGetProductInfo() {
        productNameLabel.text = "商品名称：" + output.product.name
        productPriceLabel.text = "商品价格：" + "\(output.product.price) \(output.product.currency.name)"
    }
    
    func didGetRate() {
        guard let _rate = output.rate else {
            return
        }
        
        rateLabel.text = "今日汇率：\n\(_rate.USDUSD) USD = \(_rate.USDCNY) CNY"
    }
    
    func didBuySuccess() {
        let alert = UIAlertController(title: "购买成功", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ProductDetailModuleBuilder

class ProductDetailModuleBuilder {

    class func setupModule(handler: ProductDetailModuleOutput? = nil) -> (UIViewController, ProductDetailModuleInput) {
        let viewController = ProductDetailViewController()
        
        let presenter = ProductDetailPresenter()
        presenter.view = viewController
        presenter.transitionHandler = viewController
        presenter.outer = handler
        viewController.output = presenter
       
        let interactor = ProductDetailInteractor()
        interactor.output = presenter
        presenter.interactor = interactor
        
        let input = presenter
        
        return (viewController, input)
    }
}

