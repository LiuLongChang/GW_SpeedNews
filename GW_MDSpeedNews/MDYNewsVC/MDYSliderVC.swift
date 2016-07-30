//
//  MDYSliderVC.swift
//  GW_MDSpeedNews
//
//  Created by 刘隆昌 on 16/7/24.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit

class MDYSliderVC: UIViewController {
    

    /*
     *
     *  左滑VC 右滑VC 主界面VC
     *
     */
    var leftVC : UIViewController! = nil
    var rightVC : UIViewController! = nil
    var mainVC : UIViewController! = nil
    

    /*
     *  控制是否可以出现 左View 、 右View
     *
     */
    var canShowLeft : Bool = false
    var canShowRight : Bool = false
    
/**显示中间的页面后调用**/
    
    var showMiddleVc : (Void->Void) = nil
/*****右侧页面出现后 调用Block********/
    var finishShowRight : (Void->Void) = nil
    
    
    //记录 左侧View 出现的状态 YES 表示左侧View 正在出现
    var showingLeft : Bool = false
    //记录 右侧View 出现的状态 YES 表示右侧View 正在出现
    var showingRight : Bool = false
    
    
    
    
    
    
    
    class func sharedSliderController(){
    
    
    }
    
    //点击左侧View 进行中间VC的替换
    func setMainContentViewController(mainVc:UIViewController){
        
        
        
        
    }
    //控制左侧 右侧出现的方法
    func moveView_Gesture(panGes:UIPanGestureRecognizer){
        
        
    }
    
    
    //左侧VC 出现
    func showLeftViewController(){
        
        
        
    }
    
    //右侧VC 出现
    func showRightViewController(){
        
        
        
    }
    
    //关闭侧边栏
    func closeSideBar(){
        
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
