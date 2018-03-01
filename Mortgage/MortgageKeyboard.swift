//
//  MortgageKeyboard.swift
//  Mortgage
//
//  Created by Apple on 2017/12/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MortgageKeyboard: UIView {

    var buttons : [UIButton] = []
    lazy var valueLabel: UILabel = {
        let label : UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .right
        label.text = ""
        self.addSubview(label)
        return label
    }()
    lazy var titleLabel : UILabel = {
        let label : UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16  )
        label.text = "title"
        self.addSubview(label)
        return label
    }()
    
    lazy var topBg: UIView = {
        let view : UIView = UIView()
        view.backgroundColor = .white
//        view.layer.borderWidth = 1
//        view.layer.borderColor = Util.get16Color(rgb: 0xdddddd).cgColor
        self.addSubview(view)
        return view
    }()
    
    var hideAction:(()->Void)!
    var confirmAction:((_ keyboard:MortgageKeyboard)->Void)!
    
    var _allowDot : Bool = true
    var allowDot : Bool {
        set{
            _allowDot = newValue
            if(newValue){
                self.buttons[9].setTitle(".", for: .normal)
            }else{
                self.buttons[9].setTitle("", for: .normal)
            }
        }
        get{
            return _allowDot
        }
    }
    
    
    func addKeys(){
        let leftKeys = ["1", "2", "3",
                        "4", "5", "6",
                        "7", "8", "9",
                        ".", "0", "hide", "backspace", "confirm"]
        
        for key : String in leftKeys {
            let btn : UIButton = btnFactory()
            if key == "hide"{
                btn.tag = 1;
                btn.setTitleColor(.clear, for: .normal)
                btn.tintColor =  .black
                btn.setImage(UIImage.init(named: "kb_dismiss")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else if key == "backspace"{
                btn.tag = -1;
                btn.setTitleColor(.clear, for: .normal)
                btn.tintColor =  .black
                btn.setImage(UIImage.init(named: "kb_backspace")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else if key == "confirm"{
                btn.setTitle(Util.localString(key: "qr"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                btn.titleLabel?.numberOfLines = 0
                btn.setBackgroundImage(Util.imageWith(color: Util.themeColor()), for: .normal)
                btn.setBackgroundImage(Util.imageWith(color: Util.darkThemeColor()), for: .highlighted)
                btn.setTitleColor(UIColor.white, for: .normal)
            }else{
                btn.setTitle(key, for: .normal)
            }
            self.addSubview(btn)
            buttons.append(btn)
        }
        
        
        
    }
    override func layoutSubviews() {
        
        let selfH = self.frame.height
        let selfW = self.frame.width
        let width = selfW / 4
        let height = selfH / 5
        
        
        let padding : CGFloat = 1
        
        self.topBg.frame = CGRect.init(x: padding, y: padding, width: selfW - padding*2 , height: height-padding*2)
        self.titleLabel.frame = CGRect.init(x: 15, y: 0, width: selfW * 0.4-15, height: height)
        self.valueLabel.frame = CGRect.init(x: selfW * 0.4, y: 0, width: selfW * 0.6-15, height: height)
        
        
        
        
        
        
        
        var index = 0
        for btn : UIButton in buttons {
            if(index == buttons.count - 2){
                btn.frame = CGRect.init(x: width * 3 + padding, y: height + padding, width: width - padding*2, height: height*2 - padding*2)
            }else if(index == buttons.count - 1){
                btn.frame = CGRect.init(x: width * 3 + padding, y: height * 2 + height + padding, width: width - padding*2, height: height*2 - padding*2)
                
            }else{
                let x = CGFloat(index % 3) * width
                let y = CGFloat((index) / 3) * height + height
                btn.frame = CGRect.init(x:x + padding, y:y + padding, width:width - padding*2, height:height - padding*2)
            }
            index = index + 1
        }
        
        
        self.sendSubview(toBack: self.topBg)
    }
    
    
    @objc func btnClick(btn:UIButton){
        if btn.tag == 1 {
            if hideAction != nil {
                hideAction()
            }
        }else if btn.title(for: .normal) == Util.localString(key: "qr") {
            if confirmAction != nil {
                confirmAction(self)
            }
        }else if btn.tag == -1 {
            
            var title : NSString = self.valueLabel.text! as NSString
            if title.length > 0 {
                title = title.substring(to: title.length - 1) as NSString
                self.valueLabel.text = title as String
            }
        }else{
            var title : NSString = self.valueLabel.text! as NSString
            if title.length < 10 {
                title = title.appending(btn.title(for: .normal)!) as NSString
                self.valueLabel.text = title as String
            }
        }
        
        
    }
    func btnFactory() -> UIButton{
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setBackgroundImage(Util.imageWith(color: .white), for: .normal)
        btn.setBackgroundImage(Util.imageWith(color: Util.get16Color(rgb: 0xdddddd)), for: .highlighted)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = Util.get16Color(rgb: 0xdddddd).cgColor
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return btn
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addKeys()
        self.backgroundColor = Util.get16Color(rgb: 0xdddddd)
        self.valueLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(self.allowDot){
            if keyPath == "text" {
                if (self.valueLabel.text?.contains("."))!{
                    self.buttons[9].setTitle("", for: .normal)
                }else{
                    self.buttons[9].setTitle(".", for: .normal)
                }
            }
        }else{
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
