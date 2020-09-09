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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idTextField.delegate = self
        nameTextField.delegate = self
        
        fetchAllIDs()
        
        // ID入力時の判定
        idTextField.addTarget(self, action: #selector(textEditingChanged), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func unwind(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ID入力時の判定
    @objc func textEditingChanged(textField: UITextField) {
        if let text = textField.text {
            // 入力したIDがすでに存在するとき
            if accountIDs.contains("accountID-\(text)") == true {
                // 注意を表示
                idCautionLabel.isHidden = false
            }
            // 入力したIDが被っていないとき
            else {
                // 注意を非表示
                idCautionLabel.isHidden = true
            }
        }
        
        // UITextFieldが空のとき
        else {
            // 注意を非表示
            idCautionLabel.isHidden = true
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
