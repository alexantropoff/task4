//
//  ViewController.swift
//
//  Created by Alex Antropoff on 11.03.2023.
//

import UIKit
class ViewController: UIViewController {
    class Item : Hashable {
        let id = UUID()
        var title: String
        var isSelected: Bool
        init(title: String, isSelected: Bool){
            self.title = title
            self.isSelected = isSelected
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
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
    lazy var datasource : UITableViewDiffableDataSource<Int,Item> =
    UITableViewDiffableDataSource(tableView: self.tableView) {
        tv,ip,item in
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
        cell.textLabel!.text = self.data[ip.row].title
        cell.accessoryType = self.data[ip.row].isSelected ? .checkmark: .none
        // print("\(self.data[ip.row].title) \(self.data[ip.row].isSelected)")
        return cell
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleButtonTapped))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        makeSnapshot()
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func makeSnapshot(){
        var snap = NSDiffableDataSourceSnapshot<Int,Item>()
        snap.appendSections([0])
        snap.appendItems(data)
        self.datasource.apply(snap, animatingDifferences: true)
        
    }
    @objc func shuffleButtonTapped(_ sender: Any) {
        data.shuffle()
        makeSnapshot()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        data[indexPath.row].isSelected.toggle()
        var snap = datasource.snapshot()
        snap.reloadItems([data[indexPath.row]])
        if(data[indexPath.row].isSelected) {
            if(indexPath.row != 0){
                snap.moveItem(data[indexPath.row], beforeItem: data[0])
                datasource.apply(snap, animatingDifferences: true)
                let selectedData = data[indexPath.row]
                data.remove(at: indexPath.row)
                data.insert(selectedData, at: 0)
            }
            
        }
        datasource.apply(snap, animatingDifferences: true)
    }
    
}
