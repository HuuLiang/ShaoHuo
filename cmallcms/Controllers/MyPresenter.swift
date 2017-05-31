//
//  MyPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import EZSwiftExtensions

final class MyPresenter: Presenter {
    
    var shopInfo: [String : AnyObject]?
    
    func getUserShopInfo() {
        
        let _ = _view.showHUDLoadView()
        
        self.interactor.getUserShopInfoFromServer()
    }
    
    func responseShopInfo(result: [String : AnyObject]?, error: CMCError?) {
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
            case .responseError(let code, let message):
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    _view.showErrorHUDView(errorString: message)
                }
            }
        }
        else {
            _view.hidHUDView()
            self.shopInfo = result
            view.finishedLoader()
        }
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MyPresenter {
    var view: MyViewInterface {
        return _view as! MyViewInterface
    }
    var interactor: MyInteractor {
        return _interactor as! MyInteractor
    }
    var router: MyRouter {
        return _router as! MyRouter
    }
}
