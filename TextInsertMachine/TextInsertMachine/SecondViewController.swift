//
//  SecondViewController.swift
//  TextInsertMachine
//
//  Created by Yung Hak Lee on 3/13/25.
//

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func didDismissSecondViewController(message: String)
}

class SecondViewController: UIViewController {
    weak var delegate: SecondViewControllerDelegate?
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter message"
        textField.font = .systemFont(ofSize: 24)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        print("07 SecondViewController.setupUI()")
        self.view.backgroundColor = .yellow

        let label = UILabel()
        label.text = "Second View"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        self.view.addSubview(label)

        messageTextField.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 40)
        self.view.addSubview(messageTextField)

        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 40)

        button.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
          // SecondViewController가 사라질 때 delegate에게 메시지를 전달
          self?.delegate?.didDismissSecondViewController(message: self?.messageTextField.text ?? "")
        }, for: .touchUpInside)

        self.view.addSubview(button)
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
