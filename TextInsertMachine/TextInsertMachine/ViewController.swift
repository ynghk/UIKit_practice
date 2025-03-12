//
//  ViewController.swift
//  TextInsertMachine
//
//  Created by Yung Hak Lee on 3/13/25.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.text = "Type whatever you like"
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 30)

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        let label = UIlabel()
    }


}

