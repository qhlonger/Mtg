
//
//  Col1Cell.swift
//  Mortgage
//
//  Created by mini on 2017/12/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class Col1Cell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.contentView.layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.contentView.layer.borderWidth = 0.5
        self.label1.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.top.bottom.equalTo(self.contentView)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var label1: UILabel = {
        
        let label : UILabel = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(label)
        return label
    }()
    
    
    
}
