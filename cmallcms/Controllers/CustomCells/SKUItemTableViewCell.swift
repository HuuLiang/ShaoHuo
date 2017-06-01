//
//  SKUItemTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class SKUItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skuItemImageView: UIImageView!
    
    @IBOutlet weak var skuItemNameLabel: UILabel!
    
    @IBOutlet weak var skuItemCountLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var skuItemEntity: SKUItemEntity? {
        didSet {
            self.skuItemImageView.sd_setImage(with: URL(string: skuItemEntity?.goods_img ?? ""))
            self.skuItemNameLabel.text = skuItemEntity?.goods_name ?? ""
            self.skuItemCountLabel.text = "x\((skuItemEntity?.goods_number ?? 0))"
            
            let totalAmount = skuItemEntity!.amout! * 0.01
            self.priceLabel.text = String(format: "￥%.2f", totalAmount)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 113)
    }
}
