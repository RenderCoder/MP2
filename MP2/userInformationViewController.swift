//
//  userInformationViewController.swift
//  MP2
//
//  Created by bijiabo on 15/7/3.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class userInformationViewController: UIViewController {

    @IBOutlet var childNameTextField: UITextField!
    @IBOutlet var childSexualitySegmentedControl: UISegmentedControl!
    @IBOutlet var childBirthdayDatePicker: UIDatePicker!
    
    let ageMax : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func initView () -> Void
    {
        initDatePicker()
        
        if let childName =  NSUserDefaults.standardUserDefaults().stringForKey("childName")
        {
            childNameTextField.text = childName
        }
        
        if let childSexuality = NSUserDefaults.standardUserDefaults().stringForKey("childSexuality")
        {
            for var i = 0 ; i < childSexualitySegmentedControl.numberOfSegments ; i++
            {
                if childSexualitySegmentedControl.titleForSegmentAtIndex(i) == childSexuality
                {
                    childSexualitySegmentedControl.selectedSegmentIndex = i
                    break
                }
            }
        }
        
    }
    
    func initDatePicker () -> Void
    {
        
        let minimumDate : NSDate = NSDate(timeIntervalSinceNow: NSTimeInterval( -3600*24*365*(ageMax+1) + 3600*24*1 ))
        childBirthdayDatePicker.minimumDate = minimumDate
        childBirthdayDatePicker.maximumDate = NSDate()
        
        if let childBirthday: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("childBirthday")
        {
            childBirthdayDatePicker.date = childBirthday as! NSDate
        }
    }
    
    func checkChildAgeGroupChanged () -> Bool
    {
        //获取先前孩子年龄设置
        
        if let previousChildBirthDay : NSDate = NSUserDefaults.standardUserDefaults().objectForKey("childBirthday") as? NSDate
        {
            let previouseChildAge : (age : Int , month : Int) = AgeCalculator(birth: previousChildBirthDay).age
            
            //获取现在孩子年龄设置
            let presentChildBirthDay : NSDate = childBirthdayDatePicker.date
            let presentChildAge : (age : Int , month : Int) = AgeCalculator(birth: presentChildBirthDay).age
            
            return previouseChildAge.age != presentChildAge.age ? true : false
        }
        else
        {
            return true
        }
        
    }
    
    
    @IBAction func tapSaveButton(sender: AnyObject) {
        if checkChildAgeGroupChanged()
        {
            //若孩子年龄段改变，则发送通知
            let presentChildBirthDay : NSDate = childBirthdayDatePicker.date
            let presentChildAge : (age : Int , month : Int) = AgeCalculator(birth: presentChildBirthDay).age
            
            let age : (age : Int , month : Int) = presentChildAge.age <= ageMax ? presentChildAge : (age : presentChildAge.age , month : 0)
            
            NSNotificationCenter.defaultCenter().postNotificationName("childAgeGroupChanged", object: ["age" : age.age] as AnyObject)
        }
        
        //若为新用户，注册
        //...
        
        //储存用户修改的数据
        NSUserDefaults.standardUserDefaults().setObject(childNameTextField.text, forKey: "childName")
        
        let childSexuality : String =  childSexualitySegmentedControl.titleForSegmentAtIndex(childSexualitySegmentedControl.selectedSegmentIndex)!
        NSUserDefaults.standardUserDefaults().setObject(childSexuality, forKey: "childSexuality")
        NSUserDefaults.standardUserDefaults().setObject(childBirthdayDatePicker.date, forKey: "childBirthday")
        
        //关闭页面
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}