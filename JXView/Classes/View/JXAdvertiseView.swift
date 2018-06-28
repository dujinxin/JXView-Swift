//
//  JXAdvertiseView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/13.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

class JXAdvertiseView: UIView {

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        //iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("5", for: .normal)
        button.frame = CGRect(origin: CGPoint(), size: CGSize(width: 40, height: 40))
        //button.sizeToFit()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(touchDismiss), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    var adTimer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        self.imageView.frame = bounds
        self.enterButton.frame = CGRect(x: kScreenWidth - 60, y: 20, width: 40, height: 40)
        addSubview(self.imageView)
        addSubview(self.enterButton)
        
        
        self.imageView.image = UIImage(named: "guide_2")
        
        if #available(iOS 10.0, *) {
            self.adTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                if
                    let numberStr = self.enterButton.currentTitle,
                    var number = Int(numberStr),
                    number > 1
                {
                    number -= 1
                    self.enterButton.setTitle("\(number)", for: .normal)
                }else{
                    self.touchDismiss()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func touchDismiss() {
        
        self.adTimer?.invalidate()
        /// animate 放大动画，消失
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
            
        }) { (finished) in
            self.removeAllSubView()
            self.removeFromSuperview()
        }
    }
    deinit {
        print("广告页销毁")
    }
}
