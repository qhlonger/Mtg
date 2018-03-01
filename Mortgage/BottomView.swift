//
//  BottomView.swift
//  Mortgage
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import PKHUD

class BottomView: UIView , UIWebViewDelegate{

    
  
    lazy var leftView : UIWebView = {
        let left : UIWebView = UIWebView()
        left.delegate = self
        self.addSubview(left)
        return left
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.leftView.frame = self.bounds
    }
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide(animated: true)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        HUD.flash(.error, delay: 1.5)
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    
    
    
    

}
