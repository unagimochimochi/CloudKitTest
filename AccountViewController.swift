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
    
    var recordIDs = [CKRecord.ID]()
    
    var id: String?
    var name: String?

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let id = self.id, let name = self.name {
            print("ID: \(id), Name: \(name)")
            
            let accountRecordID = CKRecord.ID(recordName: "\(id)")
            let accountRecord = CKRecord(recordType: "\(id)", recordID: accountRecordID)
            
            recordIDs.append(accountRecordID)
            
            accountRecord["id"] = id /*as NSString*/
            accountRecord["name"] = name /*as NSString*/
            
            // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）にアクセス
            let myContainer = CKContainer.default()
            // パブリックデータベースにアクセス
            let publicDatabase = myContainer.publicCloudDatabase
            
            // レコードを保存
            publicDatabase.save(accountRecord) {
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
    
    @IBAction func tappedButton(_ sender: Any) {
        let fetchRecordsOperaton = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        // レコードごとにfetchが完了したときに実行する処理の設定
        fetchRecordsOperaton.perRecordCompletionBlock = perRecordCompBlock(record:recordID:error:)
        // 全操作完了時に実行する処理の設定
        fetchRecordsOperaton.fetchRecordsCompletionBlock = fetchRecordsCompBlock(recordsAndIDs:error:)
        
        // デフォルトコンテナにアクセス
        let myContainer = CKContainer.default()
        // パブリックデータベースにアクセス
        let publicDatabase = myContainer.publicCloudDatabase
        
        // データベースの指定
        fetchRecordsOperaton.database = publicDatabase
        // 実行
        fetchRecordsOperaton.start()
    }
    
    func perRecordCompBlock(record: CKRecord?, recordID: CKRecord.ID?, error: Error?) -> Void {
        if let error = error {
            print(error)
            return
        }
        
        if let record = record {
            print("success! RecordID: \(record.recordID)")
        }
    }
    
    func fetchRecordsCompBlock(recordsAndIDs: [CKRecord.ID: CKRecord]?, error: Error?) -> Void {
        if let error = error {
            print(error)
            return
        }
        
        if let recordsAndIDs = recordsAndIDs {
            print("success! There are \(recordsAndIDs.count) records.")
        }
    }
    
}
