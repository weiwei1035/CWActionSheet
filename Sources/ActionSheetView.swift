//
//  ActionSheetView.swift
//  CWActionSheetDemo
//
//  Created by chenwei on 2017/8/31.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

private let kScreenHeight = UIScreen.main.bounds.height
private let kScreenWidth = UIScreen.main.bounds.width

public typealias ActionSheetClickedHandler = ((ActionSheetView, Int) -> Void)

public class ActionSheetView: UIView {

    // MARK: 属性
    /// 
    public var title: String?
    ///
    public var cancelButtonTitle: String?
    
    public var titleColor: UIColor
    
    public var buttonColor: UIColor
    
    public var titleFont: UIFont
    
    public var buttonFont: UIFont
    
    public var titleLinesNumber: Int
    
    public var titleEdgeInsets: UIEdgeInsets
    
    public var buttonHeight: CGFloat
    /// 动画时间
    public var animationDuration: TimeInterval
    
    public var separatorColor: UIColor
    
    public var buttonHighlightdColor: UIColor
    //
    public var destructiveButtonColor: UIColor
    
    public var destructiveButtonIndex: Int?
        
    public var otherButtonTitles: [String] = []
    // 点击事件
    public var clickedHandler: ActionSheetClickedHandler?
    // 命名待优化
    public var canTouchToDismiss: Bool
    
    fileprivate var tableView: UITableView!
    
    fileprivate var titleLabel: UILabel!
    
    fileprivate var containerView: UIView!
    // 背景
    fileprivate var backgroundView: UIView!
    
    private var divisionLayer: CALayer!
    
    private var cancelButton: UIButton!

    private var config: ActionSheetConfig = ActionSheetConfig.default
    
    convenience init() {
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        
        cancelButtonTitle = config.cancelButtonTitle
        titleColor = config.titleColor
        buttonColor = config.buttonColor
        titleFont = config.titleFont
        buttonFont = config.buttonFont
        
        separatorColor = config.separatorColor
        destructiveButtonColor = config.destructiveButtonColor
        buttonHeight = config.buttonHeight
        animationDuration = config.animationDuration
        titleLinesNumber = config.titleLinesNumber
        titleEdgeInsets = config.titleEdgeInsets
        
        buttonHighlightdColor = config.buttonHighlightdColor
        
        canTouchToDismiss = config.canTouchToDismiss
        
        super.init(frame: frame)
    
        setupUI()
    }
    
    public convenience init(title: String? = nil, 
                            cancelButtonTitle: String? = nil,
                            otherButtonTitles: [String] = [],
                            clickedHandler: ActionSheetClickedHandler? = nil) {
        self.init()
        self.title = title
        self.otherButtonTitles = otherButtonTitles
        self.cancelButtonTitle = cancelButtonTitle
        self.clickedHandler = clickedHandler
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor(hex6: 0x808080)
        backgroundView.alpha = 0
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewClicked))
        backgroundView.addGestureRecognizer(tapGesture)
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        
        titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = buttonHeight
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "cell")
        containerView.addSubview(tableView)
        // 分割
        divisionLayer = CALayer()
        divisionLayer.backgroundColor = UIColor(hex6: 0xededee).cgColor
        containerView.layer.addSublayer(divisionLayer)
        
        // 
        cancelButton = UIButton(type: .custom)
        cancelButton.titleLabel?.font = buttonFont
        cancelButton.setTitleColor(buttonColor, for: .normal)
        cancelButton.setBackgroundImage(UIImage(color: buttonHighlightdColor), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        containerView.addSubview(cancelButton)
    }
    
    func setupView() {
        
        // 依次计算
        titleLabel.numberOfLines = titleLinesNumber
        titleLabel.text = title
        
        var titleEdgeInsetsBottom = titleEdgeInsets.bottom
        if title != nil {
            let titleWidth = kScreenWidth - titleEdgeInsets.left - titleEdgeInsets.right
            let size = CGSize(width: titleWidth,
                              height: CGFloat.greatestFiniteMagnitude)
            var titleSize = titleLabel.sizeThatFits(size)
            titleSize = CGSize(width: titleWidth, height: ceil(titleSize.height)+1)
            
            titleLabel.frame = CGRect(x: titleEdgeInsets.left, y: titleEdgeInsets.top,
                                      width: titleSize.width, height: titleSize.height)
        } else {
            titleLabel.frame = CGRect.zero
            titleEdgeInsetsBottom = 0
        }
        
        // layout tableView
        let tableViewHeight = CGFloat(otherButtonTitles.count) * buttonHeight
        tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY+titleEdgeInsetsBottom,
                                 width: kScreenWidth, height: tableViewHeight)
        
        // 
        let divisionViewHeight: CGFloat = (cancelButtonTitle != nil) ? 5.0 : 0.0
        divisionLayer.frame = CGRect(x: 0, y: tableView.frame.maxY,
                                     width: kScreenWidth, height: divisionViewHeight)
        
        
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        if cancelButtonTitle != nil {
            cancelButton.frame = CGRect(x: 0, y: divisionLayer.frame.maxY,
                                        width: kScreenWidth, height: buttonHeight)
        } else {
            cancelButton.frame = CGRect(x: 0, y: divisionLayer.frame.maxY,
                                        width: kScreenWidth, height: 0)
        }
       
        
        containerView.frame = CGRect(x: 0, y: kScreenHeight - cancelButton.frame.maxY,
                                     width: kScreenWidth, height: cancelButton.frame.maxY)
    }
    
    
    // MARK: 
    func append(_ buttonTitle: String, at index: Int = -1) {
       
        // 默认值 添加到最后面
        if index == -1 {
            
        } else {
            
            
            
        }
        
    }
    
    func append(buttonTitles: [String], at index: Int) {
        setupView()
        tableView.reloadData()
    }
    
    func backgroundViewClicked() {
        cancelButtonClicked()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ActionSheetView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherButtonTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActionSheetCell
        cell.titleLabel.font = buttonFont
        cell.lineLayer.backgroundColor = separatorColor.cgColor
        cell.titleLabel.text = otherButtonTitles[indexPath.row]
        cell.selectedBackgroundView?.backgroundColor = self.buttonHighlightdColor

        if indexPath.row == destructiveButtonIndex {
            cell.titleLabel.textColor = destructiveButtonColor
        } else {
            cell.titleLabel.textColor = buttonColor
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.clickedHandler?(self, indexPath.row)
        cancelButtonClicked()
    }
    
}

extension ActionSheetView {
    
    public func show() {
        // 添加到window上
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(self)
        
        setupView()
        containerView.frame = containerView.frame.offsetBy(dx: 0, dy: containerView.frame.height)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { 
            
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            self.backgroundView.alpha = 0.3
            
        }, completion: {(finished) in 
            
            self.backgroundView.isUserInteractionEnabled = self.canTouchToDismiss
        })
    }
    
    func cancelButtonClicked() {
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { 
            
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            self.backgroundView.alpha = 0.0
            
        }, completion: {(finished) in 
            
            self.removeFromSuperview()
            
        })
    }
}


extension UIColor {
     convenience init(hex6: UInt32, alpha: Float = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue    = CGFloat((hex6 & 0x0000FF) >> 0) / divisor
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

}
