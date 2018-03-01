

//
//  YearsView.swift
//  Mortgage
//
//  Created by Apple on 2017/12/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class YearsView: UIView {
    
    lazy var minLabel : UILabel = {
        let label : UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "0"
        self.addSubview(label)
        return label
    }()
    lazy var maxLabel : UILabel = {
        let label : UILabel = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "35"
        self.addSubview(label)
        return label
    }()
    
    
    
    lazy var slider: UISlider = {
        let slider : UISlider = UISlider()
        slider.maximumTrackTintColor = Util.themeColor()
        slider.minimumTrackTintColor = Util.themeColor()
        slider.maximumValue = 35
        slider
        slider.minimumValue = 1
        slider.addTarget(self, action: #selector(sliderSlide(slider:)), for: .valueChanged)
        slider.value = 20
        
        self.addSubview(slider)
        return slider
    }()
    
    var sliderSlide : ((_ slider:UISlider)->Void)!
    
    
    
    @objc func sliderSlide(slider:UISlider){
        if sliderSlide != nil {
            sliderSlide(self.slider)
        }
    }
    
    
    override func layoutSubviews() {
        self.minLabel.frame = CGRect.init(x: 15, y: 0, width: 40, height:  self.frame.height)
        self.maxLabel.frame = CGRect.init(x: self.frame.width - 55, y: 0, width: 40, height:  self.frame.height)
        self.slider.frame = CGRect.init(x: 55, y: 0, width: self.frame.width - 110, height: self.frame.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.slider.value = 20
        self.backgroundColor = Util.get16Color(rgb: 0xffffff)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
