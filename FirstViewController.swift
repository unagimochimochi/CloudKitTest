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

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idCautionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCautionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idTextField.delegate = self
        nameTextField.delegate = self
        
        fetchAllIDs()
        
        // ID入力時の判定
        idTextField.addTarget(self, action: #selector(idTextEditingChanged), for: UIControl.Event.editingChanged)
        // パスワード入力時の判定
        pwTextField.addTarget(self, action: #selector(pwTextEditingChanged), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func unwind(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ID入力時の判定
    @objc func idTextEditingChanged(textField: UITextField) {
        if let text = textField.text {
            // 33文字以上のとき
            if text.count > 32 {
                // 注意を表示
                idCautionLabel.text = "32文字以下で入力してください"
                idCautionLabel.isHidden = false
            } else {
                // 半角英数字と"_"のみで入力されているとき
                if idTextFieldCharactersSet(textField, textField.text!) == true {
                    // 入力したIDがすでに存在するとき
                    if accountIDs.contains("accountID-\(text)") == true {
                        // 注意を表示
                        idCautionLabel.text = "そのIDはすでに登録されています"
                        idCautionLabel.isHidden = false
                    } else {
                        idCautionLabel.isHidden = true
                    }
                }
                
                // 使用できない文字が含まれているとき
                else {
                    // 注意を表示
                    idCautionLabel.text = "使用できない文字が含まれています"
                    idCautionLabel.isHidden = false
                }
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
                pwCautionLabel.isHidden = false
            }
            
            // 33文字以上のとき
            else if text.count > 32 {
                // 注意を表示
                pwCautionLabel.text = "32文字以下で入力してください"
                pwCautionLabel.isHidden = false
            }
            
            // 8〜32文字以上のとき
            else {
                // 半角英数字のみで入力されているとき
                if pwTextFieldCharactersSet(textField, textField.text!) == true {
                    // 注意を非表示
                    pwCautionLabel.isHidden = true
                } else {
                    // 注意を表示
                    pwCautionLabel.text = "使用できない文字が含まれています"
                    pwCautionLabel.isHidden = false
                }
            }
        }
    }
    
    // ID入力文字列の判定
    func idTextFieldCharactersSet(_ textField: UITextField, _ text: String) -> Bool {
        // 入力できる文字
        let characters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz_").inverted
        
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
        let characters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
        
        let components = text.components(separatedBy: characters)
        let filtered = components.joined(separator: "")
        
        if text == filtered {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードをとじる
        textField.endEditing(true)
        
        return true
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

}
