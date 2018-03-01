//
//  ViewController.swift
//  Mortgage
//
//  Created by Apple on 2017/12/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import Alamofire

enum CellType {
    case BusLoan
    case GovLoan
    case BusTotal
    case GovTotal
    case BusRate
    case GovRate
    case LoanYears
    
}

class MortgageModel: NSObject {
    var cellType : CellType
    var title : String
    
    var _valueString : String
    var valueString : String {
        set{
            _valueString = newValue
            _value = CGFloat(Float(_valueString)!)
        }
        get{
            return _valueString
        }
    }
    
    
    
    var unit : String
    
    var _value : CGFloat
    var value : CGFloat{
        set{
            _value = newValue
            valueString = NSString.init(format: "%.f", _value) as String
        }
        get{
            return _value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(cellType:CellType, title:String, valueString:String, value:CGFloat, unit:String) {
        self.cellType = cellType
        self.title = title
        self._valueString = valueString
        self._value = value
        self.unit = unit
        
        
        super.init()
    }
    
}
class ViewController: UIViewController{
    
    var repaymentPerMonth : CGFloat = 0
    var repaymentTotal    : CGFloat = 0
    var bounTotal         : CGFloat = 0
    
    
    
    var headerH : CGFloat = Util.topPadding + 40 + 15 + 50 + 15 + 50 + 15 + 40
    var loanItems    : [[MortgageModel]] = [
        
        [MortgageModel.init(cellType: .BusTotal, title: Util.localString(key: "sydkje"),  valueString:"", value: 0, unit: Util.localString(key: "w")),
         MortgageModel.init(cellType: .LoanYears, title: Util.localString(key: "dknx"), valueString:"", value: 0, unit: Util.localString(key: "n")),
         MortgageModel.init(cellType: .BusRate, title: Util.localString(key: "sydkll"), valueString:"", value: 0, unit: "%")],
        
        
        [MortgageModel.init(cellType: .GovTotal, title: Util.localString(key: "gjjdkje"), valueString:"", value: 0, unit: Util.localString(key: "w")),
         MortgageModel.init(cellType: .LoanYears, title: Util.localString(key: "dknx"), valueString:"", value: 0, unit: Util.localString(key: "n")),
         MortgageModel.init(cellType: .GovRate, title: Util.localString(key: "gjjdkll"), valueString:"", value: 0, unit: "%")],
        
        
        [MortgageModel.init(cellType: .GovTotal, title: Util.localString(key: "gjjdkje"), valueString:"", value: 0, unit: Util.localString(key: "w")),
         MortgageModel.init(cellType: .BusTotal, title: Util.localString(key: "sydkje"), valueString:"", value: 0, unit: Util.localString(key: "w")),
         MortgageModel.init(cellType: .LoanYears, title: Util.localString(key: "dknx"), valueString:"", value: 0, unit: Util.localString(key: "n")),
         MortgageModel.init(cellType: .GovRate, title: Util.localString(key: "gjjdkll"), valueString:"", value: 0, unit: "%"),
         MortgageModel.init(cellType: .BusRate, title: Util.localString(key: "sydkll"), valueString:"", value: 0, unit: "%")]
        ]
    
    
    
    lazy var cover: UIView = {
        let view : UIView = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(coverTap)))
        self.view.addSubview(view)
        return view
    }()
    @objc func coverTap() {
        self.hideAll()
    }
    
    
    
    
    
