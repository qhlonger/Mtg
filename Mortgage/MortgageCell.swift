
//
//  MortgageCell.swift
//  Mortgage
//
//  Created by Apple on 2017/12/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MortgageCell: UITableViewCell {

    lazy var titleLabel : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        self.contentView.addSubview(title)
        return title
    }()
    lazy var detailLabel : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .right
        self.contentView.addSubview(title)
        return title
    }()
    lazy var unitLabel : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textAlignment = .right
        self.contentView.addSubview(title)
        return title
    }()
    
    func layout() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.5)
        }
        self.detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.unitLabel.snp.left)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.4)
            
        }
        self.unitLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(60)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
