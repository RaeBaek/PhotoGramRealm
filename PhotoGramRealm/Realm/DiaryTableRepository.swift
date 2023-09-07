//
//  DiaryTableRepository.swift
//  PhotoGramRealm
//
//  Created by 백래훈 on 2023/09/06.
//

import Foundation
import RealmSwift

protocol DiaryTableRepositoryType: AnyObject {
    func fetch() -> Results<DiaryTable>
    func fetchFilter() -> Results<DiaryTable>
    func createItem(_ item: DiaryTable)
}

class DiaryTableRepository: DiaryTableRepositoryType {
    
    let realm = try! Realm()
    
    private func a() { // -> 다른 파일에서 쓸 일 없고, 클래스 안에서만 쓸 수 있음 -> 오버라이딩 불가능 -> final 키워드를 잠재적으로 유추
        
    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<DiaryTable> {
        let data = realm.objects(DiaryTable.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        return data
    }
    
    func fetchFilter() -> Results<DiaryTable> {
        
        // realm.objects(DiaryTable.self)
        let result = fetch().where {
            // 1. 대소문자 구별 없음 - caseInsensitive
            //$0.diaryTitle.contains("제목", options: .caseInsensitive)
            
            // 2. Bool
            //$0.diaryLike == true
            
            // 3. 사진이 있는 데이터만 불러오기 (diaryPhoto의 nil 여부 판단)
            $0.diaryPhoto != nil
        }
        return result
    }
    
    func createItem(_ item: DiaryTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateItem(id: ObjectId, title: String, contents: String) {
        do {
            try realm.write {
                // 원하는 부분만 업데이트를 하고자 할 때
                // 사용하는 realm.create
                realm.create(DiaryTable.self, value: ["_id": id, "diaryTitle": title, "diaryContents": contents], update: .modified)
            }
        } catch let error {
            print("Modified Error", error)
        }
    }
}
