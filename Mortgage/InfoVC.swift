//
//  InfoVC.swift
//  Mortgage
//
//  Created by mini on 2017/12/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import Hero
class InfoVC: UIViewController {

    lazy var closeBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "nav_close").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.tintColor = .white
        self.view.addSubview(btn)
        return btn
    }()
    @objc func close() {
        self.dismiss(animated: true) {
            
        }
    }
    lazy var iconView : UIImageView = {
        let icon : UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill;
        icon.image = #imageLiteral(resourceName: "home_appicon")
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        self.view.addSubview(icon)
        return icon
    }()
    lazy var nav: UIView = {
        let n : UIView = UIView()
        n.backgroundColor = Util.themeColor()
        self.view.addSubview(n)
        return n
    }()
    
    lazy var titleLabel: UILabel = {
        let title : UILabel = UILabel()
        title.text = Util.localString(key: "gy")
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }()
    lazy var appTitleLabel: UILabel = {
        let title : UILabel = UILabel()
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }()
    lazy var appInfoLabel: UILabel = {
        let title : UILabel = UILabel()
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }()
    
    lazy var feedbackBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setBackgroundImage(Util.imageWith(color: Util.themeColor()), for: .normal)
        btn.setTitle(Util.localString(key: "fk"), for: .normal)
        btn.addTarget(self, action: #selector(feedback), for: .touchUpInside)
        btn.tintColor = .white
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        self.view.addSubview(btn)
        return btn
    }()
    @objc func feedback(){
        self.present(FeedbackVC(), animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let infoDictionary : Dictionary = Bundle.main.infoDictionary!
        let appDisplayName : NSString? = Util.localString(key: "appname") as NSString //程序名称
        let majorVersion : NSString? = infoDictionary ["CFBundleShortVersionString"] as? NSString //主程序版本号
        let minorVersion : NSString? = infoDictionary ["CFBundleVersion"] as? NSString //版本号（内部标示）
        
        appTitleLabel.text = NSString.init(format: "%@%@(%@)", appDisplayName!, majorVersion!, minorVersion!) as String
        
        
        
        self.isHeroEnabled = true
        
        self.feedbackBtn.heroID = "feed"
        self.nav.heroID = "header"
        self.closeBtn.heroID = "info"
        self.titleLabel.heroID = "title"
        self.iconView.heroID = "icon"
        
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
        self.iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).multipliedBy(0.8)
            make.width.height.equalTo(100)
        }
        self.appTitleLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.iconView.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        self.appInfoLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.appTitleLabel.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        
        self.feedbackBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.6)
            make.top.equalTo(self.appInfoLabel.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        
    }
    
    
    
    
    

}
