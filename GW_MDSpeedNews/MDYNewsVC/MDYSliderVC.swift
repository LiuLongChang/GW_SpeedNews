//
//  MDYSliderVC.swift
//  GW_MDSpeedNews
//
//  Created by 刘隆昌 on 16/7/24.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit


//点击展开或关闭侧边栏的动画时间
let Common_Show_Close_Duration_Time = 0.4




class MDYSliderVC: UIViewController,UIGestureRecognizerDelegate {
    
    
    static let sharedInstance = MDYSliderVC()
    
    
    

    /*
     *
     *  左滑VC 右滑VC 主界面VC
     *
     */
    var _leftVC : UIViewController! = nil
    var _rightVC : UIViewController! = nil
    var _mainVC : UIViewController! = nil
    

    /*
     *  控制是否可以出现 左View 、 右View
     *
     */
    var canShowLeft : Bool = false
    var canShowRight : Bool = false
    
/**显示中间的页面后调用**/
    
    var showMiddleVc : (Void->Void)? = nil
/*****右侧页面出现后 调用Block********/
    var finishShowRight : (Void->Void)? = nil
    
    
    //记录 左侧View 出现的状态 YES 表示左侧View 正在出现
    var showingLeft : Bool = false
    //记录 右侧View 出现的状态 YES 表示右侧View 正在出现
    var showingRight : Bool = false
    
    
    
    //滑动手势 控制左右两侧View
    var _panGestureRec : UIPanGestureRecognizer!
    
    //点击手势 加在模糊图片上
    var _tapGestureRec : UITapGestureRecognizer!
    
    
    //模糊图片
    var _mainBackgroundIV : UIImageView!
    
    
    
    
    
    
    var mainContentView : UIView!
    var leftSideView : UIView!
    var rightSideView : UIView!
    
    
    
    var _leftSpace : CGFloat! //左View距离屏幕右边的距离
    
    
    
    

    
    
    //点击左侧View 进行中间VC的替换
    func setMainContentViewController(mainVc:UIViewController){
        
        if mainVc .isEqual(_mainVC) {
            //先判断 设置的是不是同一个VC 如果是 则不操作
            if _mainVC.view.superview != nil {
                //如果当前中间View在父View上
                _mainVC.view.removeFromSuperview()
            }
            _mainVC = mainVc
            
            self.addChildViewController(mainVc)
            mainContentView.addSubview(mainVc.view)
            
        }
        self.closeSideBar()
    }
    
    
    
