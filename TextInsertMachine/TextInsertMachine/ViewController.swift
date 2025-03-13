//
//  ViewController.swift
//  TextInsertMachine
//
//  Created by Yung Hak Lee on 3/13/25.
//

import UIKit

class ViewController: UIViewController, SecondViewControllerDelegate {
    
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.text = "Inserted Text"
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        let label = UILabel()
        label.text = "Type Whatever You Like"
        label.textColor = .cyan
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.frame = CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 50)
        
        self.view.addSubview(label)
        
        let button = UIButton()
        button.setTitle( "Submit", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 50)
        button.addTarget(self, action: #selector(goSecond), for: .touchUpInside)
        
        self.view.addSubview(button)
    
        
        myLabel.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 50)
        self.view.addSubview(myLabel)
    }
    
    func didDismissSecondViewController(message: String) {
        myLabel.text = message
        }
    
    @objc func goSecond() {
        let secondVC = SecondViewController()
        secondVC.delegate = self
        self.navigationController?.pushViewController(secondVC, animated: true)
        }
}

