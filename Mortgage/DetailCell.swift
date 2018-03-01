//
//  DetailCell.swift
//  Mortgage
//
//  Created by Apple on 2017/12/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    
    
    
    lazy var label1 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
//        title.backgroundColor = .red
        self.contentView.addSubview(title)
        return title
    }()
    lazy var label2 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
//        title.backgroundColor = .cyan
        self.contentView.addSubview(title)
        return title
    }()
    lazy var label3 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
//        title.backgroundColor = .blue
        self.contentView.addSubview(title)
        return title
    }()
    lazy var label4 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
//        title.backgroundColor = .yellow
        self.contentView.addSubview(title)
        return title
    }()
    
    
    func layout() {
        self.label1.snp.makeConstraints { (make) in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.25).offset(-7.5)
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(15)
        }
        self.label2.snp.makeConstraints { (make) in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.25).offset(-7.5)
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.label1.snp.right)
        }
        self.label3.snp.makeConstraints { (make) in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.25).offset(-7.5)
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.label2.snp.right)
        }
        self.label4.snp.makeConstraints { (make) in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.25).offset(-7.5)
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.label3.snp.right)
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