    //控制左侧 右侧出现的方法
    func moveView_Gesture(panGes:UIPanGestureRecognizer){
        
        
    }
    
    
    //左侧VC 出现
    func showLeftViewController(){
        
        
        if showingLeft {
            self.closeSideBar()
            return
        }
        
        
        if canShowLeft || _leftVC != nil {
            return
        }
        
        
        showingLeft = true
        view.bringSubviewToFront(leftSideView)
        
        self.configureViewBlur(0, scale: 1)
        
        weak var weakSelf = self
        UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {
            
                self.configureViewBlur(weakSelf!._mainVC.view.frame.size.width - weakSelf!._leftSpace, scale: 1)
            
                weakSelf!.leftSideView.frame = CGRectMake(-weakSelf!._leftSpace, weakSelf!.leftSideView.frame.origin.y, weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.size.height)
            
            
            }) { (finished) in
                
                weakSelf!.leftSideView.userInteractionEnabled = true
                weakSelf!._tapGestureRec.enabled = true
                
                
        }
        
        
        
        
    }
    
    //右侧VC 出现
    func showRightViewController(){
        
        
        
    }
    
    
    
    
    override func loadView() {
        super.loadView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //实例化三个view  左、中、右
        self.initSubViews()
        
        //设置 三个 子 VC
        self.initChildControllers()
        
        
        _tapGestureRec = UITapGestureRecognizer(target: self,action: Selector(closeSideBar()))
        
        _tapGestureRec.delegate = self
        _tapGestureRec.enabled = false
        
        
        
        _panGestureRec = UIPanGestureRecognizer(target: self,action: #selector(moveView_Gesture(_:)))
        
        mainContentView.addGestureRecognizer(_panGestureRec)
        view.addGestureRecognizer(_panGestureRec)
        
        
    }
    
    
    
    func initSubViews(){
        
        
        //Frame 在屏幕右边
        rightSideView = UIView(frame:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height))
        view.addSubview(rightSideView)
        
        
        //Frame 在屏幕左边
        leftSideView = UIView(frame:CGRectMake(-view.frame.size.width,0,view.frame.size.width,view.frame.size.height))
        view.addSubview(leftSideView)
        
        
        //Frame 在屏幕中
        mainContentView = UIView(frame:view.bounds)
        view.addSubview(mainContentView)
        
        
    }
    
    
    //设置 三个子 VC
    func initChildControllers(){
        
        if canShowRight && _rightVC != nil {
            
            self.addChildViewController(_rightVC)
            _rightVC.view.frame = CGRectMake(0, 0, rightSideView.frame.size.width, rightSideView.frame.size.height)
            rightSideView.addSubview(_rightVC.view)
            
        }
        
        
        if canShowLeft && _leftVC != nil {
            
            self.addChildViewController(_leftVC)
            _leftSpace = view.frame.size.width - _leftVC.view.frame.size.width
            _leftVC.view.frame = CGRectMake(_leftSpace, 0, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height)
            leftSideView.addSubview(_leftVC.view)
            
            
        }
        
        
        if _mainVC != nil {
            _mainVC.view.frame = mainContentView.frame
            self.addChildViewController(_mainVC)
            mainContentView.addSubview(_mainVC.view)
        }
        
        
    }
    
    
    //MARK 给View 添加模糊效果
    //解释参数 nValue 滑动到的位置坐标 x 拿来算相对于mainVc.View 的位置 当做 最大透明度的倍数 nScale 最大的透明度
    
    func configureViewBlur(nValue:CGFloat,scale nScale:CGFloat){
        
        let nScaleU: CGFloat = nScale * 075
        if _mainBackgroundIV == nil {
            
            _mainBackgroundIV = UIImageView(frame:_mainVC.view.bounds)
            _mainBackgroundIV.userInteractionEnabled = true
            _mainBackgroundIV.addGestureRecognizer(_tapGestureRec)
            _tapGestureRec.enabled = true
            
            
            
            //转换成图片
            
            
            
            
            
            //图片添加模糊效果
            
            
            
            
            
            _mainVC.view.addSubview(_mainBackgroundIV)
        }
        
        //设置透明度
        _mainBackgroundIV.alpha = (nScaleU/_mainVC.view.frame.size.width) * nScaleU
        
    }
    
    
    //销毁 模糊 imageView 下次出现时 再 重新实例化
    func removeConfigureViewBlur(){
        _mainBackgroundIV.removeFromSuperview()
        _mainBackgroundIV = nil
    }
    
    //GestureDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        //屏蔽 滑动tableView 时 触发这个滑动事件
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            NSLog("待测试方法")
            return false
        }
        return true
    }
    
    //MARK: 关闭侧边栏
    //关闭侧边栏
    func closeSideBar(){
        
        self.closeSideBar(animate: true, Complete: {(finished:Bool)->Void in
        
        
        
        })
        
    }
    
    
    func closeSideBar(animate animated:Bool,Complete complete:(finished:Bool)->Void){
        
        
        weak var weakSelf = self
        
        if showingLeft {
            //左边栏已经展开 关闭左边栏
            if animated {
                
                UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {
                    
                    //模糊图片 全透明
                    self.configureViewBlur(0, scale: 1)
                    //左侧View 移出 屏幕
                    weakSelf!.leftSideView.frame = CGRectMake(-weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.origin.y, weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.size.height)
                    
                    }, completion: { (finshed) in
                        
                        //左侧View 放在最底层
                        weakSelf!.view.sendSubviewToBack(weakSelf!.leftSideView)
                        
                        complete(finished: true)
                        
                })
                
                
            }else{
                
                
                //不执行动画
                
                self.configureViewBlur(0, scale: 1)
                //模糊图片 全透明
                
                //左侧View 移除 屏幕
                leftSideView.frame = CGRectMake(leftSideView.frame.size.width, leftSideView.frame.origin.y, leftSideView.frame.size.width,leftSideView.frame.size.height)
                view.sendSubviewToBack(leftSideView)
                //
                self.setDefaultSettingForShowMiddle()
                complete(finished: true)
                
                
                
                
            }
            
        }else{
            
            
            if animated {
                UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {
                    self.configureViewBlur(0, scale: 1)
                    //右侧View移出屏幕
                    weakSelf!.rightSideView.frame = CGRectMake(weakSelf!._mainVC.view.frame.size.width, weakSelf!.rightSideView.frame.origin.y, weakSelf!.rightSideView.frame.size.width, weakSelf!.rightSideView.frame.size.height)
                    
                    }, completion: { (finished) in
                        
                        weakSelf!.view.sendSubviewToBack(weakSelf!.rightSideView)
                        weakSelf!.setDefaultSettingForShowMiddle()
                        
                        complete(finished: true)
                        
                })
                
            }else{
                
                weakSelf!.configureViewBlur(0, scale: 1)
                
                rightSideView.frame = CGRectMake(_mainVC.view.frame.size.width, rightSideView.frame.origin.y, rightSideView.frame.size.width, rightSideView.frame.size.height)
                
                weakSelf!.view.sendSubviewToBack(rightSideView)
                self.setDefaultSettingForShowMiddle()
                
                complete(finished: true)
                
                
            }
            
        }
        
    }
    
    
    //显示中间的页面 进行的 设置
    func setDefaultSettingForShowMiddle(){
        
        showingLeft = false
        showingRight = false
        _tapGestureRec.enabled = false
        
        self.removeConfigureViewBlur()
        
        if (showMiddleVc != nil) {
            showMiddleVc!()
        }
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private convenience init() {
        self.init()
        canShowLeft = true
        canShowRight = true
        showingLeft = false
        showingRight = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
        mainContentView = nil
        leftSideView = nil
        rightSideView = nil
        
        _panGestureRec = nil
        
        _leftVC = nil
        _rightVC = nil
        _mainVC = nil
        
        _mainBackgroundIV = nil
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
