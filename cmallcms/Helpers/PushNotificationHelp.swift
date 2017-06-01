//
//  PushNotificationHelp.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

struct PushNotificationHelp {

    static func didReceiveRemoteNotification(userInfo: [AnyHashable : Any], needShowOrderDetailView: Bool = false) -> Void {
        
        if UserTicketModel.sharedInstance.isLogin == false {
            return
        }
        
        let dicData = userInfo as? [String : AnyObject]
        let aps = dicData?["aps"] as? [String : AnyObject]
        
        if let title = aps?["alert"] as? String {
            log.info("title: \(title)")
        }
        
        var badge = aps?["badge"] as? Int
        log.info("badge: \(String(describing: badge ?? 0))")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as? UITabBarController
        
        let messageTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[1]
        
        if badge == nil {
            badge = 1
        }
        
        if let badgeValue = messageTabBarItem?.badgeValue?.toInt() {
            messageTabBarItem?.badgeValue = "\(badgeValue + (badge ?? 0))"
        }
        else {
            messageTabBarItem?.badgeValue = "\(String(describing: badge ?? 0))"
        }
        
        if needShowOrderDetailView {
            if let order_id = dicData?["order_id"] {
                if let navigationController: UINavigationController = rootViewController?.viewControllers?[0] as? UINavigationController {
                    
                    let detailModel = Module.build("OrderDetail")
                    detailModel.router.showDetail(from: navigationController, setupData: order_id)
                }
            }
        }
    }
    
    /// 清楚 badgeValue
    ///
    /// - Parameter tabBarItem:
    static func cleanBadgeValue(tabBarItem: UITabBarItem? = nil) {
        tabBarItem?.badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