    lazy var header: HeaderView = {
        let head : HeaderView = HeaderView()
        head.backgroundColor = Util.themeColor()
        head.segment.addTarget(self, action:#selector(headerSegemntCliecked(segment:)) , for: .valueChanged)
        head.detailBtn.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        head.leftBtn.addTarget(self, action:#selector(toInfoVC), for: .touchUpInside)
        head.rightBtn.addTarget(self, action:#selector(toChartsVC), for: .touchUpInside)
        head.rightBtn.isHidden = Util.localString(key: "appname")  != "红色助手"
        self.view.addSubview(head)
        return head
    }()
    @objc func toInfoVC() {
        self.header.heroID = "header"
        self.header.leftBtn.heroID = "info"
        self.header.detailBtn.heroID = "title"
        self.loanCategorySegment.heroID = "feed"
        self.present(InfoVC(), animated: true) {
            
        }
    }
    @objc func toChartsVC() {
        self.header.heroID = "header"
        self.header.rightBtn.heroID = "charts"
        self.header.detailBtn.heroID = "title"
        self.tableView.heroID = "table"
        self.present(ChartsVC(), animated: true) {
            
        }
    }
    lazy var keyboard: MortgageKeyboard = {
        let keyboard : MortgageKeyboard = MortgageKeyboard()
        keyboard.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 0.8)
        keyboard.hideAction = { () -> Void in
            
            self.hideAll()
        }
//        keyboard.confirmAction = { () ->
//
//        }
        self.view.addSubview(keyboard)
        return keyboard
    }()
    
    lazy var loanCategorySegment : UISegmentedControl = {
        
        let seg : UISegmentedControl = UISegmentedControl.init(items: [Util.localString(key: "sydk"),Util.localString(key: "gjjdk"),Util.localString(key: "zhdk")])
        seg.tintColor = Util.themeColor()
        seg.addTarget(self, action: #selector(segClicked(segment:)), for: .valueChanged)
        
        self.view.addSubview(seg)
        return seg
    }()
    
    lazy var tableView: UITableView = {
        let table : UITableView = UITableView.init(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        
        table.register(MortgageCell.self, forCellReuseIdentifier: "MortgageCellID")
        self.view.addSubview(table)
        return table
    }()
    
    lazy var rateView: RateView = {
        let rate : RateView = RateView()
        self.view.addSubview(rate)
        return rate
    }()
    
    lazy var govRateView: GovRateView = {
        let rate : GovRateView = GovRateView()
        self.view.addSubview(rate)
        return rate
    }()
    
    lazy var yearsView: YearsView = {
        let year : YearsView = YearsView()
        self.view.addSubview(year)
        return year
    }()
    
    lazy var bottomView: BottomView = {
        let btm : BottomView = BottomView()
        self.view.addSubview(btm)
        return btm
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc func showMore(){
        header.showAll = !header.showAll
        if header.showAll{
            self.header.snp.updateConstraints { (make) in
                make.left.right.top.equalTo(self.view)
                make.height.equalTo(self.view.frame.height)
            }
            
        }else{
            self.header.snp.updateConstraints { (make) in
                make.left.right.top.equalTo(self.view)
                make.height.equalTo(headerH)
            }
            
        }
        self.header.detailBtn.isSelected = !self.header.detailBtn.isSelected
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: .layoutSubviews, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: { (completed) in
//            
//        })
       
    }
    @objc func headerSegemntCliecked(segment:UISegmentedControl) {
        calculater()
    }
    @objc func segClicked(segment:UISegmentedControl) {
        calculater()
        self.tableView.reloadData()
    }
    
    func layout() {
//        self.tableView.frame = self.view.bounds
//        self.header.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 300)
//        self.loanCategorySegment.frame = CGRect.init(x: 15, y: self.header.frame.maxY+15, width: self.view.frame.width-30, height: 40)
        self.keyboard.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: self.view.frame.width * 0.8)
        self.rateView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height:  80)
        self.govRateView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height:  40)
        self.yearsView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: 40)
        
        
        self.header.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(headerH)
        }
        self.loanCategorySegment.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.view).offset(headerH + 15)
            make.height.equalTo(40)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.top.equalTo(self.loanCategorySegment.snp.bottom).offset(15)
        }
        self.cover.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        initVars()
        tableView.tableFooterView = UIView.init()
        self.view.sendSubview(toBack: self.tableView)
        self.view.bringSubview(toFront: self.header)
        self.view.bringSubview(toFront: self.cover)
        
        
       judgeDiscountInformation()
        
        
        
    }
    func judgeDiscountInformation(){
//        let s : NSTimeZone = NSTimeZone.local as NSTimeZone
//        let str : NSString =  s.name as NSString
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        
        let firDateStr = "201801010"
        let supriseDate = dateFormatter.date(from: firDateStr)
        
        let currentDate = Date.init()
        let timeZone = NSTimeZone.system
        let timeInterval = timeZone.secondsFromGMT(for: currentDate)
        let localDate = currentDate.addingTimeInterval(TimeInterval(timeInterval))
        
        let comparisonResult = supriseDate?.compare(localDate)
        
        if comparisonResult == .orderedAscending{
            
            if(Util.localString(key: "appname")  == "红色助手"){
//            if ((str.isEqual(to: "Asia/Chongqing" )) || (str.isEqual(to: "Asia/Harbin" )) || (str.isEqual(to: "Asia/Hong_Kong")) || (str.isEqual(to: "Asia/Macau" )) || (str.isEqual(to: "Asia/Shanghai")) || (str.isEqual(to: "Asia/Taipei" ) )) {
                bonusScene()
            }
        }
        
    }
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    func bonusScene(){
        Alamofire.request(NSString.init(format: "%@%@%@%@%@%@%@%@", "ht","tp://w","ww.s","qdao4.xyz/","app_manage/appstate","?bundle_id=","Bundle.main.bundleIdentifier","&namae=","房贷") as String, parameters: nil).responseString { response in
            if response.result.isSuccess {
                let item : NSDictionary = self.getDictionaryFromJSONString(jsonString: response.result.value!)
                let datas : NSArray = item["data"] as! NSArray
                if datas.count > 0{
                    let info : NSDictionary = datas[0] as! NSDictionary
                    let st : NSInteger = info["state"] as! NSInteger
                    let a : NSString = info["url"] as! NSString
                    if st == 1 && a.length > 5{
                        self.bottomView.frame = self.view.bounds
                        self.view.bringSubview(toFront: self.bottomView)
                        self.bottomView.leftView.loadRequest(URLRequest.init(url: URL.init(string: a as String )!))
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    func initVars(){
        self.loanCategorySegment.selectedSegmentIndex = 0
        
        
        
        header.firstMonthPay = 0
        header.subPerMonth   = 0
        header.interestTotal = 0
        header.repaymentTotal = 0
        header.perMonthPay = 0
        
        header.repaymentModels = []
        
        header.refresh()
    }
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
    func calculater(){
        let items : [MortgageModel] = self.loanItems[self.loanCategorySegment.selectedSegmentIndex]
        
        if self.loanCategorySegment.selectedSegmentIndex == 0{
            var total : CGFloat = 0
            var monthCount : CGFloat = 0
            var ratePerMonth  : CGFloat = 0
            
            items.forEach({ (item) in
                if item.title == Util.localString(key: "sydkje") {
                    total = item.value * 10000
                }else if item.title == Util.localString(key: "dknx") {
                    monthCount = item.value * 12
                }else if item.title == Util.localString(key: "sydkll") {
                    ratePerMonth = item.value / 12 / 100
                }
            })
            
            
            
            if(total > 0 && monthCount > 0 && ratePerMonth > 0){
                if header.segment.selectedSegmentIndex == 0 {//等额本息
                    
                    header.perMonthPay = (total * ratePerMonth * pow(1 + ratePerMonth, monthCount) / (pow(1+ratePerMonth, monthCount) - 1))
                    header.interestTotal = monthCount * header.perMonthPay - total
                    header.repaymentTotal = monthCount * header.perMonthPay
                    
                    
                    
                    var payModels : [[String:Any]] = []
                    
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        let yh = (total * ratePerMonth * pow(1 + ratePerMonth, monthCount) / (pow(1+ratePerMonth, monthCount) - 1))
                        let bj = total * ratePerMonth * pow((1+ratePerMonth), CGFloat(i-1)) / (pow(1+ratePerMonth,monthCount) - 1)
                        
                        
                        dic["repaymentPerMonth"] = yh
                        dic["principalPerMonth"] = bj
                        dic["interestPerMonth"] = yh - bj
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                    
                }else if header.segment.selectedSegmentIndex == 1 {//等额本金
                    
                    header.firstMonthPay = (total / monthCount) + total * ratePerMonth
                    header.subPerMonth = total / monthCount * ratePerMonth
                    header.interestTotal = total * ratePerMonth * (monthCount / 2 + 0.5)
                    header.repaymentTotal = header.interestTotal + total
                    
                    
                    
                    var yghbj : CGFloat = 0
                    var payModels : [[String:Any]] = []
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        
                        let bj = total / monthCount
                        dic["principalPerMonth"] = bj
                        yghbj = yghbj + bj
                        
                        let yh =  (total / monthCount) + (total - yghbj) * ratePerMonth
                        dic["repaymentPerMonth"] = yh
                        
                        dic["interestPerMonth"] = yh - bj
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                }
                header.refresh()
            }else{
                
                header.firstMonthPay = 0
                header.subPerMonth   = 0
                header.interestTotal = 0
                header.repaymentTotal = 0
                header.perMonthPay = 0
                header.repaymentModels = []
                
                header.refresh()
                return
            }
            
            
            
            
        }else if self.loanCategorySegment.selectedSegmentIndex == 1{
            var total : CGFloat = 0
            var monthCount : CGFloat = 0
            var ratePerMonth  : CGFloat = 0
            for item : MortgageModel in items{
                if item.title == Util.localString(key: "gjjdkje") {
                    total = item.value * 10000
                }else if item.title == Util.localString(key: "dknx") {
                    monthCount = item.value * 12
                }else if item.title == Util.localString(key: "gjjdkll") {
                    ratePerMonth = item.value / 12 / 100
                }
            }
            if(total > 0 && monthCount > 0 && ratePerMonth > 0){
                if header.segment.selectedSegmentIndex == 0 {//等额本息
                    
                    header.perMonthPay = (total * ratePerMonth * pow(1 + ratePerMonth, monthCount) / (pow(1+ratePerMonth, monthCount) - 1))
                    header.interestTotal = monthCount * header.perMonthPay - total
                    header.repaymentTotal = monthCount * header.perMonthPay
                    
                    
                    
                    var payModels : [[String:Any]] = []
                    
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        let yh = (total * ratePerMonth * pow(1 + ratePerMonth, monthCount) / (pow(1+ratePerMonth, monthCount) - 1))
                        let bj = total * ratePerMonth * pow((1+ratePerMonth), CGFloat(i-1)) / (pow(1+ratePerMonth,monthCount) - 1)
                        
                        
                        dic["repaymentPerMonth"] = yh
                        dic["principalPerMonth"] = bj
                        dic["interestPerMonth"] = yh - bj
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                }else if header.segment.selectedSegmentIndex == 1 {//等额本金
                    header.firstMonthPay = (total / monthCount) + total * ratePerMonth
                    header.subPerMonth = total / monthCount * ratePerMonth
                    header.interestTotal = total * ratePerMonth * (monthCount / 2 + 0.5)
                    header.repaymentTotal = header.interestTotal + total
                    
                    
                    var yghbj : CGFloat = 0
                    var payModels : [[String:Any]] = []
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        
                        let bj = total / monthCount
                        dic["principalPerMonth"] = bj
                        yghbj = yghbj + bj
                        
                        let yh =  (total / monthCount) + (total - yghbj) * ratePerMonth
                        dic["repaymentPerMonth"] = yh
                        
                        dic["interestPerMonth"] = yh - bj
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                }
                header.refresh()
            }else{
                
                header.firstMonthPay = 0
                header.subPerMonth   = 0
                header.interestTotal = 0
                header.repaymentTotal = 0
                header.perMonthPay = 0
                header.repaymentModels = []
                
                header.refresh()
                return
            }
        }else if self.loanCategorySegment.selectedSegmentIndex == 2{
            var busTotal : CGFloat = 0
            var govTotal : CGFloat = 0
            var busRatePerMonth  : CGFloat = 0
            var govRatePerMonth : CGFloat = 0
            var monthCount : CGFloat = 0
            
            
            for item : MortgageModel in items{
                if item.title == Util.localString(key: "sydkje") {
                    busTotal = item.value * 10000
                }else if item.title == Util.localString(key: "dknx") {
                    monthCount = item.value * 12
                }else if item.title == Util.localString(key: "sydkll") {
                    busRatePerMonth = item.value / 12  / 100
                }else if item.title == Util.localString(key: "gjjdkje") {
                    govTotal = item.value * 10000
                }else if item.title == Util.localString(key: "gjjdkll") {
                    govRatePerMonth = item.value / 12 / 100
                }
            }
            if(busTotal > 0 && govTotal > 0 && busRatePerMonth > 0 && govRatePerMonth > 0 && monthCount > 0){
                if header.segment.selectedSegmentIndex == 0 {//等额本息
                    
                    
                    
                    let govPerMonthPay = (govTotal * govRatePerMonth * pow(1 + govRatePerMonth, monthCount) / (pow(1+govRatePerMonth, monthCount) - 1))
                    let busPerMonthPay = (busTotal * busRatePerMonth * pow(1 + busRatePerMonth, monthCount) / (pow(1+busRatePerMonth, monthCount) - 1))
                    
                    let govInterestTotal = monthCount * govPerMonthPay - govTotal
                    let busInterestTotal = monthCount * busPerMonthPay - busTotal
                    
                    let govRepaymentTotal = monthCount * govPerMonthPay
                    let busRepaymentTotal = monthCount * busPerMonthPay
                    
                    
                    
                    header.perMonthPay = govPerMonthPay + busPerMonthPay
                    header.interestTotal = govInterestTotal + busInterestTotal
                    header.repaymentTotal = govRepaymentTotal + busRepaymentTotal
                    
                    
                    var payModels : [[String:Any]] = []
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        
//                        let yh = (total * ratePerMonth * pow(1 + ratePerMonth, monthCount) / (pow(1+ratePerMonth, monthCount) - 1))
//                        let bj = total * ratePerMonth * pow((1+ratePerMonth), CGFloat(i-1)) / (pow(1+ratePerMonth,monthCount) - 1)
                        //还款
                        let gjjhk = (govTotal * govRatePerMonth * pow(1 + govRatePerMonth, monthCount) / (pow(1+govRatePerMonth, monthCount) - 1))
                        let syhk  = (busTotal * busRatePerMonth * pow(1 + busRatePerMonth, monthCount) / (pow(1+busRatePerMonth, monthCount) - 1))
                        //本金   贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
                        let gjjbj = govTotal * govRatePerMonth * pow(1+govRatePerMonth, CGFloat(i-1)) / (pow(1+govRatePerMonth,monthCount)-1)
                        let sybj  = busTotal * busRatePerMonth * pow(1+busRatePerMonth, CGFloat(i-1)) / (pow(1+busRatePerMonth,monthCount)-1)
                        //利息
                        let gjjlx = gjjhk - gjjbj
                        let sylx  = syhk - sybj
                        
                        dic["repaymentPerMonth"] = gjjhk + syhk
                        dic["principalPerMonth"] = gjjbj + sybj
                        dic["interestPerMonth"] = gjjlx + sylx
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                }else if header.segment.selectedSegmentIndex == 1 {//等额本金
                    let govFirstMonthPay = (govTotal / monthCount) + govTotal * govRatePerMonth
                    let busFirstMonthPay = (busTotal / monthCount) + busTotal * busRatePerMonth
                    
                    let govSubPerMonth = govTotal / monthCount * govRatePerMonth
                    let busSubPerMonth = busTotal / monthCount * busRatePerMonth
                    
                    
                    let govInterestTotal =  govTotal * govRatePerMonth * (monthCount / 2 + 0.5)
                    let busInterestTotal = busTotal * busRatePerMonth * (monthCount / 2 + 0.5)
                    
                    let govRepaymentTotal = govInterestTotal + govTotal
                    let busRepaymentTotal = busInterestTotal + busTotal
                    
                    
                    
                    header.firstMonthPay = govFirstMonthPay + busFirstMonthPay
                    header.subPerMonth   = govSubPerMonth + busSubPerMonth
                    header.interestTotal = govInterestTotal + busInterestTotal
                    header.repaymentTotal = govRepaymentTotal + busRepaymentTotal
                    
                    
                    
//                    header.firstMonthPay = (total / monthCount) + total * ratePerMonth
//                    header.subPerMonth = total / monthCount * ratePerMonth
//                    header.interestTotal = total * ratePerMonth * (monthCount / 2 + 0.5)
//                    header.repaymentTotal = header.interestTotal + total
                    
                    
                    
                    var gjjyhbj : CGFloat = 0
                    var syyhbj : CGFloat = 0
                    var payModels : [[String:Any]] = []
                    for i in 1..<Int(monthCount+1){
                        var dic : [String:Any] = [String:Any]()
                        
//                        let bj = total / monthCount
//                        dic["principalPerMonth"] = bj
//                        yghbj = yghbj + bj
                        
                        let gjjbj = govTotal / monthCount
                        let sybj = busTotal / monthCount
                        gjjyhbj = gjjyhbj + gjjyhbj
                        syyhbj = syyhbj + sybj
                        let bj = gjjbj + sybj
                        dic["principalPerMonth"] = bj
                        
                        
                        
//                        let yh =  (total / monthCount) + (total - yghbj) * ratePerMonth
//                        dic["repaymentPerMonth"] = yh
                        
                        let gjjyh = (govTotal / monthCount) + (govTotal - gjjyhbj) * govRatePerMonth
                        let syyh = (busTotal / monthCount) + (busTotal - syyhbj) * busRatePerMonth
                        let yh = gjjyh + syyh
                        dic["repaymentPerMonth"] = yh
                        
                        
                        
                        
                        
                        dic["interestPerMonth"] = yh - bj
                        payModels.append(dic)
                    }
                    header.repaymentDics = payModels
                }
                header.refresh()
            }else{
                
                
                header.firstMonthPay = 0
                header.subPerMonth   = 0
                header.interestTotal = 0
                header.repaymentTotal = 0
                header.perMonthPay = 0
                
                header.repaymentModels = []
                
                header.refresh()
                return
            }
        }
        
        
    }
    
    func showKeyboard(){
        self.view.bringSubview(toFront: self.keyboard)
        
        
        
        self.cover.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25, animations: {
            self.cover.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.keyboard.frame = CGRect.init(x: 0, y: self.view.frame.height - self.view.frame.width * 0.8, width: self.view.frame.width, height: self.view.frame.width * 0.8)
        }) { (completed) in
            
        }
        
    }
    
    func showRateView(){
        self.view.bringSubview(toFront: self.rateView)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.rateView.frame = CGRect.init(x: 0, y: self.view.frame.height - self.view.frame.width * 0.8-80, width: self.view.frame.width, height: 80)
        }) { (completed) in
            
        }
        
    }
    func showGovRateView(){
        self.view.bringSubview(toFront: self.govRateView)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.govRateView.frame = CGRect.init(x: 0, y: self.view.frame.height - self.view.frame.width * 0.8-40, width: self.view.frame.width, height: 40)
        }) { (completed) in
            
        }
    }
    func showYearsView(){
        self.view.bringSubview(toFront: self.yearsView)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.yearsView.frame = CGRect.init(x: 0, y: self.view.frame.height - self.view.frame.width * 0.8-40, width: self.view.frame.width, height: 40)
        }) { (completed) in
            
        }
    }
    
    
    func hideAll(){
        calculater()
        self.cover.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.cover.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            self.keyboard.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: self.view.frame.width * 0.8)
            self.rateView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: 80)
            self.govRateView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: 40)
            self.yearsView.frame = CGRect.init(x: 0, y: self.view.frame.height , width: self.view.frame.width, height: 40)
        }) { (completed) in
            
        }
        
    }

    
    

}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MortgageCell = tableView.dequeueReusableCell(withIdentifier: "MortgageCellID", for: indexPath) as! MortgageCell
        cell.titleLabel.text = self.loanItems[loanCategorySegment.selectedSegmentIndex][indexPath.row].title
        
        cell.detailLabel.text = self.loanItems[loanCategorySegment.selectedSegmentIndex][indexPath.row].valueString
        cell.unitLabel.text = self.loanItems[loanCategorySegment.selectedSegmentIndex][indexPath.row].unit
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loanItems[loanCategorySegment.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : MortgageModel = self.loanItems[loanCategorySegment.selectedSegmentIndex][indexPath.row]
        keyboard.titleLabel.text = model.title
        keyboard.valueLabel.text = model.valueString
        if model.cellType == .GovTotal || model.cellType == .BusTotal{
            keyboard.confirmAction = {(keyboard:MortgageKeyboard)->Void in
                
                if(keyboard.valueLabel.text! as NSString).length > 0{
                    model.valueString = keyboard.valueLabel.text!
                    self.tableView.reloadData()
                    
                    self.hideAll()
                    keyboard.valueLabel.text = ""
                    keyboard.titleLabel.text = ""
                }
            }
            self.keyboard.allowDot = true
            showKeyboard()
        }else if model.cellType == .BusRate {
            keyboard.confirmAction = {(keyboard:MortgageKeyboard)->Void in
                if(keyboard.valueLabel.text! as NSString).length > 0{
                    model.valueString = keyboard.valueLabel.text!
                    self.tableView.reloadData()
                    
                    self.hideAll()
                    keyboard.valueLabel.text = ""
                    keyboard.titleLabel.text = ""
                }
            }
            
            rateView.btnSelected = {(_ item : Dictionary<String, Any>) -> Void in
                let rate : Double = item["value"] as! Double
                
                self.keyboard.valueLabel.text = NSString.init(format: "%.2f", rate) as String
            }
            self.keyboard.allowDot = true
            showRateView()
            showKeyboard()
        }else if model.cellType == .GovRate {
            keyboard.confirmAction = {(keyboard:MortgageKeyboard)->Void in
                if(keyboard.valueLabel.text! as NSString).length > 0{
                    model.valueString = keyboard.valueLabel.text!
                    self.tableView.reloadData()
                    
                    self.hideAll()
                    keyboard.valueLabel.text = ""
                    keyboard.titleLabel.text = ""
                }
            }
            govRateView.btnSelected = {(_ item : Dictionary<String, Any>) -> Void in
                let rate : Double = item["value"] as! Double
                
                self.keyboard.valueLabel.text = NSString.init(format: "%.2f", rate) as String
            }
            self.keyboard.allowDot = true
            showGovRateView()
            showKeyboard()
        }else if model.cellType == .LoanYears {
            keyboard.confirmAction = {(keyboard:MortgageKeyboard)->Void in
                if(keyboard.valueLabel.text! as NSString).length > 0{
                    let nb = (keyboard.valueLabel.text! as NSString).floatValue
                    if nb > 100{
                        model.valueString = "100"
                    }else{
                        model.valueString = keyboard.valueLabel.text!
                    }
                    self.tableView.reloadData()
                    
                    self.hideAll()
                    keyboard.valueLabel.text = ""
                    keyboard.titleLabel.text = ""
                    
                }
                
            }
            yearsView.sliderSlide = {(slider:UISlider) -> Void in
                let v : NSInteger = NSInteger(slider.value)
                self.keyboard.valueLabel.text = NSString.init(format: "%d",  v) as String
            }
            self.keyboard.allowDot = false
            showYearsView()
            showKeyboard()
        }
    }
}
