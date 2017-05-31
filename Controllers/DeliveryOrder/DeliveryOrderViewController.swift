//
//  DeliveryOrderViewController.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class DeliveryOrderViewController: UIViewController {
    
    /// 捎货物流
    @IBOutlet weak var shaohuoShippingView: UIView!
    @IBOutlet weak var shaohuoShippingButton: UIButton!
    @IBOutlet weak var shaohuoShippingDistanceLabel: UILabel!
    @IBOutlet weak var shaohuoFeeLabel: UILabel!
    @IBOutlet weak var shaohuoTipLabel: UILabel!
    
    @IBOutlet weak var shaohuoShippingViewTopConstraint: NSLayoutConstraint!
    
    /// 其它物流
    @IBOutlet weak var otherShippingView: UIView!
    @IBOutlet weak var otherShippingButton: UIButton!
    @IBOutlet weak var otherExpressNameTextField: UITextField!
    @IBOutlet weak var otherExpressSNTextField: UITextField!

    @IBOutlet weak var otherShippingViewTopConstraint: NSLayoutConstraint!
    
    
    /// 自提
    @IBOutlet weak var shippingSelfView: UIView!
    @IBOutlet weak var shippingSelfButton: UIButton!
    
    @IBOutlet weak var shippingSelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // 支持的物流列表信息 1：捎货物流，2：其它物流，3：自提，4：送货上门 value: 1, name:捎货物流
    var shippingList: [[String: AnyObject]] = []
    // 是否有捎货物流配送
    //var hasShipping_type_sh: Bool = false
    // 选中了捎货物流配送
    //var selectedShipping_type_sh: Bool = false
    /// 返回结果
    var selectedShippingTypeCallback: ((_ shippingType: Int, _ expressName: String, _ expressId: String) -> Void)?
    
    /// 取消选择
    //var cancelShippingTypeCallback: ((Void) -> Void)?
    
    var currentSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        
        self.saveButton.layer.cornerRadius = 3
        self.saveButton.layer.masksToBounds = true
        self.saveButton.addTarget(self,
                                  action: #selector(DeliveryOrderViewController.saveButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        
        self.cancelButton.layer.cornerRadius = 3
        self.cancelButton.layer.masksToBounds = true
        self.cancelButton.layer.borderColor = UIColor(hexString: "9c9c9c")?.cgColor
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.addTarget(self,
                                    action: #selector(DeliveryOrderViewController.cancelButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        
        self.otherExpressNameTextField.limitTextLength(32)
        self.otherExpressSNTextField.limitTextLength(64)
        
        self.shaohuoShippingButton.addTarget(self,
                                             action: #selector(DeliveryOrderViewController.shippingTypeButtonPressed(sender:)),
                                             for: UIControlEvents.touchUpInside)
        
        self.otherShippingButton.addTarget(self,
                                           action: #selector(DeliveryOrderViewController.shippingTypeButtonPressed(sender:)),
                                           for: UIControlEvents.touchUpInside)
        
        self.shippingSelfButton.addTarget(self,
                                          action: #selector(DeliveryOrderViewController.shippingTypeButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showShippingSelectedView()
    }
    
    
    func showShippingSelectedView() {
        
        var orignX: CGFloat = 64
        var delay: TimeInterval = 0
        
        for (index ,itemDict) in shippingList.enumerated() {
            
            let title: String = itemDict["name"] as! String
            var shippingType: Int? =  itemDict["value"] as? Int
            if shippingType == nil {
                shippingType = (itemDict["value"] as! String).toInt() ?? 0
            }
            // 捎货物流配送
            if shippingType == ORDER_SHIPPING_TYPE_SH {
                //self.hasShipping_type_sh = true
                let distance = (itemDict["distance"] as? String)?.toDouble() ?? 0
                let fee = itemDict["fee"] as! Double //(itemDict["fee"] as? String)?.toDouble() ?? 0
                let tips = itemDict["tips"] as? String
                
                self.shaohuoShippingButton.setTitle(title, for: UIControlState.normal)
                self.shaohuoShippingButton.setTitle(title, for: UIControlState.selected)
                
                self.shaohuoShippingDistanceLabel.text = "配送距离：\(distance)公里"
                self.shaohuoFeeLabel.text = "捎货费用：\(String(format: "￥%.2f元", fee*0.01))"
                self.shaohuoTipLabel.text = "(\(tips ?? ""))"
                
                self.shaohuoShippingButton.tag = index
                self.shaohuoShippingButton.isSelected = index == 0
                
                self.shaohuoShippingViewTopConstraint.constant = orignX
                
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }) {(isDone) in
                
                }
                
                delay += 0.3
                orignX += self.shaohuoShippingView.h + 14
            }
            // 自提
            else if shippingType == ORDER_SHIPPING_TYPE_SELF {
                
                self.shippingSelfButton.setTitle(title, for: UIControlState.normal)
                self.shippingSelfButton.setTitle(title, for: UIControlState.selected)
                self.shippingSelfButton.tag = index
                self.shippingSelfButton.isSelected = index == 0
                
                self.shippingSelTopConstraint.constant = orignX
                
                UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }) {(isDone) in
                    
                }
                
                delay += 0.3
                orignX += self.shippingSelfView.h + 14
            }
            else {
                self.otherShippingButton.setTitle(title, for: UIControlState.normal)
                self.otherShippingButton.setTitle(title, for: UIControlState.selected)
                self.otherShippingButton.tag = index
                self.otherShippingButton.isSelected = index == 0
                
                self.otherShippingViewTopConstraint.constant = orignX
                
                UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }) {(isDone) in
                    
                }
                
                delay += 0.3
                orignX += self.shippingSelfView.h + 14
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func shippingTypeButtonPressed(sender: UIButton) -> Void {
        self.currentSelectedIndex = sender.tag
        
        for item in [self.shaohuoShippingButton, self.otherShippingButton, self.shippingSelfButton] {
            if item?.tag == self.currentSelectedIndex {
                item?.isSelected = true
            }
            else {
                item?.isSelected = false
            }
        }
    }
    
    func cancelButtonPressed(sender: UIButton?) -> Void {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveButtonPressed(sender: UIButton?) -> Void {
        
        if currentSelectedIndex < 0 {
            return
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
        
        let itemDict = shippingList[self.currentSelectedIndex]
        
        let title: String = itemDict["name"] as! String
        var shippingType: Int? =  itemDict["value"] as? Int
        if shippingType == nil {
            shippingType = (itemDict["value"] as! String).toInt() ?? 0
        }
        
        if shippingType == ORDER_SHIPPING_TYPE_SH || shippingType == ORDER_SHIPPING_TYPE_SELF {
            self.selectedShippingTypeCallback?(shippingType!, title, "")
        }
        else {
            self.selectedShippingTypeCallback?(shippingType!,
                                              self.otherExpressNameTextField.text ?? "",
                                              self.otherExpressSNTextField.text ?? "")
        }
    }
    
}
