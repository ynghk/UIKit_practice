//
//  ViewController.swift
//  FormDemo
//
//  Created by Yung Hak Lee on 3/17/25.
//

import UIKit

class GroupBoxViewController: UIViewController {
    
    var flag = false
    let groupBox = UIView()
    let groupBoxLabel = UILabel()
    let toggle = UISwitch()
    let textField = UITextField()
    
    var groupBoxConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupGroupBox()
        
        // 키보드 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 키보드 알림 해제
        NotificationCenter.default.removeObserver(self)
      }
    
    func setupGroupBox() {
        groupBox.layer.borderWidth = 1
        groupBox.layer.borderColor = UIColor.lightGray.cgColor
        groupBox.layer.cornerRadius = 8
        groupBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groupBox)

        groupBoxLabel.text = "그룹 박스"
        groupBoxLabel.font = .systemFont(ofSize: 20)
        groupBoxLabel.translatesAutoresizingMaskIntoConstraints = false
        groupBox.addSubview(groupBoxLabel)

        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        groupBox.addSubview(toggle)

        textField.borderStyle = .roundedRect
            textField.placeholder = "텍스트 필드"
            textField.translatesAutoresizingMaskIntoConstraints = false
            groupBox.addSubview(textField)
        
        groupBoxConstraint = groupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)

        NSLayoutConstraint.activate([
          groupBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
          groupBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
          groupBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
          groupBox.heightAnchor.constraint(equalToConstant: 200),

          groupBoxLabel.topAnchor.constraint(equalTo: groupBox.topAnchor, constant: 20),
          groupBoxLabel.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),

          toggle.topAnchor.constraint(equalTo: groupBoxLabel.bottomAnchor, constant: 10),
          toggle.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),

          textField.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 10),
          textField.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),
          textField.trailingAnchor.constraint(equalTo: groupBox.trailingAnchor, constant: -10),
          textField.bottomAnchor.constraint(equalTo: groupBox.bottomAnchor, constant: -10)
        ])
      }
    
    func moveGroupBox(forEditing: Bool) {
        groupBoxConstraint.constant = forEditing ? -100 : 100
      }

      @objc func toggleChanged() {
        flag = toggle.isOn
        print("flag: \(flag)")
          textField.resignFirstResponder()
      }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("키보드 표시")
        moveGroupBox(forEditing: true)
      }

      @objc func keyboardWillHide(_ notification: Notification) {
        print("키보드 숨김")
        moveGroupBox(forEditing: false)
      }
    }

extension GroupBoxViewController: UITextFieldDelegate {
  // 편집 가능 여부 결정
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return flag
  }

  // 텍스트 필드 편집 시작
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("편집 시작")
      moveGroupBox(forEditing: true)
  }

  // 텍스트 필드 문자 입력
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        print("실제 입력 값: \(string)")
        print("현재 텍스트 필드 값: \(currentText)")
        print("최종 업데이트 텍스트: \(updatedText)")

        return true
  }

    // 필드 편집 종료
      func textFieldDidEndEditing(_ textField: UITextField) {
        print("편집 종료")
        moveGroupBox(forEditing: false)
      }
    }

#Preview {
  GroupBoxViewController()
}
