//
//  OrderListOrderListProtocols.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

// MARK: - ModuleProtocol

/// OuterSide -> OrderList
protocol OrderListModuleInput: class {}

/// OrderList -> OuterSide
protocol OrderListModuleOutput: class {}

// MARK: - SceneProtocol

/// Presenter -> View
protocol OrderListViewInput: class {
    func didGetOrders()
    func didDeleted(in row: Int)
}

/// View -> Presenter
protocol OrderListViewOutput {
    var orders: [OrderEntity] { get }
    
    func getOrders()
    func deleteAll()
    func delete(in row: Int)
}

/// Presenter -> Interactor
protocol OrderListInteractorInput {}

/// Interactor -> Presenter
protocol OrderListInteractorOutput: class {}
