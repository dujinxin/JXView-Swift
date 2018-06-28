//
//  JXAdditionView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/8/10.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

private let tableViewCellHeight : CGFloat = 44
private let tableViewCellWidth : CGFloat = 140
private let animateDuration : TimeInterval = 0.3

class JXAdditionView: UIView {
    
    private var selectViewHeight : CGFloat = tableViewCellHeight
    private var selectViewTop : CGFloat = 10
    var selectRow : Int = -1

    var delegate : JXAdditionViewDelegate?
    var dataSource : JXAdditionViewDataSource?
    /// 箭头端点坐标
    var arrowPoint: CGPoint = CGPoint() {
        didSet{
            self.resetFrame()
        }
    }
    lazy var tableView : AdditionTableView = {
        let table = AdditionTableView.init(frame: CGRect.init(), style: .plain)
        table.backgroundColor = UIColor.clear
        //table.alpha = 0.7
        //table.clipsToBounds = true
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        //table.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return table
    }()

    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindowLevelAlert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    lazy private var bgView : UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.alpha = 0
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        view.addGestureRecognizer(tap)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectViewHeight = frame.height
    }
    func resetFrame(height:CGFloat = 0.0) {
        
        let num = self.dataSource?.jxAdditionView(self, numberOfRowsInSection: 0) ?? 0
        var h : CGFloat = CGFloat(num) * tableViewCellHeight

        h += selectViewTop
        selectViewHeight = h
        let x = arrowPoint.x > 200 ? (kScreenWidth - 5) : 5
        
        self.frame = CGRect(origin: CGPoint(x: x, y: arrowPoint.y), size: CGSize(width: 0.01, height: h))
        
        if
            let heightConstraint = contentViewHeightConstraint,
            let widthConstraint = contentViewWidthConstraint{
            heightConstraint.isActive = false
            widthConstraint.isActive = false
            self.removeConstraint(heightConstraint)
            self.removeConstraint(widthConstraint)
        }
        self.contentViewHeightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.contentViewWidthConstraint = NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)

        self.contentViewWidthConstraint?.isActive = true
        self.contentViewHeightConstraint?.isActive = true
       
    }
    var contentViewHeightConstraint : NSLayoutConstraint?
    var contentViewWidthConstraint : NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateC()
    }
    func updateTableConstraints(isUnfold:Bool = false) {
        if
            let heightConstraint = contentViewHeightConstraint,
            let widthConstraint = contentViewWidthConstraint{
            heightConstraint.isActive = false
            widthConstraint.isActive = false
            self.removeConstraint(heightConstraint)
            self.removeConstraint(widthConstraint)
        }
        self.contentViewHeightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: isUnfold == false ? 0 : self.bounds.height)
        self.contentViewWidthConstraint = NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: isUnfold == false ? 0 : self.bounds.width)
        
        self.contentViewWidthConstraint?.isActive = true
        self.contentViewHeightConstraint?.isActive = true
    }
    func updateC() {
        addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        addConstraint(contentViewWidthConstraint!)
        addConstraint(contentViewHeightConstraint!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        self.show(inView: self.bgWindow)
    }
    
    func show(inView view:UIView? ,animate:Bool = true) {
        
        self.resetFrame(height: selectViewHeight)
        self.addSubview(self.tableView)
        
        subviews.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
  
        let superView : UIView
        
        if let v = view {
            superView = v
        }else{
            superView = self.bgWindow
        }
        
        superView.addSubview(self.bgView)
        superView.addSubview(self)
        
        superView.isHidden = false
        if
            let heightConstraint = contentViewHeightConstraint,
            let widthConstraint = contentViewWidthConstraint{
            heightConstraint.isActive = false
            widthConstraint.isActive = false
            
        }
        self.contentViewHeightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.bounds.height)
        self.contentViewWidthConstraint = NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tableViewCellWidth)
        self.contentViewWidthConstraint?.isActive = true
        self.contentViewHeightConstraint?.isActive = true
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: [], animations: {
                self.bgView.alpha = 0.5
                self.layoutIfNeeded()
             
            }, completion: { (finished) in
                let rect = self.frame
                let x = self.arrowPoint.x > tableViewCellWidth ? (kScreenWidth - (5 + tableViewCellWidth)) : 5
                self.frame = CGRect(origin: CGPoint(x: x, y: self.arrowPoint.y), size: CGSize(width: tableViewCellWidth, height: rect.height))
                
                self.tableView.reloadData()
            })
        }
    }
    func dismiss(animate:Bool = true) {
        if
            let heightConstraint = contentViewHeightConstraint,
            let widthConstraint = contentViewWidthConstraint{
            heightConstraint.isActive = false
            widthConstraint.isActive = false
            
        }
        self.contentViewHeightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.contentViewWidthConstraint = NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.contentViewWidthConstraint?.isActive = true
        self.contentViewHeightConstraint?.isActive = true
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: [], animations: {
                self.bgView.alpha = 0.0
                self.layoutIfNeeded()
            }, completion: { (finished) in
                if finished {
                    self.clearInfo()
                }
            })
        }else{
            self.clearInfo()
        }
    }
    
    fileprivate func clearInfo() {
        bgView.removeFromSuperview()
        self.removeFromSuperview()
        bgWindow.isHidden = true
    }
    @objc private func tapClick() {
        self.dismiss()
    }
    fileprivate func viewDisAppear(row:Int) {
        if self.delegate != nil && selectRow >= 0{
            self.delegate?.jxAdditionView(self, didSelectRowAt: row)
        }
        self.dismiss()
    }
}

