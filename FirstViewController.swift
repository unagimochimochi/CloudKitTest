//
//  FirstViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/09/08.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import CloudKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    var accountIDs = [String]()
    
    var id: String?
    var name: String?
    var password: String?

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idCautionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCautionLabel: UILabel!
    
    var done = [false, false, false]
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idTextField.delegate = self
        nameTextField.delegate = self
        pwTextField.delegate = self
        
        fetchAllIDs()
        
        // ID入力時の判定
        idTextField.addTarget(self, action: #selector(idTextEditingChanged), for: UIControl.Event.editingChanged)
        // 名前入力時の判定
        nameTextField.addTarget(self, action: #selector(nameTextEditingChanged), for: UIControl.Event.editingChanged)
        // パスワード入力時の判定
        pwTextField.addTarget(self, action: #selector(pwTextEditingChanged), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func unwind(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ID入力時の判定
    @objc func idTextEditingChanged(textField: UITextField) {
        if let text = textField.text {
            // 入力されていないとき
            if text.count == 0 {
                done.remove(at: 0)
                done.insert(false, at: 0)
                doneButton.isEnabled = false
            }
                
            // 33文字以上のとき
            else if text.count > 32 {
                // 注意を表示
                idCautionLabel.text = "32文字以下で入力してください"
                noGood(label: idCautionLabel, num: 0)
            }
            
            // 1〜32文字のとき
            else {
                // 半角英数字と"_"のみで入力されているとき
                if idTextFieldCharactersSet(textField, textField.text!) == true {
                    // 入力したIDがすでに存在するとき
                    if accountIDs.contains("accountID-\(text)") == true {
                        // 注意を表示
                        idCautionLabel.text = "そのIDはすでに登録されています"
                        noGood(label: idCautionLabel, num: 0)
                    }
                    
                    // OK!
                    else {
                        idCautionLabel.isHidden = true
                        
                        done.remove(at: 0)
                        done.insert(true, at: 0)
                    }
                }
                
                // 使用できない文字が含まれているとき
                else {
                    // 注意を表示
                    idCautionLabel.text = "使用できない文字が含まれています"
                    noGood(label: idCautionLabel, num: 0)
                }
            }
        }
    }
    
    // 名前入力時の判定
    @objc func nameTextEditingChanged(textField: UITextField) {
        if let text = textField.text {
            // 入力されていないとき
            if text.count == 0 {
                done.remove(at: 1)
                done.insert(false, at: 1)
                doneButton.isEnabled = false
            }
            
            // 入力されているとき
            else {
                done.remove(at: 1)
                done.insert(true, at: 1)
            }
        }
    }
    
    // パスワード入力時の判定
    @objc func pwTextEditingChanged(textField: UITextField) {
        if let text = textField.text {
            // 8文字未満のとき
            if text.count < 8 {
                // 注意を表示
                pwCautionLabel.text = "8文字以上で入力してください"
                noGood(label: pwCautionLabel, num: 2)
            }
            
            // 33文字以上のとき
            else if text.count > 32 {
                // 注意を表示
                pwCautionLabel.text = "32文字以下で入力してください"
                noGood(label: pwCautionLabel, num: 2)
            }
            
            // 8〜32文字のとき
            else {
                // OK! 半角英数字のみで入力されているとき
                if pwTextFieldCharactersSet(textField, textField.text!) == true {
                    // 注意を非表示
                    pwCautionLabel.isHidden = true
                    
                    done.remove(at: 2)
                    done.insert(true, at: 2)
                } else {
                    // 注意を表示
                    pwCautionLabel.text = "使用できない文字が含まれています"
                    noGood(label: pwCautionLabel, num: 2)
                }
            }
        }
    }
    
    // ID入力文字列の判定
    func idTextFieldCharactersSet(_ textField: UITextField, _ text: String) -> Bool {
        // 入力できる文字
        let characters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_").inverted
        
        let components = text.components(separatedBy: characters)
        let filtered = components.joined(separator: "")
        
        if text == filtered {
            return true
        } else {
            return false
        }
    }
    
    // パスワード入力文字列の判定
    func pwTextFieldCharactersSet(_ textField: UITextField, _ text: String) -> Bool {
        // 入力できる文字
        let characters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
        
        let components = text.components(separatedBy: characters)
        let filtered = components.joined(separator: "")
        
        if text == filtered {
            return true
        } else {
            return false
        }
    }
    
    // 警告を表示 & Doneボタンを無効にする
    func noGood(label: UILabel, num: Int) {
        label.isHidden = false
        done.remove(at: num)
        done.insert(false, at: num)
        doneButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードをとじる
        textField.endEditing(true)
        
        // ID、パスワードの入力条件をクリアしていればDoneボタンを有効にする
        if done.contains(false) == false {
            doneButton.isEnabled = true
        }
        
        return true
    }
    
    // 入力中はDoneボタンを無効にする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // キーボードをとじる
        textField.endEditing(true)
        
        // ID、パスワードの入力条件をクリアしていればDoneボタンを有効にする
        if done.contains(false) == false {
            doneButton.isEnabled = true
        }
        
        if textField == idTextField {
            id = textField.text
            print(id!)
        }
        
        if textField == nameTextField {
            name = textField.text
            print(name!)
        }
        
        if textField == pwTextField {
            password = textField.text
            print(password!)
        }
    }
    
    // すでに登録されているIDを配列に格納
    func fetchAllIDs() {
        // ID一覧のRecordName
        let accountsList = "accounts-accountID"
        // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）のパブリックデータベースにアクセス
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        let recordID = CKRecord.ID(recordName: accountsList)
        
        publicDatabase.fetch(withRecordID: recordID, completionHandler: {(accountIDs, error) in
            if let error = error {
                print(error)
            }
            
            if let accountIDs = accountIDs?.value(forKey: "accounts") as? [String] {
                for accountID in accountIDs {
                    print("success!")
                    self.accountIDs.append(accountID)
                }
                print(self.accountIDs)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.doneButton else {
            return
        }
        
        id = idTextField.text!
        name = nameTextField.text!
        password = pwTextField.text!
    }

}
