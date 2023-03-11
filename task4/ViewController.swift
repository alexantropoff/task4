//
//  ViewController.swift
//
//  Created by Alex Antropoff on 11.03.2023.
//

import UIKit
class ViewController: UIViewController {
    struct Item : Hashable {
        var title: String
        var isSelected: Bool
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }
    
    var tableView = UITableView(frame: .zero,style: .insetGrouped)
    
    var data = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<30 {
            let item = Item(title: "\(i)", isSelected: false)
            data.append(item)
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleButtonTapped))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func shuffleButtonTapped(_ sender: Any) {
        data.shuffle()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        if(item.isSelected){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].isSelected.toggle()
        if(data[indexPath.row].isSelected) {
            let selectedData = data[indexPath.row]
            data.remove(at: indexPath.row)
            data.insert(selectedData, at: 0)
            tableView.reloadData()
        }else{
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    }
    
}
