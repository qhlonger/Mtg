
//
//  HeaderView.swift
//  Mortgage
//
//  Created by Apple on 2017/12/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SnapKit
/*
 
 等额本息计算公式
 每月还款额=贷款本金×[月利率×（1+月利率）^还款月数]÷[（1+月利率）^还款月数-1]
 
 总支付利息：总利息=还款月数×每月月供额-贷款本金
 
 每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
 
 每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
 
 总利息=还款月数×每月月供额-贷款本金
 
 
 等额本金计算公式
 每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
 
 每月应还本金=贷款本金÷还款月数
 
 每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率。
 
 每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
 
 总利息=还款月数×(总贷款额×月利率-月利率×(总贷款额÷还款月数)*(还款月数-1)÷2+总贷款额÷还款月数)
 
 */


class RepaymentModel: NSObject {
    //每月还款
    var repaymentPerMonth : CGFloat = 0
    //每月本金
    var principalPerMonth : CGFloat = 0
    //每月利息
    var interestPerMonth      : CGFloat = 0
    //剩余应还
    var remain      : CGFloat = 0

    
    var month   : String = ""
    
}
class HeaderView: UIView {
    
    //总还款
    var repaymentTotal      : CGFloat = 0
    //总利息
    var interestTotal       : CGFloat = 0
    //总贷款
    var loanTotal           :CGFloat = 0
    //贷款月数
    var totalMonth          : NSInteger = 0
    var firstMonthPay       :CGFloat = 0
    var lastMonthPay        :CGFloat = 0
    var perMonthPay         :CGFloat = 0
    
    var repaymentModels : [RepaymentModel] = []
    var repaymentDics : [[String:Any]] = []
    
