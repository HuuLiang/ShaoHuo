//
//  UserInterfaceExtensions.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UserInterface {
    
    func showHUDLoadView() -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        hud.label.text = "加载中..."
        return hud
    }
    
    func hidHUDView() {
        for item in self.view.subviews {
            if item.isKind(of: MBProgressHUD.classForCoder()) {
                (item as! MBProgressHUD).hide(animated: true)
            }
        }
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
        
        var tmpHud: MBProgressHUD? = getViewFirstHudView()
        if tmpHud == nil {
            tmpHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        tmpHud!.mode = MBProgressHUDMode.text
        tmpHud!.label.text = messageString
        tmpHud!.detailsLabel.text = ""
        tmpHud!.hide(animated: true, afterDelay: 1.5)
    }
    
    func showErrorHUDView(errorString: String) {
        
        var tmpHud: MBProgressHUD? = getViewFirstHudView()
        if tmpHud == nil {
            tmpHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        tmpHud!.mode = MBProgressHUDMode.text
        tmpHud!.label.text = "错误"
        tmpHud!.detailsLabel.text = errorString
        tmpHud!.hide(animated: true, afterDelay: 1.5)
    }
}
