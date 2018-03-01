//
//  Col2Cell.swift
//  Mortgage
//
//  Created by mini on 2017/12/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class Col2Cell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.label1.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.5)
        }
        self.label2.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.label1.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var label1: UILabel = {
        let label : UILabel = UILabel()
        label.layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        self.contentView.addSubview(label)
        return label
    }()
    lazy var label2: UILabel = {
        let label : UILabel = UILabel()
        label.layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        self.contentView.addSubview(label)
        return label
    }()
    

}