    //每月递减
    var subPerMonth      : CGFloat = 0
    
    
    var _showAll : Bool = false ;
    var showAll : Bool {
        get{
            return _showAll
        }
        set{
            _showAll = newValue
           self.tableView.isHidden = !_showAll
            self.label1.isHidden =  !_showAll
            self.label2.isHidden =  !_showAll
            self.label3.isHidden =  !_showAll
            self.label4.isHidden =  !_showAll
        }
    }
    lazy var segment: UISegmentedControl = {
        let seg : UISegmentedControl = UISegmentedControl.init(items: [Util.localString(key: "debx"),Util.localString(key: "debj")])
        seg.tintColor = .white
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(segClick), for: .valueChanged)
        self.addSubview(seg)
        return seg
    }()
    @objc func segClick(){
        if segment.selectedSegmentIndex == 0{
            self.titleLabel2.isHidden = true
            self.detailLabel2.isHidden = true
            self.titleLabel1.text = Util.localString(key: "myyg")
            
            self.titleLabel3.text = Util.localString(key: "zhk")
            self.titleLabel4.text = Util.localString(key: "zlx")
            
        }else if segment.selectedSegmentIndex == 1{
            self.titleLabel2.isHidden = false
            self.detailLabel2.isHidden = false
            self.titleLabel1.text = Util.localString(key: "syyg")
            self.titleLabel2.text = Util.localString(key: "mydj")
            self.titleLabel3.text = Util.localString(key: "zhk")
            self.titleLabel4.text = Util.localString(key: "zlx")
        }
    }
    lazy var tableView: UITableView = {
        let table : UITableView = UITableView.init(frame: self.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.allowsSelection = false
        table.separatorColor = .white
        table.tableFooterView = UIView()
        table.register(DetailCell.self, forCellReuseIdentifier: "DetailCellID")
        self.addSubview(table)
        return table
    }()
    lazy var titleLabel1: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = Util.localString(key: "myyg")
        self.addSubview(label)
        return label
    }()
    lazy var titleLabel2: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = Util.localString(key: "mydj")
        self.addSubview(label)
        return label
    }()
    lazy var titleLabel3: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = Util.localString(key: "zhk")
        self.addSubview(label)
        return label
    }()
    lazy var titleLabel4: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = Util.localString(key: "zlx")
        self.addSubview(label)
        return label
    }()
    
    
    lazy var detailLabel1: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "0"
        self.addSubview(label)
        return label
    }()
    lazy var detailLabel2: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "0"
        label.isHidden = true
        self.addSubview(label)
        return label
    }()
    lazy var detailLabel3: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "0"
        self.addSubview(label)
        return label
    }()
    lazy var detailLabel4: UILabel = {
        let label : UILabel =  UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "0"
        self.addSubview(label)
        return label
    }()
    
    
    lazy var detailBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.backgroundColor = Util.darkThemeColor()
        btn.setImage(#imageLiteral(resourceName: "btn_indicator").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "btn_indicator_sel").withRenderingMode(.alwaysTemplate), for: .selected)
        btn.setImage(#imageLiteral(resourceName: "btn_highlight").withRenderingMode(.alwaysTemplate), for: .highlighted)
        btn.tintColor = .white
        self.addSubview(btn)
        return btn
    }()
    lazy var leftBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
//        btn.backgroundColor = Util.darkThemeColor()
        btn.setImage(#imageLiteral(resourceName: "nav_info").withRenderingMode(.alwaysTemplate), for: .normal)
        
        btn.tintColor = .white
        self.addSubview(btn)
        return btn
    }()
    lazy var rightBtn: UIButton = {
        let btn : UIButton = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "nav_charts") .withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.backgroundColor = Util.darkThemeColor()
        btn.tintColor = .white
        self.addSubview(btn)
        return btn
    }()
    
    lazy var label1 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
        title.isHidden = true
        title.text = Util.localString(key: "ys")
        //        title.backgroundColor = .red
        self.addSubview(title)
        return title
    }()
    lazy var label2 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
        title.isHidden = true
        title.text = Util.localString(key: "myyh")
        //        title.backgroundColor = .cyan
        self.addSubview(title)
        return title
    }()
    lazy var label3 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
        title.isHidden = true
        title.text = Util.localString(key: "mybj")
        //        title.backgroundColor = .blue
        self.addSubview(title)
        return title
    }()
    lazy var label4 : UILabel = {
        let title : UILabel = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .white
        title.isHidden = true
        title.text = Util.localString(key: "mylx")
        //        title.backgroundColor = .yellow
        self.addSubview(title)
        return title
    }()
    
    
    
    func refresh(){
        if segment.selectedSegmentIndex == 0{
            self.detailLabel1.text = NSString.init(format: "%.2f", perMonthPay) as String
            self.detailLabel3.text = NSString.init(format: "%.2f", repaymentTotal) as String
            self.detailLabel4.text = NSString.init(format: "%.2f", interestTotal) as String
        }else if segment.selectedSegmentIndex == 1{
            self.detailLabel1.text = NSString.init(format: "%.2f", firstMonthPay) as String
            self.detailLabel2.text = NSString.init(format: "%.2f", subPerMonth) as String
            self.detailLabel3.text = NSString.init(format: "%.2f", repaymentTotal) as String
            self.detailLabel4.text = NSString.init(format: "%.2f", interestTotal) as String
        }
        self.tableView.reloadData()
    }
    
    
    func layout() {
        self.titleLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.width.equalTo(self.snp.width).multipliedBy(0.5).offset(-30)
            make.height.equalTo(15)
            make.top.equalTo(self.segment.snp.bottom).offset(15)
        }
        self.titleLabel2.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.titleLabel1)
            make.width.height.equalTo(self.titleLabel1)
        }
        self.detailLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel1)
            make.top.equalTo(self.titleLabel1.snp.bottom)
            make.width.equalTo(self.titleLabel1)
            make.height.equalTo(30)
        }
        self.detailLabel2.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.detailLabel1)
            make.width.height.equalTo(self.detailLabel1)
            
        }
        
        
        self.titleLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self.detailLabel1.snp.bottom).offset(20)
            make.width.height.equalTo(self.titleLabel1)
        }
        self.titleLabel4.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel2)
            make.top.equalTo(self.titleLabel3)
            make.width.height.equalTo(self.titleLabel1)
        }
        self.detailLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel1)
            make.top.equalTo(self.titleLabel3.snp.bottom)
            make.width.equalTo(self.titleLabel1)
            make.height.equalTo(self.detailLabel1)
        }
        self.detailLabel4.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self.detailLabel3)
            make.width.height.equalTo(self.detailLabel3)
        }
        
        self.detailBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(50)
            make.bottom.equalTo(self)
        }
        
        
        
        
        
        
        self.segment.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Util.topPadding)
            make.left.equalTo(self.leftBtn.snp.right).offset(10)
            make.right.equalTo(self.rightBtn.snp.left).offset(-10)
            make.height.equalTo(40)
        }
        self.leftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.segment);
            make.left.equalTo(self).offset(10);
            
            make.height.equalTo(self.segment);
            make.width.equalTo(self.leftBtn.snp.height);
        }
        self.rightBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.segment);
            make.right.equalTo(self).offset(-10);
            
            make.height.equalTo(self.segment);
            make.width.equalTo(self.rightBtn.snp.height);
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Util.topPadding + 40 + 15 + 50 + 15 + 50 + 15 + 40)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-50)
            
        }
        
        
        self.label1.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.25).offset(-7.5)
            
            make.top.equalTo(detailLabel4.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.left.equalTo(self).offset(15)
        }
        self.label2.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.25).offset(-7.5)
            
            make.top.equalTo(detailLabel4.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.left.equalTo(self.label1.snp.right)
        }
        self.label3.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.25).offset(-7.5)
            
            make.top.equalTo(detailLabel4.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.left.equalTo(self.label2.snp.right)
        }
        self.label4.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.25).offset(-7.5)
            
            make.top.equalTo(detailLabel4.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.left.equalTo(self.label3.snp.right)
        }
        
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.layout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HeaderView : UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : DetailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCellID", for: indexPath) as! DetailCell
            cell.backgroundColor = .clear
            cell.label1.text = NSString.init(format: "%@%d%@",Util.localString(key: "d") , indexPath.row + 1,Util.localString(key: "y") ) as String
            cell.label2.text = NSString.init(format: "%.2f", self.repaymentDics[indexPath.row]["repaymentPerMonth"] as! CGFloat ) as String
            cell.label3.text = NSString.init(format: "%.2f", self.repaymentDics[indexPath.row]["interestPerMonth"] as! CGFloat ) as String
            cell.label4.text = NSString.init(format: "%.2f", self.repaymentDics[indexPath.row]["principalPerMonth"] as! CGFloat ) as String
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.repaymentDics.count
        }
}
