//
//  PushNotificationHelp.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

struct PushNotificationHelp {

    static func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) -> Void {
        
        if UserTicketModel.sharedInstance.isLogin == false {
            return
        }
        
        let dicData = userInfo as? [String : AnyObject]
        let aps = dicData?["aps"] as? [String : AnyObject]
        
        if let title = aps?["alert"] as? String {
            log.info("title: \(title)")
        }
        
        let badge = aps?["badge"] as? Int
        log.info("badge: \(String(describing: badge ?? 0))")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as? UITabBarController
        
        let homeTabbarItem: UITabBarItem? = rootViewController?.tabBar.items?[0]
        let messageTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[1]
        
        
//        if let badgeValue = homeTabbarItem?.badgeValue?.toInt() {
//            homeTabbarItem?.badgeValue = "\(badgeValue + (badge ?? 0))"
//        }
//        else {
//            homeTabbarItem?.badgeValue = "\(String(describing: badge ?? 0))"
//        }
        
        if let badgeValue = messageTabBarItem?.badgeValue?.toInt() {
            messageTabBarItem?.badgeValue = "\(badgeValue + (badge ?? 0))"
        }
        else {
            messageTabBarItem?.badgeValue = "\(String(describing: badge ?? 0))"
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
