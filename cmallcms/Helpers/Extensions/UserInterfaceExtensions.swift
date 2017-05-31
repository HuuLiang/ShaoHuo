//
//  UserInterfaceExtensions.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD

extension UserInterface {
    
//    open override class func initialize() {
//        
//    }
    
    func showHUDLoadView() -> Void {
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.removeFromSuperViewOnHide = true
//        hud.label.text = "加载中..."
//        return hud
        
        SVProgressHUD.show(withStatus: "加载中...")
    }
    
    func hidHUDView() {
//        for item in self.view.subviews {
//            if item.isKind(of: MBProgressHUD.classForCoder()) {
//                (item as! MBProgressHUD).hide(animated: true)
//            }
//        }
        SVProgressHUD.dismiss()
    }
    
    private func getViewFirstHudView() -> MBProgressHUD? {
        for item in self.view.subviews {
            if item.isKind(of: MBProgressHUD.classForCoder()) {
                 return (item as! MBProgressHUD)
            }
        }
        return nil
    }
    
    func showSuccessHUDView(messageString: String) {
        /*
        var tmpHud: MBProgressHUD? = getViewFirstHudView()
        if tmpHud == nil {
            tmpHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        tmpHud!.mode = MBProgressHUDMode.text
        tmpHud!.label.text = messageString
        tmpHud!.detailsLabel.text = ""
        tmpHud!.hide(animated: true, afterDelay: 1.5)*/
        SVProgressHUD.showSuccess(withStatus: messageString)
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    
    func showErrorHUDView(errorString: String) {
        /*
        var tmpHud: MBProgressHUD? = getViewFirstHudView()
        if tmpHud == nil {
            tmpHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        tmpHud!.mode = MBProgressHUDMode.text
        tmpHud!.label.text = "错误"
        tmpHud!.detailsLabel.text = errorString
        tmpHud!.hide(animated: true, afterDelay: 1.5)
         */
        SVProgressHUD.showError(withStatus: errorString)
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
}