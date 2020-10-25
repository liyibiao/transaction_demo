//
//  OrderListViewController.swift
//  generambaMake
//
//  Created by liyibiao on 19/10/2020.
//  Copyright © 2020 ATP. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {

    var output: OrderListViewOutput!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: OrderTableViewCell.CellId)
        return tableView
    }()

    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItems()
        setupSubViews()
        
        output.getOrders()
    }
}

// MARK: - Assistant

extension OrderListViewController {

    func setupNavItems() {
        self.navigationItem.title = "订单记录"
        
        let rightBarItem = UIBarButtonItem(title: "清空记录", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onClickRightBarItem))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setupSubViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
}

// MARK: - Network

extension OrderListViewController {}

// MARK: - Delegate

extension OrderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.CellId, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(order: output.orders[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension OrderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderTableViewCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "提示", message: "确定删除订单？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (_) in
            self?.output.delete(in: indexPath.row)
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Selector

@objc extension OrderListViewController {

    func onClickRightBarItem() {
        let alert = UIAlertController(title: "提示", message: "确定清空记录？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (_) in
            self?.output.deleteAll()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func onRecvOrderListNoti(_ noti: Notification) {}
}

// MARK: - OrderListViewInput 

extension OrderListViewController: OrderListViewInput {
    func didGetOrders() {
        tableView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = !output.orders.isEmpty
    }
    
    func didDeleted(in row: Int) {
        navigationItem.rightBarButtonItem?.isEnabled = !output.orders.isEmpty
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .left)
    }
}

// MARK: - OrderListModuleBuilder

class OrderListModuleBuilder {

    class func setupModule(handler: OrderListModuleOutput? = nil) -> (UIViewController, OrderListModuleInput) {
        let viewController = OrderListViewController()
        
        let presenter = OrderListPresenter()
        presenter.view = viewController
        presenter.transitionHandler = viewController
        presenter.outer = handler
        viewController.output = presenter
       
        let interactor = OrderListInteractor()
        interactor.output = presenter
        presenter.interactor = interactor
        
        let input = presenter
        
        return (viewController, input)
    }
}