extension JXAdditionView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataSource != nil) {
            return dataSource?.jxAdditionView(self, numberOfRowsInSection: section) ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource != nil {
            return dataSource?.jxAdditionView(self, heightForRowAt: indexPath.row) ?? tableViewCellHeight
        }
        return tableViewCellHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        //let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if cell == nil {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.layer.cornerRadius = 5.0
            cell?.backgroundColor = self.tableView.backgroundImageColor//UIColor.clear
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.numberOfLines = 1
        }

        cell?.textLabel?.text = dataSource?.jxAdditionView(self, contentForRow: indexPath.row, InSection: indexPath.section)

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        self.viewDisAppear(row: indexPath.row)
        self.dismiss(animate: true)
    }
}

@objc protocol JXAdditionViewDataSource {
    
    func jxAdditionView(_ :JXAdditionView, numberOfRowsInSection section:Int) -> Int
    func jxAdditionView(_ :JXAdditionView, heightForRowAt row:Int) -> CGFloat
    func jxAdditionView(_ :JXAdditionView, contentForRow row:Int, InSection section:Int) -> String

    func jxAdditionView(_ :JXAdditionView, widthForComponent component: Int) -> CGFloat

    
}
protocol JXAdditionViewDelegate {
    
    func jxAdditionView(_ :JXAdditionView, didSelectRowAt row:Int)
}

class AdditionTableView: UITableView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var rect1 = rect
        rect1.size.height -= 10
        rect1.origin.y += 10
        
        backgroundImageColor.setFill()
      
        let path1 = UIBezierPath()
        
        path1.move(to: CGPoint(x: rect.width - (20 + 10), y: rect.origin.y + 10))
        path1.addLine(to: CGPoint(x: rect.width - 20, y: rect.origin.y))
        path1.addLine(to: CGPoint(x: rect.width - (20 - 10), y: rect.origin.y + 10))
        path1.close()
        
        let path2 = UIBezierPath(roundedRect: rect1, cornerRadius: 5)
        path2.append(path1)
        path2.fill()
        
        path2.addClip()
        
    }
    /// 箭头端点坐标
    var backgroundImageColor: UIColor = .white {
        didSet{
            self.layoutIfNeeded()
        }
    }
    /// 箭头端点坐标
    var arrowPoint: CGPoint = CGPoint() {
        didSet{
            self.layoutIfNeeded()
        }
    }
    
}
