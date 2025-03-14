//
//  ViewController.swift
//  UIViewDemoPractice
//
//  Created by Yung Hak Lee on 3/13/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupStackView()
        
        setupButton()
        //
        setupSwitch()
        //
        setupStepper()
        //
        setupSlider()
    }
    
    func setupStackView() {
        let label1 = UILabel()
        label1.text = "Label 1"
        label1.backgroundColor = .systemBlue
        
        let label2 = UILabel()
        label2.text = "Label 2"
        label2.backgroundColor = .systemYellow
        
        let label3 = UILabel()
        label3.text = "Label 3"
        label3.backgroundColor = .systemGreen
        
        let stackView = UIStackView(arrangedSubviews: [label1, label2, label3])
        stackView.axis = .vertical
        stackView.backgroundColor = .darkGray
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    //MARK: - 버튼 생성
    func setupButton() {
        let button = UIButton(type: .system)
        button.setTitle( "Button", for: .normal)
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - 스위치 생성
    // (스위치와 레이블을 수평 스택 뷰에 추가)
    func setupSwitch() {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Switch"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [label, switchControl])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    func setupStepper() {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            stepper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupSlider() {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400),
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
}

#Preview {
    ViewController()
}

