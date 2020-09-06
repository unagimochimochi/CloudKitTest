//
//  ViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/08/28.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var id: String?
    var name: String?

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idTextField.delegate = self
        nameTextField.delegate = self
        
        doneButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードをとじる
        textField.endEditing(true)
        
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // キーボードをとじる
        textField.endEditing(true)
        
        if textField == idTextField {
            id = textField.text
            print(id!)
        }
        
        if textField == nameTextField {
            name = textField.text
            print(name!)
        }
        
        // 入力されていればDoneボタンを有効にする
        if let idText = idTextField.text, !idText.isEmpty {
            if let nameText = nameTextField.text, !nameText.isEmpty {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        } else {
            doneButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == "toAccountVC" {
            let accountVC = segue.destination as! AccountViewController
            accountVC.id = self.id
            accountVC.name = self.name
        }
    }

}

