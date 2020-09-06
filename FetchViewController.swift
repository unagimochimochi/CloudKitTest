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
        
        publicDatabase.fetch(withRecordID: recordID, completionHandler: fetchCompHandler(record:error:))
    }
    
    // fetch(withRecordID:completionHandler:)の第2引数
    func fetchCompHandler(record: CKRecord?, error: Error?) -> Void {
        if let id = record?.value(forKey: "accountID") as? String, let name = record?.value(forKey: "accountName") as? String {
            print("ID: \(id), Name: \(name)")
        }
    }

}
