//
//  ViewController.swift
//  HelloWorld
//
//  Created by Yung Hak Lee on 3/12/25.
//

import UIKit

class ViewController: UIViewController, SecondViewControllerDelegate {
    
    // lazy var: 초기화를 늦게 하기 위해 사용하는 키워드
    lazy var myLabel: UILabel = {
        print("myLabel 생성")
        let label = UILabel()
        label.text = "입력 결과를 출력합니다."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("1 ViewController.viewDidLoad()")
        setupUI()
    }
    
    
    func setupUI() {
        let label = UILabel()
        label.text = "Hello, World!"
        // (content layout) 라벨의 텍스트를 가운데 정렬
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        
        // x: 20 = 화면 왼쪽에서 20포인트 떨어진 곳에서 시작 y: 100 = 화면 위쪽에서 100포인트 아래, width: view.frame.width - 40 = 화면 너비에서 양쪽 20포인트씩을 남김(총 40포인트 뺌). height: 40 = 높이 40포인트
        label.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100)
        // self.view(메인 뷰)에 라벨을 서브 뷰로 추가
        self.view.addSubview(label)
        
        // 버튼 추가
        
        let button = UIButton()
        button.setTitle("Go Second", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 40)
        button.addTarget(self, action: #selector(goSecond), for: .touchUpInside)
        self.view.addSubview(button)
        
        myLabel.frame = CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 40)
        self.view.addSubview(myLabel)
    }
    
    func didDismissSecondViewController(message: String) {
          myLabel.text = message
      }
        

      @objc func goSecond() {
        let secondVC = SecondViewController()
        secondVC.delegate = self
        self.present(secondVC, animated: true)
      }
}

