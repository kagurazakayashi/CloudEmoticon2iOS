//
//  MyEmoticonViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/20.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import CoreImage
import GLKit
import OpenGLES

class MyEmoticonViewController: UIViewController, UITableViewDelegate, UIAlertViewDelegate, UITableViewDataSource {
    
    let 文件管理器:FileManager = FileManager()
    var 表格数据:NSMutableArray = NSMutableArray()

    @IBOutlet weak var 背景: UIView!
    @IBOutlet weak var 无颜文字: UIImageView!
    @IBOutlet weak var 无颜文字文字: UILabel!
    
    @IBOutlet weak var bgpview: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        右上按钮.title = lang.uage("编辑")
        左上按钮.title = ""
        表格.delegate = self
        表格.dataSource = self
        self.title = lang.uage("自定表情")
//        self.tabBarController?.tabBar.translucent = false
//        self.navigationController?.navigationBar.translucent = false
        self.language()
        
         //MARK - 主题

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 150/255, blue:243/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tabBarController?.tabBar.tintColor = UIColor(red: 33/255, green: 150/255, blue:243/255, alpha: 1)//tabbar选中文字颜色
        let tbitemcolor = NSDictionary(object: UIColor.blackColor(),
            forKey:NSForegroundColorAttributeName)
    }
    
    override func viewWillAppear(animated: Bool) {
        let 背景透明度:CGFloat = loadopc()
        表格.alpha = 背景透明度
        
        let bg:UIImage? = loadbg()
        if(bg != defaultimage){
            bgpview.image = bgimage
            bgpview.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            bgpview.image = bgimage
            bgpview.contentMode = UIViewContentMode.ScaleAspectFit
        }
        自动遮罩()
    }
    
    func 生成无颜文字遮罩(){
        
        背景.backgroundColor = UIColor.whiteColor()
        
        let bg:CIImage? = CIImage(image: loadbg())
        let 模糊过滤器 = CIFilter(name: "CIGaussianBlur")
        模糊过滤器.setValue(35, forKey: "InputRadius")
        模糊过滤器.setValue(bg, forKey: "InputImage")
     
        let ciContext = CIContext(EAGLContext: EAGLContext(API: .OpenGLES2))  //使用GPU方式
        let cgImage = ciContext.createCGImage(模糊过滤器.outputImage, fromRect: bg!.extent())
        ciContext.drawImage(模糊过滤器.outputImage, inRect: bg!.extent(), fromRect: bg!.extent())
        let 模糊图像 = UIImage(CGImage: cgImage)
        
        let 背景透明度:CGFloat = (1 - loadopc()) * 0.7 + 0.3
        无颜文字.alpha = 背景透明度
        
        无颜文字.image = 模糊图像
        无颜文字.contentMode = bgpview.contentMode
        
        显示文字()
    }
    
    func 显示文字()
    {
        
                        switch (内容选择菜单.selectedSegmentIndex) {
                case 0:
                    无颜文字文字.text = lang.uage("还没有收藏的颜文字喵")
                    break
                case 1:
                    无颜文字文字.text = lang.uage("还没有历史记录呢喵")
                    break
                case 2:
                    无颜文字文字.text = lang.uage("还没有添加自定义颜文字呢喵")
                    break
                default:
                    break
                }
        let 背景透明度:CGFloat = 1 - loadopc()
        
        if(背景透明度 < 0.35){
            无颜文字文字.textColor = UIColor.grayColor()
            无颜文字文字.shadowColor = UIColor.whiteColor()
        } else if(背景透明度 >= 0.35 && 背景透明度 < 0.65){
            无颜文字文字.textColor = UIColor.whiteColor()
            无颜文字文字.shadowColor = UIColor.blackColor()
        } else {
            无颜文字文字.textColor = UIColor.whiteColor()
            无颜文字文字.shadowColor = UIColor.grayColor()
        }
        
        无颜文字文字.backgroundColor = UIColor.clearColor()
        无颜文字文字.font = UIFont.boldSystemFontOfSize(22)
        无颜文字文字.textAlignment = NSTextAlignment.Center
        
        无颜文字文字.shadowOffset = CGSizeMake(1, 1)
        无颜文字文字.alpha = 0.8
        
        背景.hidden = false
    }
    
    @IBOutlet weak var 左上按钮: UIBarButtonItem!
    @IBOutlet weak var 表格: UITableView!
    @IBOutlet weak var 右上按钮: UIBarButtonItem!
    @IBOutlet weak var 内容选择菜单: UISegmentedControl!
    
    func language() {
        内容选择菜单.setTitle(lang.uage("收藏"), forSegmentAtIndex: 0)
        内容选择菜单.setTitle(lang.uage("历史记录"), forSegmentAtIndex: 1)
        内容选择菜单.setTitle(lang.uage("自定义"), forSegmentAtIndex: 2)
    }
    
    @IBAction func 左上按钮(sender: UIBarButtonItem) {
        
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            break
        case 1:
            break
        case 2:
            表格.setEditing(!表格.editing, animated: true)
            if(表格.editing){
                左上按钮.title = lang.uage("完成")
                右上按钮.title = ""
            } else {
                左上按钮.title = lang.uage("编辑")
                右上按钮.title = lang.uage("添加")
            }
        default:
            break
        }
    }
    
    
    @IBAction func 右上按钮(sender: UIBarButtonItem)
    {
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            表格.setEditing(!表格.editing, animated: true)
            if (表格.editing) {
                左上按钮.title = ""
                右上按钮.title = lang.uage("完成")
            } else {
                左上按钮.title = ""
                右上按钮.title = lang.uage("编辑")
            }
            表格.reloadData()
            保存收藏数据()
            break
        case 1:
            表格数据.removeAllObjects()
            表格.reloadData()
            保存历史记录数据()
            if (appgroup) {
//                var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//                containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//                var emolist:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
//                var 文件中的数据:NSArray = ArrayString().json2array(emolist!) as NSArray
//                var 新建数据模型:NSArray = [文件中的数据.objectAtIndex(0),文件中的数据.objectAtIndex(1),NSArray()]
//                var value:NSString = ArrayString().array2json(新建数据模型)
//                value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//                NSLog("Group写入操作")
                let 组数据读写:AppGroupIO = AppGroupIO()
                var 组数据:NSArray? = 组数据读写.读取设置UD模式()
                if (组数据 != nil) {
                    var 新建数据模型:NSArray = [组数据!.objectAtIndex(0),组数据!.objectAtIndex(1),NSArray()]
                    组数据读写.写入设置UD模式(新建数据模型)
                }
            }
            自动遮罩()
            break
        case 2:
            if (!表格.editing) {
                右上按钮.title = lang.uage("添加")
                左上按钮.title = lang.uage("编辑")
                var alert:UIAlertView = UIAlertView(title: lang.uage("添加颜文字"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"))
                alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
                var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField!
                alert.tag = 300
                alertImport.keyboardType = UIKeyboardType.URL
                alertImport.text = ""
                alert.show()
            } else {
                右上按钮.title = ""
                左上按钮.title = lang.uage("完成")
            }
            表格.reloadData()
            保存自定义数据()
            break
        default:
            break
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        var alertImport:UITextField = alertView.textFieldAtIndex(0) as UITextField!
        if (alertView.tag == 300) {
            if (buttonIndex == 1) {
                //添加
                addemoticon(alertImport.text)
                载入自定义数据()
                自动遮罩()
            }
        }
    }
    
    
    func addemoticon(emoticonstr:NSString)
    {
        let 颜文字名称:NSString = lang.uage("自定义")
        let 要添加的颜文字数组:NSArray = [emoticonstr,""]
        var 自定义:NSMutableArray = NSMutableArray()
        var 自定义颜文字:NSString = 要添加的颜文字数组.objectAtIndex(0)as! NSString
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
        var 自定义中已经存在这个颜文字 = false
        for 文件中的颜文字数组对象 in 文件中的数据! {
            let 文件中的颜文字数组:NSArray = 文件中的颜文字数组对象 as! NSArray
            let 文件中的颜文字:NSString = 文件中的颜文字数组.objectAtIndex(0) as! NSString
            
            if ( 自定义颜文字.isEqualToString(文件中的颜文字 as String)) {
                自定义中已经存在这个颜文字 = true
            }
        }
        if(!自定义中已经存在这个颜文字)
        {
            自定义.addObject(要添加的颜文字数组)
        }
        if (文件中的数据 != nil) {
            自定义.addObjectsFromArray(文件中的数据! as [AnyObject])
        }
        文件管理器.SaveArrayToFile(自定义,smode: FileManager.saveMode.CUSTOM)
        保存数据到输入法()
    }
    
    @IBAction func 内容选择菜单(内容选择: UISegmentedControl)
    {
        表格.setEditing(false, animated: true)
        changemode(内容选择.selectedSegmentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        changemode(内容选择菜单.selectedSegmentIndex)
    }
    
    // MARK: - 载入数据
    func changemode(id:Int)
    {
        背景.hidden = true
        switch (id) {
        case 0:
            载入收藏数据()
            右上按钮.title = lang.uage("编辑")
            左上按钮.title = ""
            break
        case 1:
            载入历史记录数据()
            左上按钮.title = ""
            右上按钮.title = lang.uage("清空")
            break
        case 2:
//            var value:NSString? = nil
//            if (appgroup) {
//                var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2NCWidget")!
//                containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//                value = NSString.stringWithContentsOfURL(containerURL, encoding: NSUTF8StringEncoding, error: nil)
//                if(value != nil && value != "") {
//                    addemoticon(value!)
//                }
//                value = ""
//                value?.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            NSLog("Group写入操作")
//            }
            载入自定义数据()
            左上按钮.title = lang.uage("编辑")
            右上按钮.title = lang.uage("添加")
            break
        default:
            break
        }
    }
    func 载入收藏数据()
    {
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
        
        将数据载入表格(文件中的数据)
    }
    func 载入历史记录数据()
    {
        let 组数据读写:AppGroupIO = AppGroupIO()
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.HISTORY)
        var 输入法中的数据:NSArray? = nil
        if (appgroup && 组数据读写.检查设置UD模式()) {
//            var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//            containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//            value = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
            输入法中的数据 = 组数据读写.读取设置UD模式()
        }
        if(输入法中的数据 != nil) {
            let 输入法中的历史记录数据:NSArray = 输入法中的数据?.objectAtIndex(2) as! NSArray
            if ((输入法中的历史记录数据.count != 文件中的数据?.count) && (输入法中的历史记录数据.count != 0)) {
                NSLog("历史记录：输入法中的数据")
                将数据载入表格(输入法中的历史记录数据)
                文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.HISTORY)
            } else {
                NSLog("历史记录：载入文件中的数据")
                将数据载入表格(文件中的数据)
            }
        } else {
            NSLog("历史记录：输入法中没有数据，载入文件中的数据")
            将数据载入表格(文件中的数据)
        }
    }
    func 载入自定义数据()
    {
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
        将数据载入表格(文件中的数据)
        
    }
    func 将数据载入表格(文件中的数据:NSArray?)
    {
        表格数据.removeAllObjects()
        var 表格内容为空:Bool = true
        if (文件中的数据 != nil) {
            表格数据.addObjectsFromArray(文件中的数据! as [AnyObject])
            if (表格数据.count > 0) {
                表格内容为空 = false
            }
        }
        if (表格内容为空) {
            生成无颜文字遮罩()
        } else {
            背景.hidden = true
        }
        表格.reloadData()
    }
    
    func 自动遮罩() {
        if (表格数据.count == 0) {
            生成无颜文字遮罩()
        } else {
            背景.hidden = true
        }
    }
    
    // MARK: - 保存数据
    func 保存收藏数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
        保存数据到输入法()
    }
    func 保存历史记录数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.HISTORY)
        保存数据到输入法()
    }
    func 保存自定义数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
        保存数据到输入法()
    }
    
    // MARK: - 表格数据
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (表格数据.count > 0) {
            tableView.userInteractionEnabled = true
            return 表格数据.count
        }
        tableView.userInteractionEnabled = false
        return 表格数据.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 表格.dequeueReusableCellWithIdentifier(CellIdentifier as String) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier as String)
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
        if (表格数据.count > 0) {
            let 当前单元格数据:NSArray = 表格数据.objectAtIndex(indexPath.row) as! NSArray
            if (当前单元格数据.count < 1) {
                cell?.textLabel?.text = "<错误数据>"
            } else {
                let 颜文字:NSString = 当前单元格数据.objectAtIndex(0) as! NSString
                var 颜文字名称:NSString?
                if (当前单元格数据.count > 1 && 颜文字名称 != nil) {
                    颜文字名称! = 当前单元格数据.objectAtIndex(1) as! NSString
                }
                cell?.textLabel?.text = 颜文字 as String
                if (颜文字名称 != nil) {
                    cell?.detailTextLabel?.text = 颜文字名称! as String
                } else {
                    cell?.detailTextLabel?.text = ""
                }
            }
        }
        else {
           //            switch (内容选择菜单.selectedSegmentIndex) {
//            case 0:
//                cell?.textLabel?.text = lang.uage("还没有收藏的颜文字喵")
//                break
//            case 1:
//                cell?.textLabel?.text = lang.uage("还没有历史记录呢喵")
//                break
//            case 2:
//                cell?.textLabel?.text = lang.uage("还没有添加自定义颜文字呢喵")
//                break
//            default:
//                break
//            } 
//            生成无颜文字遮罩()
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    //    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    //
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let 要复制的文本数组:NSArray = 表格数据.objectAtIndex(indexPath.row) as! NSArray
        NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 要复制的文本数组, userInfo: nil)
        if (内容选择菜单.selectedSegmentIndex == 1) {
            载入历史记录数据()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - 表格编辑范围
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
//        if (内容选择菜单.selectedSegmentIndex == 1) {
//            return UITableViewCellEditingStyle.None
//        }
        return UITableViewCellEditingStyle.Delete
    }
    // MARK: - 表格是否可以移动项目
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    // MARK: - 表格是否可以编辑
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // MARK: - 表格项目被移动
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        var fromRow:NSInteger = sourceIndexPath.row
        var toRow:NSInteger = destinationIndexPath.row
        var object: AnyObject = 表格数据.objectAtIndex(fromRow)
        表格数据.removeObjectAtIndex(fromRow)
        表格数据.insertObject(object, atIndex: toRow)
        switch(内容选择菜单.selectedSegmentIndex) {
        case 0:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
            break
        case 1:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.HISTORY)
            break
        case 2:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
            break
        default:
            break
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            switch (内容选择菜单.selectedSegmentIndex) {
            case 0:
                var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
                var nowrow:NSInteger = indexPath.row
                let nowrowArr:NSArray = 文件中的数据!.objectAtIndex(nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.objectAtIndex(0) as! NSString
                表格数据.removeObjectAtIndex(nowrow)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.FAVORITE)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.FAVORITE)
                }
                break
            case 1:
                var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.HISTORY)
                var nowrow:NSInteger = indexPath.row
                let nowrowArr:NSArray = 文件中的数据!.objectAtIndex(nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.objectAtIndex(0) as! NSString
                表格数据.removeObjectAtIndex(nowrow)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.HISTORY)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.HISTORY)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.HISTORY)
                }
                break
            case 2:
                var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
                var nowrow:NSInteger = indexPath.row
                let nowrowArr:NSArray = 文件中的数据!.objectAtIndex(nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.objectAtIndex(0) as! NSString
                表格数据.removeObjectAtIndex(nowrow)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.CUSTOM)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.CUSTOM)
                }
                break
            default:
                break
            }
            自动遮罩()
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String
    {
        return lang.uage("删掉喵")
    }
}
