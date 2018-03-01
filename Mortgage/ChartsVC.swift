//
//  ChartsVC.swift
//  Mortgage
//
//  Created by mini on 2017/12/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ChartsVC: UIViewController {

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
    lazy var nav: UIView = {
        let n : UIView = UIView()
        n.backgroundColor = Util.themeColor()
        self.view.addSubview(n)
        return n
    }()
    
    lazy var titleLabel: UILabel = {
        let title : UILabel = UILabel()
        title.text = "利率表"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }()
    
    
    lazy var tableView: UITableView = {
        let table : UITableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(Col1Cell.self, forCellReuseIdentifier: "Col1CellID")
        table.register(Col2Cell.self, forCellReuseIdentifier: "Col2CellID")
        table.register(Col3Cell.self, forCellReuseIdentifier: "Col3CellID")
        self.view.addSubview(table)
        return table
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHeroEnabled = true
        self.tableView.heroID = "table"
        self.nav.heroID = "header"
        self.closeBtn.heroID = "charts"
        self.titleLabel.heroID = "title" 
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
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.nav.snp.bottom)
        }
    }
    
}


let table1datas = [["六个月","4.35","2.75"],
                   ["一　年","4.35","2.75"],
                   ["一至三年","4.75","2.75"],
                   ["三至五年","4.75","2.75"],
                   ["五年以上","4.90","3.25"]]

let table2datas = [["商业贷款基准利率","4.90"],
                   ["上浮10%","5.39"],
                   ["上浮10%","5.88"],
                   ["上浮30%","6.37"]]
let table3datas = [
                   ["5年（含）以内","2.75","2.75"],
                   ["5年以上","3.25","3.25"]]


extension ChartsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "利率表"
                cell.label1.font = UIFont.boldSystemFont(ofSize: 20)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell : Col3Cell = tableView.dequeueReusableCell(withIdentifier: "Col3CellID", for: indexPath) as! Col3Cell
                cell.label1.text = "贷款期限"
                cell.label2.text = "商业贷款利率(%)"
                cell.label3.text = "公积金贷款利率(%)"
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 7 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "注：本表利率是贷款基准利率。房贷利率还与借款人资质有关，实际执行利率以银行要求为准。\n本利率表中的利率仅供参考，具体详情请咨询各银行网点柜台。"
                
                cell.label1.font = UIFont.systemFont(ofSize: 12)
                
                cell.selectionStyle = .none
                return cell
            }else{
                let cell : Col3Cell = tableView.dequeueReusableCell(withIdentifier: "Col3CellID", for: indexPath) as! Col3Cell
                cell.label1.text = table1datas[indexPath.row - 2][0]
                cell.label2.text = table1datas[indexPath.row - 2][1]
                cell.label3.text = table1datas[indexPath.row - 2][2]
                cell.selectionStyle = .default
                return cell
            }
            
            
            
            
        }else if indexPath.section == 1{
            
            if indexPath.row == 0 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "商业贷款二套房利率表"
                cell.label1.font = UIFont.boldSystemFont(ofSize: 20)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell : Col2Cell = tableView.dequeueReusableCell(withIdentifier: "Col2CellID", for: indexPath) as! Col2Cell
                cell.label1.text = "贷款期限"
                cell.label2.text = "商业贷款利率(%)"
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 5 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "注：按最新房贷政策，当前已有1套住房，且房贷未结清的，再次贷款购买'二套'房，利率最低上浮10%。房贷利率还与借款人资质等有关，实际执行利率以银行要求为准。"
                cell.label1.font = UIFont.systemFont(ofSize: 12)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell : Col2Cell = tableView.dequeueReusableCell(withIdentifier: "Col2CellID", for: indexPath) as! Col2Cell
                cell.label1.text = table2datas[indexPath.row - 2][0]
                cell.label2.text = table2datas[indexPath.row - 2][1]
                cell.selectionStyle = .default
                return cell
            }
        }else if indexPath.section == 2{
            
            
            
            if indexPath.row == 0 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "公积金贷款二套房利率表"
                cell.label1.font = UIFont.boldSystemFont(ofSize: 20)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell : Col3Cell = tableView.dequeueReusableCell(withIdentifier: "Col3CellID", for: indexPath) as! Col3Cell
                cell.label1.text = "贷款期限"
                cell.label2.text = "基准利率(%)"
                cell.label3.text = "1.1倍基准利率(%)"
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 4 {
                let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
                cell.label1.text = "注：目前公积金首套房贷款执行基准利率，二套房贷款多执行1.1倍基准利率，上调幅度与借款人资质等因素有关。"
                cell.label1.font = UIFont.systemFont(ofSize: 12)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell : Col3Cell = tableView.dequeueReusableCell(withIdentifier: "Col3CellID", for: indexPath) as! Col3Cell
                cell.label1.text = table3datas[indexPath.row - 2][0]
                cell.label2.text = table3datas[indexPath.row - 2][1]
                cell.label3.text = table3datas[indexPath.row - 2][2]
                cell.selectionStyle = .default
                return cell
            }
            
            
            
            
            
            
            
        }
        let cell : Col1Cell = tableView.dequeueReusableCell(withIdentifier: "Col1CellID", for: indexPath) as! Col1Cell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 7{
                return 60
            }
        }
        if indexPath.section == 1{
            if indexPath.row == 5{
                return 60
            }
        }
        if indexPath.section == 2{
            if indexPath.row == 4{
                return 60
            }
        }
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return 8}
        if section == 1{return 6}
        if section == 2{return 5}
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
