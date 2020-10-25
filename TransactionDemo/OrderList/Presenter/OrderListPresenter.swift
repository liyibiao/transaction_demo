//
//  OrderListPresenter.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

import UIKit

typealias OrderListPresenterView = OrderListViewOutput
typealias OrderListPresenterInteractor = OrderListInteractorOutput

class OrderListPresenter {

    weak var view: OrderListViewInput!
    weak var transitionHandler: UIViewController!
    var interactor: OrderListInteractorInput!
    var outer: OrderListModuleOutput?
    
    var orders = [OrderEntity]()
}

extension OrderListPresenter {

    var nav: UINavigationController? {
        return transitionHandler.navigationController
    }
}

// MARK: - OrderListPresenterView

extension OrderListPresenter: OrderListPresenterView {
    
    func getOrders() {
        orders = DataManager.shared.queryAllOrder()
        
        view.didGetOrders()
    }
    
    func deleteAll() {
        DataManager.shared.deleteAllOrder()
        getOrders()
    }
    
    func delete(in row: Int) {
        guard row < orders.count else {
            return
        }
        
        let order = orders[row]
        DataManager.shared.delete(order: order)
        orders.remove(at: row)
        view.didDeleted(in: row)
    }
}

// MARK: - OrderListPresenterInteractor

extension OrderListPresenter: OrderListPresenterInteractor {}

// MARK: - OrderListModuleInput

extension OrderListPresenter: OrderListModuleInput {}
