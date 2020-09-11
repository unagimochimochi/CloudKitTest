//
//  ViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/08/28.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import CloudKit

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userDefaults = UserDefaults.standard
        let firstLaunchKey = "firstLaunch"
        
        if userDefaults.bool(forKey: firstLaunchKey) {
            userDefaults.set(false, forKey: firstLaunchKey)
            userDefaults.synchronize()
            
            self.performSegue(withIdentifier: "toFirstVC", sender: nil)
        }
    }
    
    @IBAction func unwindtoVC(sender: UIStoryboardSegue) {
        if let firstVC = sender.source as? FirstViewController,
            let id = firstVC.id,
            let name = firstVC.name,
            let password = firstVC.password {
            
            let recordID = CKRecord.ID(recordName: "accountID-\(id)")
            let record = CKRecord(recordType: "Accounts", recordID: recordID)
            
            record["accountID"] = id as NSString
            record["accountName"] = name as NSString
            record["accountPassword"] = password as NSString
            
            // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）のパブリックデータベースにアクセス
            let publicDatabase = CKContainer.default().publicCloudDatabase
            
            // レコードを保存
            publicDatabase.save(record, completionHandler: {(record, error) in
                if let error = error {
                    print(error)
                    return
                }
                print("アカウント作成成功")
            })
        }
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
        
        else if identifier == "toMapVC" {
            let mapVC = segue.destination as! MapViewController
            mapVC.id = self.id
        }
    }

}

