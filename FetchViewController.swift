//
//  FetchViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/09/06.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import CloudKit

class FetchViewController: UIViewController, UITextFieldDelegate {
    
    var textFieldID: String?
    
    var fetchedID: String?
    var fetchedName: String?

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textField.delegate = self
    }
    
    @IBAction func fetch(_ sender: Any) {
        if let textFieldId = textFieldID {
            fetchItem(itemID: "accountID-\(textFieldId)")
        }
    }
    
    @IBAction func display(_ sender: Any) {
        if let id = fetchedID, let name = fetchedName {
            idLabel.text = "ID: \(id)"
            nameLabel.text = "Name: \(name)"
        }
    }
    
    func fetchItem(itemID: String) {
        // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）にアクセス
        let myContainer = CKContainer.default()
        // パブリックデータベースにアクセス
        let publicDatabase = myContainer.publicCloudDatabase
        
        let recordID = CKRecord.ID(recordName: itemID)
        
        publicDatabase.fetch(withRecordID: recordID, completionHandler: fetchCompHandler(record:error:))
    }
    
    // fetch(withRecordID:completionHandler:)の第2引数
    func fetchCompHandler(record: CKRecord?, error: Error?) -> Void {
        if let id = record?.value(forKey: "accountID") as? String, let name = record?.value(forKey: "accountName") as? String {
            print("ID: \(id), Name: \(name)")
            fetchedID = id
            fetchedName = name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードをとじる
        textField.endEditing(true)
        
        textFieldID = textField.text
        
        return true
    }

}
