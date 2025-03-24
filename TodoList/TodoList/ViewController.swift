//
//  ViewController.swift
//  TodoList
//
//  Created by Yung Hak Lee on 3/20/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    
    let data = ["Pets": ["Snake", "Hamster", "Dog"], "friends": ["Mike", "Sam", "John"]]
    
    let sections = ["Pets", "friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //각 섹션마다 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sections[section]
        return data[sectionName]?.count ?? 0
    }
    
    
    //각 줄에 어떤 내용을 보여줄지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"cell")
        let sectionName = sections[indexPath.section]
        let name = data[sectionName]?[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
    
    // 섹션 헤더 제목 추가
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return sections[section]
    }
    
    // MARK: - UITableViewDelegate
    // 셀을 눌렀을 때 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(sections[indexPath.row])을/를 선택 했어요!")
    }
}

