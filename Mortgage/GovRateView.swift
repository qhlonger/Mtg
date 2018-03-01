
//
//  GovRateView.swift
//  Mortgage
//
//  Created by Apple on 2017/12/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class GovRateView: UIView {

    var buttons : [UIButton] = []
    
    var hideAction:(()->Void)!
    var confirmAction:((_ keyboard:RateView)->Void)!
    
    
    var btnSelected : ((_ item : Dictionary<String, Any>) -> Void)!
    let items = [["title":(NSString.init(format: "%@", Util.localString(key: "jzll")) as String), "value":2.75],
                 ["title":(NSString.init(format: "1.1%@", Util.localString(key: "bll")) as String), "value":3.03]]
    
    func addKeys(){
        
        
        for item : [String:Any] in items {
            let btn : UIButton = btnFactory()
            btn.setTitle(item["title"] as? String, for: .normal)
            self.addSubview(btn)
            buttons.append(btn)
        }
        
        
        
    }
    override func layoutSubviews() {
        
        let selfH = self.frame.height
        let selfW = self.frame.width
        let width = selfW / 2
        let height = selfH / 1
        
        
        
        
        
        let padding : CGFloat = 1
        
        var index = 0
        for btn : UIButton in buttons {
            
            let x = CGFloat(index % 2) * width
            let y = CGFloat((index) / 2) * height
            btn.frame = CGRect.init(x:x+padding, y:y+padding, width:width-padding*2, height:height-padding*2)
            index = index + 1
        }
        
        
        
    }
    
    
    @objc func btnClick(btn:UIButton){
        let index : NSInteger = self.buttons.index(of: btn)!
        self.buttons.forEach { (btn) in
            btn.isSelected = false
        }
        btn.isSelected = true
        if btnSelected != nil {
            btnSelected(self.items[index])
        }
        
        
        
    }
    func btnFactory() -> UIButton{
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setBackgroundImage(Util.imageWith(color: .white), for: .normal)
        btn.setBackgroundImage(Util.imageWith(color: Util.get16Color(rgb: 0xdddddd)), for: .highlighted)
        btn.setBackgroundImage(Util.imageWith(color: Util.themeColor()), for: .selected)
        
        
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //        btn.layer.borderWidth = 1
        //        btn.layer.borderColor = Util.get16Color(rgb: 0xdddddd).cgColor
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return btn
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addKeys()
        self.backgroundColor = Util.get16Color(rgb: 0xdddddd)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
