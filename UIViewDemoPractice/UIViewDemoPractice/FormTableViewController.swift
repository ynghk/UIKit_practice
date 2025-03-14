//
//  FormTableViewController.swift
//  UIViewDemoPractice
//
//  Created by Yung Hak Lee on 3/13/25.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = .black
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        var config = UIListContentConfiguration.subtitleCell()
        config.text = "Section: \(indexPath.section), Row \(indexPath.row)"
        cell.contentConfiguration = config
        
        cell.backgroundColor = .systemBlue
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 20
        case 2:
            return 50
        case 3:
            return 80
        case 4:
            return 150
        default:
            return 0
        }
    }
}

#Preview {
    FormTableViewController()
}
