//
//  UIViewControllerExtensions.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MBProgressHUD
import EZSwiftExtensions

extension UIViewController {
    
    /// 错误码
    /// 19  ：ad_uid不可为空
    /// 21：ad_uid用户为空
    /// 259：用户状态被禁止
    /// 260：用户登陆失效
    /// - Parameter code: 260
    func checkErrorCode(code: Int) -> Bool {
        if code == 260 || code == 19 || code == 259 {
            
            let alert = UIAlertController(title: "账号异常",
                                          message: "您的账号登录异常，需要重新登录!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "重新登录",
                                          style: UIAlertActionStyle.default,
                                          handler: { (alertAction) in
                       
                                            UserTicketModel.sharedInstance.logout()

                                            let appledate = UIApplication.shared.delegate as! AppDelegate
                                            appledate.showLoginViewController()
                                            
            }))
            self.presentVC(alert);
            
            return true
        }
        return false
    }
    
    /**
     显示拨打电话确认界面
     
     - parameter phoneNumber: 手机号码
     */
    func showPhonePickView(_ phoneNumber: String) -> Void {
        var popupController: CNPPopupController?
        
        func callSomebody() {
            if UIApplication.shared.canOpenURL(URL(string: "tel://\(phoneNumber)")!) {
                UIApplication.shared.openURL(URL(string: "tel://\(phoneNumber)")!)
            }
        }
        
        let screenWith = UIScreen.main.bounds.width
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
        titleLabel.numberOfLines = 0;
        
        let phoneNumberButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
        phoneNumberButton.setTitle(phoneNumber, for: UIControlState())
        phoneNumberButton.setTitleColor(UIColor.black, for: UIControlState())
        // weixinButton.setImage(UIImage(named: "wechat"), forState: UIControlState.Normal)
        //		phoneNumberButton.layer.cornerRadius = 5
        phoneNumberButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        phoneNumberButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        phoneNumberButton.backgroundColor = UIColor.white
        phoneNumberButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        phoneNumberButton.selectionHandler = { (button) in
            popupController?.dismiss(animated: true)
            callSomebody()
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
        lineView.backgroundColor = UIColor(hexString: "CCCCCC")
        
        let phoneNumberCopyButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
        phoneNumberCopyButton.setTitle("复制号码", for: UIControlState())
        phoneNumberCopyButton.setTitleColor(UIColor.black, for: UIControlState())
        // weixinButton.setImage(UIImage(named: "wechat"), forState: UIControlState.Normal)
        //        phoneNumberCopyButton.layer.cornerRadius = 5
        phoneNumberCopyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        phoneNumberCopyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        phoneNumberCopyButton.backgroundColor = UIColor.white
        phoneNumberCopyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        phoneNumberCopyButton.selectionHandler = { (button) in
            popupController?.dismiss(animated: true)
            UIPasteboard.general.string = phoneNumber
        }
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 12))
        lineView2.backgroundColor = UIColor.clear
        
        let closeButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
        closeButton.setTitle("取消", for: UIControlState())
        
        closeButton.setTitleColor( UIColor(hexString: "FE9E38"), for: UIControlState())
        // weixinButton.setImage(UIImage(named: "wechat"), forState: UIControlState.Normal)
        //		closeButton.layer.cornerRadius = 5
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        closeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        closeButton.backgroundColor = UIColor.white
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.selectionHandler = { (button) in
            popupController?.dismiss(animated: true)
        }
        
        popupController = CNPPopupController(contents: [titleLabel, phoneNumberButton,lineView,phoneNumberCopyButton,lineView2, closeButton])
        
        popupController?.theme = CNPPopupTheme.default()
        popupController?.theme.popupStyle = CNPPopupStyle.actionSheet
        popupController?.theme.presentationStyle = CNPPopupPresentationStyle.fadeIn
        popupController?.theme.popupContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        popupController?.theme.contentVerticalPadding = 0
        popupController?.theme.backgroundColor = UIColor.clear //SHConstants.ActionViewBgColor // UIConstants.TableViewBackgroundColor
        popupController?.delegate = nil
        popupController?.present(animated: true)
        
    }
    
    /// 自定义弹出视图
    ///
    /// - Parameters:
    ///   - titles: 要显示的 title: ["xxx",""]
    ///   - callback: 
    func showActionSheet(titles: [String], callback: @escaping (_ index: Int, _ title: String)->Void) -> Void {
        
        var popupController: CNPPopupController?
        let screenWith = UIScreen.main.bounds.width
        var popContents: [AnyObject] = []
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
        titleLabel.numberOfLines = 0;
        popContents.append(titleLabel)
        
        for (index, title) in titles.enumerated(){
            
            if index > 0 {
                let lineView = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
                lineView.backgroundColor = UIColor(hexString: "CCCCCC")
                
                popContents.append(lineView)
            }
            let phoneNumberButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
            phoneNumberButton.setTitle(title, for: UIControlState())
            phoneNumberButton.setTitleColor(UIColor.black, for: UIControlState())
            // weixinButton.setImage(UIImage(named: "wechat"), forState: UIControlState.Normal)
            //		phoneNumberButton.layer.cornerRadius = 5
            phoneNumberButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            phoneNumberButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            phoneNumberButton.backgroundColor = UIColor.white
            phoneNumberButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            phoneNumberButton.selectionHandler = { (button) in
                popupController?.dismiss(animated: true)
                callback(index, title)
            }
            
            popContents.append(phoneNumberButton)
        }
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 12))
        lineView2.backgroundColor = UIColor.clear
        
        popContents.append(lineView2)
        
        let closeButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
        closeButton.setTitle("取消", for: UIControlState())
        
        closeButton.setTitleColor(CMCColor.hlightedButtonBackgroundColor, for: UIControlState())
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        closeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        closeButton.backgroundColor = UIColor.white
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.selectionHandler = { (button) in
            popupController?.dismiss(animated: true)
        }
        
        popContents.append(closeButton)
        
        popupController = CNPPopupController(contents: popContents)
        
        popupController?.theme = CNPPopupTheme.default()
        popupController?.theme.popupStyle = CNPPopupStyle.actionSheet
        popupController?.theme.presentationStyle = CNPPopupPresentationStyle.fadeIn
        popupController?.theme.popupContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        popupController?.theme.contentVerticalPadding = 0
        popupController?.theme.backgroundColor = UIColor.clear //SHConstants.ActionViewBgColor // UIConstants.TableViewBackgroundColor
        popupController?.delegate = nil
        popupController?.present(animated: true)
    }
    //shippingList: [[String: AnyObject]]
    func showShippingListPopupView(shippingList: [[String: AnyObject]],
                                   callback: @escaping (_ index: Int, _ title: String)->Void) -> Void {
        
        
        var popupController: CNPPopupController?
        let screenWith = UIScreen.main.bounds.width
        var popContents: [AnyObject] = []
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
        titleLabel.numberOfLines = 0;
        popContents.append(titleLabel)
        
        for (index, itemDict) in shippingList.enumerated(){
            
            if index > 0 {
                let lineView = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 1))
                lineView.backgroundColor = UIColor(hexString: "CCCCCC")
                popContents.append(lineView)
            }
            
            let title: String = itemDict["name"] as! String
            var shippingType: Int? =  itemDict["value"] as? Int
            if shippingType == nil {
                shippingType = (itemDict["value"] as! String).toInt() ?? 0
            }
            
            let phoneNumberButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
            phoneNumberButton.setTitle(title, for: UIControlState())
            phoneNumberButton.setTitleColor(UIColor.black, for: UIControlState())
            // weixinButton.setImage(UIImage(named: "wechat"), forState: UIControlState.Normal)
            //		phoneNumberButton.layer.cornerRadius = 5
            phoneNumberButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            phoneNumberButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            phoneNumberButton.backgroundColor = UIColor.white
            phoneNumberButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            phoneNumberButton.selectionHandler = { (button) in
                popupController?.dismiss(animated: true)
                callback(index, title)
            }
            popContents.append(phoneNumberButton)
            
            // 捎货物流配送
            if shippingType == ORDER_SHIPPING_TYPE_SH {
                
                let distance = (itemDict["distance"] as? String)?.toDouble() ?? 0
                let fee = itemDict["fee"] as! Double //(itemDict["fee"] as? String)?.toDouble() ?? 0
                let tips = itemDict["tips"] as? String
                
                let tmpLabelFrame = CGRect(x: 0, y: 0, width: screenWith, height: 30)
                
                let distanceBackgroundView = UIView(frame: tmpLabelFrame)
                distanceBackgroundView.backgroundColor = CMCColor.loginViewBackgroundColor
                
                let distanceLabel = UILabel(frame: tmpLabelFrame.insetBy(dx: 14, dy: 5))
                distanceLabel.text = "配送距离：\(distance)公里"
                distanceLabel.font = UIFont.systemFont(ofSize: 15)
                distanceLabel.textColor = UIColor(hexString: "333333")
                distanceBackgroundView.addSubview(distanceLabel)
                
                popContents.append(distanceBackgroundView)
                
                let feeBackgroundView = UIView(frame: tmpLabelFrame)
                feeBackgroundView.backgroundColor = CMCColor.loginViewBackgroundColor
                
                let feeLabel = UILabel(frame: tmpLabelFrame.insetBy(dx: 14, dy: 5))
                feeLabel.text = "捎货费用：\(String(format: "￥%.2f元", fee*0.01))"
                feeLabel.font = UIFont.systemFont(ofSize: 15)
                feeLabel.textColor = UIColor(hexString: "333333")
                feeBackgroundView.addSubview(feeLabel)
                
                popContents.append(feeBackgroundView)
                
                let tipsBackgroundView = UIView(frame: tmpLabelFrame)
                tipsBackgroundView.backgroundColor = CMCColor.loginViewBackgroundColor
                
                let tipsLabel = UILabel(frame: tmpLabelFrame.insetBy(dx: 14, dy: 5))
                tipsLabel.text = "(\(tips ?? ""))"
                tipsLabel.font = UIFont.systemFont(ofSize: 12)
                tipsLabel.textColor = UIColor(hexString: "333333")
                tipsLabel.numberOfLines = 0
                tipsLabel.fitHeight()
                tipsBackgroundView.addSubview(tipsLabel)
                
                tipsBackgroundView.h = tipsLabel.h + 15
                
                popContents.append(tipsBackgroundView)
            }
        }
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 12))
        lineView2.backgroundColor = UIColor.clear
        
        popContents.append(lineView2)
        
        let closeButton = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 51))
        closeButton.setTitle("取消", for: UIControlState())
        
        closeButton.setTitleColor(CMCColor.hlightedButtonBackgroundColor, for: UIControlState())
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        closeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        closeButton.backgroundColor = UIColor.white
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.selectionHandler = { (button) in
            popupController?.dismiss(animated: true)
        }
        
        popContents.append(closeButton)
        
        popupController = CNPPopupController(contents: popContents)
        
        popupController?.theme = CNPPopupTheme.default()
        popupController?.theme.popupStyle = CNPPopupStyle.actionSheet
        popupController?.theme.presentationStyle = CNPPopupPresentationStyle.fadeIn
        popupController?.theme.popupContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        popupController?.theme.contentVerticalPadding = 0
        popupController?.theme.backgroundColor = UIColor.clear //SHConstants.ActionViewBgColor // UIConstants.TableViewBackgroundColor
        popupController?.delegate = nil
        popupController?.present(animated: true)
    }
    
}
