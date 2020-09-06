//
//  FetchViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/09/06.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import CloudKit

class FetchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedButton(_ sender: Any) {
        fetchItem(itemID: "6597E33C-666C-942B-0910-2B11D402C11F")
    }
    
    func fetchItem(itemID: String) {
        // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）にアクセス
        let myContainer = CKContainer.default()
        // パブリックデータベースにアクセス
        let publicDatabase = myContainer.publicCloudDatabase
        
        let recordID = CKRecord.ID(recordName: itemID)
        
        publicDatabase.fetch(withRecordID: recordID) { (obtainedRecord, error) in
            if let accountID = obtainedRecord?.value(forKey: "accountID") as? String,
                let accountName = obtainedRecord?.value(forKey: "accountName") as? String {
                print("ID: \(accountID), Name: \(accountName)")
            }
        }
    }

}
