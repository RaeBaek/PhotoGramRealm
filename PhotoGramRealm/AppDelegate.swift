//
//  AppDelegate.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Realm Table의 버전을 업데이트하고 싶다면 적어줘야할 코드
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 { } // dirayPin Column 추가
            
            if oldSchemaVersion < 2 { } // diaryPin Column 삭제
            
            if oldSchemaVersion < 3 {  // dairyCentents -> diaryContents 오타 수정
                
                migration.renameProperty(onType: DiaryTable.className(), from: "dairyContents", to: "diaryContents")
            }
            
            if oldSchemaVersion < 4 { } // column 명을 수정하는 경우 3과 같이 내부를 작성하지 않으면
                                        // 수정 전 데이터가 모두 날라가게 된다. 주의 요망!
            
            if oldSchemaVersion < 5 { // diarySummary 컬럼 추가, title + contents 합쳐서 넣기
                migration.enumerateObjects(ofType: DiaryTable.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["diarySummary"] = "제목은 '\(old["diaryTitle"])'이고, 내용은 '\(old["diaryContents"])'입니다."
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

