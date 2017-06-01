//
//  HomeInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import EZSwiftExtensions
//import Viperit

final class HomeInteractor: Interactor {
    
    /// 订单列表
    ///
    /// - Parameters:
    ///   - pageListParam:
    ///   - status: status == 6 退款订单
    ///   - searchText:
    /// - Returns:
    func getOrderListFromServer(pageListParam: PageListModel,status: Int, searchText: String = "") -> URLSessionDataTask? {
        
        let params = [
                "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
                "token": UserTicketModel.sharedInstance.token ?? "",
                "status": "\(status)",
                "search_text": searchText,
                "size": "\(pageListParam.size)",
                "from": pageListParam.from,
                "is_support": status == 6 ? "1" : "0",
                "last": pageListParam.last
                      ]
        
        return OrderListModel.shared.orderList(params) { (result, error) in
            self.presenter.responseOrderList(result: result, error: error)
        }
    }
    
    func cancelOrder(orderId: String) -> URLSessionDataTask? {
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "order_id": orderId
        ]
        
        return OrderListModel.shared.cancelOrder(params) { (result, error) in
            self.presenter.responseOrderCancel(error: error)
        }
    }
    
    func deliveryOrder(orderId: String, shipping_type: Int, express_name: String, shipping_id: String) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "order_id": orderId,
            "shipping_type": "\(shipping_type)",
            "express_name": express_name,
            "shipping_id": shipping_id
        ]
        
        return OrderListModel.shared.orderDelivery(params) { (result, error) in
            self.presenter.responseOrderDelivery(error: error)
        }
    }
    
    /// 提交设备信息到服务器
    func postUserDeviceInfoToServer() {
        let params = [
            "token": UserTicketModel.sharedInstance.token ?? "",
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "app_version": ez.appVersionAndBuild ?? "",
            "device_name": UIDevice.deviceName(),
            "device_version": UIDevice.CURRENT_VERSION,
            "device_mode": UIDevice.deviceModel(),
            "mobile_type": "1"
        ]
        
        UserLoginModel.shared.postUserDeviceInfo(params) { (error) in
            
            if let tmpError = error {
                switch tmpError {
                case .jsonSerializedFailed, .verifyTextFieldError(_):
                    log.error("jsonSerializedFailed")
                case .responseError(let code,let message):
                    log.error("code: \(code) message: \(message)")
                }
            }
            else {
                log.info("UserLoginModel.shared.postUserDeviceInfo Done .....")
            }
        }
    }
    
    func getOrderShippingList(orderId: String) -> Void {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "order_id": orderId,
        ]
        
        OrderListModel.shared.orderShippingList(params: params) { (result, error) in
            self.presenter.responseOrderShippingList(result: result, error: error)
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension HomeInteractor {
    var presenter: HomePresenter {
        return _presenter as! HomePresenter
    }
}
