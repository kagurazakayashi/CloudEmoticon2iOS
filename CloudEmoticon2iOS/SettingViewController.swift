//
//  SettingViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var adflist:NSMutableArray = NSMutableArray.array()
    var actlist:NSMutableArray = NSMutableArray.array()
    
    var SetTable:UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.width), style: UITableViewStyle.Grouped)
    
    var 设置广告显示频率:UISlider = UISlider()
    var 设置复制后退出应用:UISwitch = UISwitch()

    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var adf:Float? = NSUserDefaults.standardUserDefaults().valueForKey("adfrequent") as? Float
    var copyexit:Bool? = NSUserDefaults.standardUserDefaults().valueForKey("exitaftercopy") as? Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("设置")
        SetTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        adflist.addObject(lang.uage("广告显示频率"))
        adflist.addObject("")
        adflist.addObject(lang.uage("复制后退出"))
        SetTable.delegate = self
        SetTable.dataSource = self
        view.addSubview(SetTable)
        loadSetting()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 2
        } else {
            return 1
        }
    }
    
    func  tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String!
    {
        if(section == 0)
        {
            return lang.uage("广告")
        } else {
            return lang.uage("行为")
        }
    }
    
    func loadSetting()
    {
        设置复制后退出应用.setOn(defaults.boolForKey("exitaftercopy"), animated: false)
        设置广告显示频率.value = defaults.floatForKey("adfrequent")
    }
    func saveSetting()
    {
        defaults.setBool(设置复制后退出应用.on, forKey: "exitaftercopy")
        defaults.setFloat(设置广告显示频率.value, forKey: "adfrequent")
        defaults.synchronize()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if(adf == nil){
        adf = 100
        }
        if(copyexit == nil){
        copyexit = false
        }
        设置广告显示频率.frame = CGRectMake(0, 0, self.view.frame.size.width - 36, 20)
        设置广告显示频率.minimumValue = 0
        设置广告显示频率.maximumValue = 100
        设置广告显示频率.value = adf!
        设置复制后退出应用.frame = CGRectZero
        设置复制后退出应用.on = copyexit!

        let CellIdentifier:NSString = "SettingCell"
        var cell:UITableViewCell? = SetTable.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        if(indexPath.section == 0){
        cell!.textLabel?.text = adflist.objectAtIndex(indexPath.row) as NSString
        } else {
        cell!.textLabel?.text = adflist.objectAtIndex(indexPath.row + 2) as NSString
        }
        
        if (cell!.contentView.subviews.count > 1) {
            println("cell!.contentView.subviews.count > 1")
        }

        if(indexPath.section == 0 && indexPath.row == 1){
            
            cell!.accessoryView = 设置广告显示频率
            设置广告显示频率.addTarget(self, action: Selector(updateSliderAtIndesPath(设置广告显示频率)), forControlEvents: UIControlEvents.TouchUpInside)
            设置广告显示频率.tag = 1001
            cell!.contentView.addSubview(设置广告显示频率)
        }
        
        if(indexPath.section == 1){
                cell!.accessoryView = 设置复制后退出应用
            设置复制后退出应用.addTarget(self, action: Selector(updateSwitchAtIndesPath(设置复制后退出应用)), forControlEvents: UIControlEvents.ValueChanged)
            设置复制后退出应用.tag = 1002
            cell!.contentView.addSubview(设置复制后退出应用)
            //slidhfodishgodsihg
        }
                        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func updateSwitchAtIndesPath(sender:UISwitch){
        var switchview:UISwitch = sender
              defaults.setBool(switchview.on, forKey: "exitaftercopy")
        defaults.synchronize()

    }
    
    func updateSliderAtIndesPath(sender:UISlider){
        var sliderview:UISlider = sender
        defaults.setObject(sliderview.value, forKey: "adfrequent")
        defaults.synchronize()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}