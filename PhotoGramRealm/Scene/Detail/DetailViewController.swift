//
//  DetailViewController.swift
//  PhotoGramRealm
//
//  Created by 백래훈 on 2023/09/05.
//

import UIKit
import SnapKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    let realm = try! Realm()
    
    var data: DiaryTable?
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력해주세요"
        return view
    }()
    
    let contentTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "내용을 입력해주세요"
        return view
    }()
    
    let repository = DiaryTableRepository()
    
    override func configure() {
        super.configure()
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        
        guard let data = data else { return }
        
        titleTextField.text = data.diaryTitle
        contentTextField.text = data.diaryContents
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editButtonClicked))
    }
    
    @objc func editButtonClicked() {
        
        //Realm Update
        guard let data = data else { return }
        guard let titleText = titleTextField.text else { return }
        guard let contentText = contentTextField.text else { return }
        //let item = DiaryTable(value: ["_id": data._id, "diaryTitle": titleTextField.text!, "dairyContents": contentTextField.text!])
        
        repository.updateItem(id: data._id, title: titleText, contents: contentText)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleTextField.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            $0.center.equalTo(view)
        }
        
        contentTextField.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view).offset(60)
        }
    }

}
