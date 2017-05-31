//
//  MyView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import SDWebImage

//MARK: - Public Interface Protocol
protocol MyViewInterface {
    
    func finishedLoader()
}

//MARK: My View
final class MyView: UserInterface {
    
    var tableView: UITableView!
    
    let cellIdentifier = "CellIdentifer"
    
    var headerImageView: UIImageView?
    var shopNameLabel: UILabel?
    var shopAddressLabel: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBar()
        self.configTableView()
        self.configTableViewHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getShopInfo()
    }
    
    func configNavigationBar() {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: UIColor.clear)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "我",
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: nil,
                                                                action: nil)
        
        let logoOutButton = UIButton(type: UIButtonType.custom)
        logoOutButton.setImage(UIImage(named:"icon_logout"), for: UIControlState.normal)
        logoOutButton.setTitle(" 退出登录", for: UIControlState.normal)
        logoOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        logoOutButton.titleLabel?.textColor = UIColor.white
        logoOutButton.addTarget(self, action: #selector(MyView.logoButtonPressed),
                                for: UIControlEvents.touchUpInside)
        logoOutButton.frame = CGRect(x: 0, y: 0, w: 80, h: 30)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoOutButton)
        
    }
    
    func configTableView() -> Void {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mas_makeConstraints { (make) in
            let _ = make?.top.equalTo()(-64)
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.bottom.equalTo()(0)
        }
        
        
    }
    
    func configTableViewHeaderView() -> Void {
        let headView = UIView(frame: CGRect(x: 0, y: 0, w: self.view.w, h: 150))
        tableView.tableHeaderView = headView
        
        headView.cmc_addGradientLayer(colors: CMCColor.navbarGradientColor,
                                      startPoint: CGPoint(x: 0, y: 0),
                                      endPoint: CGPoint(x: 1, y: 0),
                                      locations: [0, 0.65, 1.0])
        // 74
        
        let headerBackgroundImageView = UIImageView()
        headerBackgroundImageView.image = UIImage(named: "icon_my_header_bg")
        headView.addSubview(headerBackgroundImageView)
        
        headerBackgroundImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.bottom.equalTo()(-12)
            let _ = make?.width.equalTo()(74)
            let _ = make?.height.equalTo()(74)
        }
        
        headerImageView = UIImageView()
        headerImageView?.backgroundColor = UIColor.blue
        headView.addSubview(headerImageView!)
        headerImageView!.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(16)
            let _ = make?.bottom.equalTo()(-14)
            let _ = make?.width.equalTo()(70)
            let _ = make?.height.equalTo()(70)
        }
        headerImageView!.layer.cornerRadius = 35
        headerImageView!.layer.masksToBounds = true
        
        shopNameLabel = UILabel()
        headView.addSubview(shopNameLabel!)
        shopNameLabel?.textColor = UIColor.white
        shopNameLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        shopNameLabel?.text = UserTicketModel.sharedInstance.username ?? ""
        
        shopNameLabel!.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(headerBackgroundImageView.mas_right)?.setOffset(14)
            let _ = make?.top.equalTo()(headerBackgroundImageView.mas_top)?.setOffset(10)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
        }
        
        shopAddressLabel = UIButton(type: UIButtonType.custom)
        shopAddressLabel?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //shopAddressLabel?.titleLabel?.textAlignment = NSTextAlignment.left
        shopAddressLabel?.setTitleColor(UIColor.white, for: UIControlState.normal)
        shopAddressLabel?.setTitle("----", for: UIControlState.normal)
        shopAddressLabel?.setImage(UIImage(named:"icon_location"), for: UIControlState.normal)
        headView.addSubview(shopAddressLabel!)
        shopAddressLabel?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
        //shopAddressLabel?.backgroundColor = UIColor.red
        shopAddressLabel?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        shopAddressLabel!.mas_makeConstraints({ (make) in
            let _ = make?.left.equalTo()(headerBackgroundImageView.mas_right)?.setOffset(14)
            let _ = make?.top.equalTo()(self.shopNameLabel!.mas_bottom)?.setOffset(18)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
        })
    }
    
    func logoButtonPressed() -> Void {
        
        self.showActionSheet(titles: ["确定退出"]) {
            (_, _) in
            
            UserTicketModel.sharedInstance.logout()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLoginViewController()
        }
    }
    
    func getShopInfo() {
        self.presenter.getUserShopInfo()
    }
    
    func setShopInfo() {
        
        if let logo = self.presenter.shopInfo?["logo"] {
            headerImageView?.sd_setImage(with: URL(string: logo as! String))
        }
        
        if let shop_address = self.presenter.shopInfo?["shop_address"] {
            shopAddressLabel?.setTitle(shop_address as? String, for: UIControlState.normal)
        }
        self.tableView.reloadData()
    }
}

//MARK: - Public interface
extension MyView: MyViewInterface {
    
    func finishedLoader() {
        self.setShopInfo()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MyView {
    var presenter: MyPresenter {
        return _presenter as! MyPresenter
    }
    var displayData: MyDisplayData {
        return _displayData as! MyDisplayData
    }
}

extension MyView : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor(hexString: "333333")
        }
        
        if indexPath.row == 0 {
            cell?.imageView?.image = UIImage(named: "icon_my_shop")
            
            if let shop_name = self.presenter.shopInfo?["shop_name"] {
                cell?.textLabel?.text = "店铺名称：\(shop_name)"
            }
            else {
                cell?.textLabel?.text = "店铺名称："
            }
            
        }
        if indexPath.row == 1 {
            cell?.imageView?.image = UIImage(named: "icon_my_phone")
            cell?.textLabel?.text = "联系方式：\(UserTicketModel.sharedInstance.mobile_phone ?? "")"
        }
        if indexPath.row == 2 {
            cell?.imageView?.image = UIImage(named: "icon_my_worktime")
            
            if let business_time = self.presenter.shopInfo?["business_time"] {
                //let business_end_time = self.presenter.shopInfo?["business_end_time"] as? String
                
                cell?.textLabel?.text = "营业时间：\(business_time)"
            }
            else {
                cell?.textLabel?.text = "营业时间："
            }
           
        }
        if indexPath.row == 3 {
            cell?.imageView?.image = UIImage(named: "icon_my_addr")
            
            if let shop_address = self.presenter.shopInfo?["shop_address"] {
                cell?.textLabel?.text = "店铺地址：\(shop_address)"
            }
            else {
                cell?.textLabel?.text = "店铺地址："
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
