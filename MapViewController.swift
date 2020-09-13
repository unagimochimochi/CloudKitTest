//
//  MapViewController.swift
//  AccountsTest
//
//  Created by 持田侑菜 on 2020/09/08.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var id: String?
    
    var locManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locManager.delegate = self
        mapView.delegate = self
        
        // 位置情報利用の許可を得る
        locManager.requestWhenInUseAuthorization()
        // 位置情報の更新を指示
        locManager.startUpdatingLocation()

        initMap()
        
        recordLocation()
    }
    
    // 地図の初期化関数
    func initMap() {
        // 縮尺
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
        
        // ユーザーを中心に地図を表示
        mapView.userTrackingMode = .follow
    }
    
    // 位置情報更新時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        print("位置情報更新")
        
        recordLocation()
    }
    
    func recordLocation() {
        if let id = self.id {
            // デフォルトコンテナ（iCloud.com.gmail.mokamokayuuyuu.AccountsTest）にアクセス
            let myContainer = CKContainer.default()
            // パブリックデータベースにアクセス
            let publicDatabase = myContainer.publicCloudDatabase
            
            // 検索条件を作成
            let predicate = NSPredicate(format: "accountID == %@", argumentArray: [id])
            let query = CKQuery(recordType: "Accounts", predicate: predicate)
            
            // 検索したレコードの値を更新
            publicDatabase.perform(query, inZoneWith: nil, completionHandler: {(records, error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    for record in records! {
                        record["currentLocation"] = self.mapView.userLocation.location
                        publicDatabase.save(record, completionHandler: {(record, error) in
                            if let error = error {
                                print(error)
                                return
                            } else {
                                print("success!")
                            }
                        })
                    }
                }
            })
        }
    }

}
