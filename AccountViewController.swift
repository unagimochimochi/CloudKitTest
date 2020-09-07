//
//  AccountViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/08/28.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import CloudKit

class AccountViewController: UIViewController {
    
    var id: String?
    var name: String?

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let id = self.id, let name = self.name {
            print("ID: \(id), Name: \(name)")
            
            let recordID = CKRecord.ID(recordName: "accountID-\(id)")
            let record = CKRecord(recordType: "Accounts", recordID: recordID)
            
            record["accountID"] = id as NSString
            record["accountName"] = name as NSString
            
            // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）にアクセス
            let myContainer = CKContainer.default()
            // パブリックデータベースにアクセス
            let publicDatabase = myContainer.publicCloudDatabase
            
            // レコードを保存
            publicDatabase.save(record) {
                (record, error) in
                if let error = error {
                    // Insert error handling
                    print(error)
                    return
                }
                // Insert successfully saved record code
                print("success!")
            }
        }
    }
    
}
