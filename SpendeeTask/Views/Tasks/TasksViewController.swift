//
//  TasksViewController.swift
//  SpendeeTask
//
//  Created by Daniel Fernandez on 10/21/19.
//  Copyright © 2019 danielfcodes. All rights reserved.
//

import UIKit
import SnapKit

class TasksViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        view.backgroundColor = .white
        title = "Tasks"
        setupTableView()
        addBarButtons()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    private func addBarButtons() {
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskPressed))
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showSettingsPressed))
        navigationItem.rightBarButtonItems = [addTaskButton, settingsButton]
    }
    
    @objc
    private func addTaskPressed() {
        let addTaskViewModel = AddTaskViewModel()
        let addTaskViewController = AddTaskViewController(viewModel: addTaskViewModel)
        navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    @objc
    private func showSettingsPressed() {
        let settingsViewController = SettingsViewController()
        let navigationController = CustomNavigationController(rootViewController: settingsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func showDetailTask(indexPath: IndexPath) {
        let detailViewModel = DetailTaskViewModel(task: Task(name: "", expirationDate: "", category: Category(name: "", color: "#FFFFFF")))
        let detailTaskViewController = DetailTaskViewController(withViewModel: detailViewModel)
        navigationController?.pushViewController(detailTaskViewController, animated: true)
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailTask(indexPath: indexPath)
    }
    
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        return cell
    }
    
}
