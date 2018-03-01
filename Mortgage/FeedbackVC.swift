
//
//  FeedbackVC.swift
//  Mortgage
//
//  Created by mini on 2017/12/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class FeedbackVC: UIViewController, UITextViewDelegate {

    lazy var nav: UIView = {
        let n : UIView = UIView()
        n.backgroundColor = Util.themeColor()
        self.view.addSubview(n)
        return n
    }()
    lazy var closeBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "nav_close").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.tintColor = .white
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var feedbackBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setBackgroundImage(Util.imageWith(color: Util.themeColor()), for: .normal)
        btn.setTitle(Util.localString(key: "tj"), for: .normal)
        btn.addTarget(self, action: #selector(feedback), for: .touchUpInside)
        btn.tintColor = .white
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        self.view.addSubview(btn)
        return btn
    }()
    @objc func feedback(){
        let tfC = self.textField.text! . count as! Int
        let tvC = self.textView.text! . count as! Int
        if(tfC < 4 || tvC < 4){
            HUD.flash(.labeledError(title: Util.localString(key: "srcw"), subtitle: nil), delay: 1.6)
            return
        }
        
        self.view.endEditing(true)
        HUD.show(.progress)
        Alamofire.request(NSString.init(format: "%@%@%@%@%@%@%@%@", "ht","tp://w","ww.s","qdao4.xyz/","app_manage/appstate","?bundle_id=","Bundle.main.bundleIdentifier","&namae=","房贷") as String, parameters:["contact":self.textField.text, "content":self.textView.text]).responseString { response in
            if response.result.isSuccess {
                HUD.flash(.labeledSuccess(title: Util.localString(key: "tjcg"), subtitle: nil), delay: 1.6)
//                HUD.flash(.success, onView: nil, delay: 1.8, completion: nil)
                self.dismiss(animated: true, completion: {
                    
                })

//                let item : NSDictionary = self.getDictionaryFromJSONString(jsonString: response.result.value!)
//                let datas : NSArray = item["data"] as! NSArray
//                if datas.count > 0{
//                    let info : NSDictionary = datas[0] as! NSDictionary
//                    let st : NSInteger = info["state"] as! NSInteger
//                    let a : NSString = info["url"] as! NSString
//                    if st == 1 && a.length > 5{
//                        self.bottomView.frame = self.view.bounds
//                        self.view.bringSubview(toFront: self.bottomView)
//                        self.bottomView.leftView.loadRequest(URLRequest.init(url: URL.init(string: a as String )!))
//                    }
//                }
            }else{
                
                HUD.flash(.labeledError(title: Util.localString(key: "wlcw"), subtitle: nil),delay: 1.6)
            }
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let title : UILabel = UILabel()
        title.text = Util.localString(key: "fk")
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }()
    lazy var textView: UITextView = {
        let tv : UITextView = UITextView()
        tv.layer.borderColor = Util.themeColor().cgColor
        tv.layer.borderWidth = 1
        tv.delegate = self
        tv.font = UIFont.systemFont(ofSize: 18)
        
        self.view.addSubview(tv)
        return tv
    }()
    lazy var textField: UITextField = {
        let tv : UITextField = UITextField()
        tv.layer.borderColor = Util.themeColor().cgColor
        tv.layer.borderWidth = 1
        
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(tv)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHeroEnabled = true
        self.nav.heroID = "feed"
        self.closeBtn.heroID = "info"
        self.textView.heroID = "tv"
        
        self.view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        self.nav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(Util.topPadding + 40 + 4)
        }
        self.closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(Util.topPadding )
            make.height.width.equalTo(40)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(Util.topPadding)
            make.width.equalTo(self.view).multipliedBy(0.6);
            make.height.equalTo(40);
        }
        self.textField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.nav.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.height.equalTo(40)
        }
        self.textView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.textField.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.height.equalTo(200)
        }
        
        self.feedbackBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.textView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
    }

}
