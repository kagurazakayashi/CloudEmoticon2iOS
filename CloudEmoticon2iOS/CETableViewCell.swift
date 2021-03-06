//
//  CETableViewCell.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/21.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol CETableViewCellDelegate:NSObjectProtocol{
    func 单元格代理：点击滑出的按钮时(点击按钮的ID:Int, 单元格在表格中的位置:NSIndexPath)
    func 单元格代理：是否可以接收手势() -> Bool
}

class CETableViewCell: UITableViewCell { //UIGestureRecognizerDelegate
    
    enum cellMode:Int {
        case DEFAULT = 0
        case CEVIEWCONTROLLER = 1
    }
    var 单元格样式:cellMode = cellMode.DEFAULT
    let 滑出按钮A:UIButton = UIButton()
    let 滑出按钮B:UIButton = UIButton()
    let 按钮宽度:CGFloat = 60.0
    var 单元格在表格中的位置:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var 代理:CETableViewCellDelegate?
    var 覆盖视图:UIView = UIView()
    var 主文字:UILabel = UILabel()
    var 副文字:UILabel = UILabel()
    var 手势中:Bool = false
    var 允许手势:Bool = true
    var 手势:UIPanGestureRecognizer = UIPanGestureRecognizer()
    var 手势起始位置X坐标:CGFloat = 0.0
    var 手势起始位置Y坐标:CGFloat = 0.0
//    var 右侧距离:CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func 初始化单元格样式(nowmode:cellMode)
    {
        单元格样式 = nowmode
        if (单元格样式 == cellMode.CEVIEWCONTROLLER) {
            滑出按钮A.tag = 101
            滑出按钮B.tag = 102
            滑出按钮A.backgroundColor = UIColor.orangeColor()
            滑出按钮B.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.9, alpha: 1.0)
            滑出按钮A.setTitle(lang.uage("收藏"), forState: UIControlState.Normal)
            滑出按钮B.setTitle(lang.uage("分享"), forState: UIControlState.Normal)
            滑出按钮A.addTarget(self, action: #selector(CETableViewCell.点击滑出按钮(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            滑出按钮B.addTarget(self, action: #selector(CETableViewCell.点击滑出按钮(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(滑出按钮A)
            self.addSubview(滑出按钮B)
            self.addSubview(覆盖视图)
            主文字.textColor = UIColor.blackColor()
            副文字.textColor = UIColor.grayColor()
            主文字.backgroundColor = UIColor.clearColor()
            副文字.backgroundColor = UIColor.clearColor()
            副文字.font = UIFont.systemFontOfSize(12)
            覆盖视图.addSubview(主文字)
            覆盖视图.addSubview(副文字)
            手势 = UIPanGestureRecognizer(target: self, action: #selector(CETableViewCell.手势执行(_:)))
            手势.delegate = self
            覆盖视图.backgroundColor = UIColor.clearColor()
            覆盖视图.addGestureRecognizer(手势)
            self.textLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
            self.textLabel?.numberOfLines = 0
//            self.textLabel.textColor = UIColor.clearColor()
//            self.主文字.textColor = UIColor.blackColor()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CETableViewCell.取消单元格左滑方法(_:)), name: "取消单元格左滑通知", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CETableViewCell.允许单元格接收手势方法(_:)), name: "允许单元格接收手势通知", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CETableViewCell.修正单元格尺寸方法(_:)), name: "修正单元格尺寸通知", object: nil)
            self.layer.masksToBounds = true
        }
    }
    
    func 修正单元格尺寸方法(notification:NSNotification)
    {
        let 新的宽度:CGFloat = notification.object as! CGFloat
//        let 新的尺寸数组:NSArray = notification.object as NSArray
//        let 新的尺寸:CGSize = CGSizeMake(新的尺寸数组.objectAtIndex(0) as CGFloat, 新的尺寸数组.objectAtIndex(1) as CGFloat)
        修正元素位置(新的宽度)
    }
    
    func 取消单元格左滑方法(notification:NSNotification) {
        let 通知传值对象:AnyObject? = notification.object
        if (通知传值对象 == nil) {
            UIView.animateWithDuration(0.15, animations: {
                self.覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                self.滑出按钮A.frame = CGRectMake(self.frame.size.width, 0, self.按钮宽度, self.frame.size.height)
                self.滑出按钮B.frame = CGRectMake(self.frame.size.width + self.按钮宽度, 0, self.按钮宽度, self.frame.size.height)
            })
        } else {
            let 当前单元格在表格中的位置:NSIndexPath = 通知传值对象 as! NSIndexPath
            let 当前单元格在表格中的行:Int = 当前单元格在表格中的位置.row
            let 单元格在表格中的行:Int = 单元格在表格中的位置.row
            if (当前单元格在表格中的行 != 单元格在表格中的行) {
                UIView.animateWithDuration(0.15, animations: {
                    self.覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                    self.滑出按钮A.frame = CGRectMake(self.frame.size.width, 0, self.按钮宽度, self.frame.size.height)
                    self.滑出按钮B.frame = CGRectMake(self.frame.size.width + self.按钮宽度, 0, self.按钮宽度, self.frame.size.height)
                })
            }
        }
    }
    
    func 允许单元格接收手势方法(notification:NSNotification)
    {
        允许手势 = true
    }
    
    func 点击滑出按钮(sender:UIButton)
    {
        let 点击按钮的ID:Int = sender.tag - 100
        代理?.单元格代理：点击滑出的按钮时(点击按钮的ID, 单元格在表格中的位置: 单元格在表格中的位置)
    }
    
    func 手势执行(recognizer:UIPanGestureRecognizer)
    {
        let 手指当前坐标:CGPoint = recognizer.locationInView(self)
        let 滑动最大X坐标:CGFloat = 0 - (按钮宽度 * 2)
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed) {
            手势起始位置X坐标 = 0
            手势起始位置Y坐标 = 0
            var x:CGFloat = 0
            
            if (覆盖视图.frame.origin.x < 滑动最大X坐标 * 0.5) {
                x = 滑动最大X坐标
            }
            手势中 = false
            self.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            if (self.覆盖视图.frame.origin.x < 0 - 按钮宽度) {
                UIView.animateWithDuration(0.15, animations: {
                    self.覆盖视图.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height)
                    self.滑出按钮A.frame = CGRectMake(self.frame.size.width - self.按钮宽度, 0, self.按钮宽度, self.frame.size.height)
                    self.滑出按钮B.frame = CGRectMake(self.frame.size.width - self.按钮宽度 * 2, 0, self.按钮宽度, self.frame.size.height)
                    }, completion: {
                        (completion) in
                        if completion {
                            //                        self.菜单滑动中 = false
                        }
                })
            } else {
                UIView.animateWithDuration(0.15, animations: {
                    self.覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                    self.滑出按钮A.frame = CGRectMake(self.frame.size.width, 0, self.按钮宽度, self.frame.size.height)
                    self.滑出按钮B.frame = CGRectMake(self.frame.size.width + self.按钮宽度, 0, self.按钮宽度, self.frame.size.height)
                })
            }
    
        } else if (代理 != nil) {
            let 手指当前X坐标:CGFloat = 手指当前坐标.x
            let 手指当前Y坐标:CGFloat = 手指当前坐标.y
            let 手指移动X距离:CGFloat = 手势起始位置X坐标 - 手指当前X坐标
            let 手指移动Y距离:CGFloat = 手势起始位置Y坐标 - 手指当前Y坐标
            if (abs(手指移动Y距离) > abs(手指移动X距离) && abs(手指移动Y距离) > 10 && 允许手势 == true) {
                允许手势 = false
            } else if (代理!.单元格代理：是否可以接收手势()) {
                var 覆盖视图的新X坐标:CGFloat = 覆盖视图.frame.origin.x - 手指移动X距离
                self.layer.removeAllAnimations()
                if (覆盖视图的新X坐标 < 滑动最大X坐标) {
                    覆盖视图的新X坐标 = 滑动最大X坐标
                } else if (覆盖视图的新X坐标 > 0) {
                    覆盖视图的新X坐标 = 0
                }
                手势起始位置X坐标 = 手指当前坐标.x
                if (self.手势中 == true) {
                    self.覆盖视图.frame = CGRectMake(覆盖视图的新X坐标, 0, self.frame.size.width, self.frame.size.height)
                    self.滑出按钮A.frame = CGRectMake(覆盖视图.frame.origin.x + 覆盖视图.frame.size.width + self.按钮宽度, 0, self.按钮宽度, self.frame.size.height)
                    self.滑出按钮B.frame = CGRectMake(覆盖视图.frame.origin.x + 覆盖视图.frame.size.width, 0, self.按钮宽度, self.frame.size.height)
                }
            }
        }
    }
    
    //override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceivePress press: UIPress) -> Bool
    {
//        if (覆盖视图.frame.origin.x != 0) {
//            菜单滑动中 = true
//        }
//        取消单元格左滑通知
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: self.单元格在表格中的位置)
        手势中 = true
        let 手指当前坐标:CGPoint = gestureRecognizer.locationInView(self)
        手势起始位置X坐标 = 手指当前坐标.x
        return 允许手势
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
//        if (代理 != nil) {
//            return !代理!.单元格代理：是否可以接收手势()
//        }
        return 允许手势
    }
    
    func 修正元素位置(新的宽度:CGFloat)
    {
//        var x:CGFloat = 0
//        let 滑动最大X坐标:CGFloat = 0 - (按钮宽度 * 2)
//        if (覆盖视图.frame.origin.x < 滑动最大X坐标 * 0.5) {
//            x = 滑动最大X坐标
//        }
        
        
        滑出按钮A.frame = CGRectMake(新的宽度, 0, 按钮宽度, self.frame.size.height)
        滑出按钮B.frame = CGRectMake(新的宽度 + 按钮宽度, 0, 按钮宽度, self.frame.size.height)
        
        let 主文字框高度:CGFloat = 计算单元格高度(主文字.text!, 字体大小: 17, 单元格宽度: self.frame.size.width) + 8
        主文字.frame = CGRectMake(20, 5, 新的宽度 - 20, 主文字框高度)
        let 副文字文字:NSString = 副文字.text!
        if (!副文字文字.isEqualToString("")) {
            let 副文字框高度:CGFloat = 计算单元格高度(副文字.text!, 字体大小: 12, 单元格宽度: self.frame.size.width) - 1
            副文字.frame = CGRectMake(20, 主文字.frame.size.height - 1, 新的宽度 - 20, 副文字框高度)
            self.frame = CGRectMake(0, 0, 新的宽度, 主文字框高度 + 副文字框高度)
        } else {
            self.frame = CGRectMake(0, 0, 新的宽度, 主文字框高度)
        }
        覆盖视图.frame = CGRectMake(0, 0, 新的宽度, self.frame.size.height)
        主文字.lineBreakMode = NSLineBreakMode.ByCharWrapping
        主文字.numberOfLines = 0
    }
}