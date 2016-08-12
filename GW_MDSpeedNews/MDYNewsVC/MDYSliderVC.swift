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
    






    //记录最开始滑动的位置 在一次滑动结束前 只会赋一次值
    var startX : CGFloat! = 0
    //每次滑动的前一个坐标
    var lastX : CGFloat! = 0
    //最后产生的移动坐标x 和 上一次产生的移动坐标之间的差值
    var durationX : CGFloat! = 0


    //控制左侧 右侧出现的方法
    func moveView_Gesture(panGes:UIPanGestureRecognizer){
        

        let touchPoint = panGes.locationInView(UIApplication.sharedApplication().keyWindow)

        if panGes.state == .Began {
            //开始滑动时
            startX = touchPoint.x
            lastX = touchPoint.x
        }

        
        if panGes.state == .Changed {
            //正在滑动时
            let currentX = touchPoint.x//当前移动到的距离

            durationX = currentX - lastX
            lastX = currentX
            if durationX > 0 {
                //右滑 左侧View 出现
                if showingLeft == false && showingRight == false && canShowLeft == true && _leftVC != nil {
                    showingLeft = true
                    view.bringSubviewToFront(leftSideView)
                }
                
            }else{
                //左滑 右侧View 出现
                if showingRight == false && showingLeft == false && canShowRight == true && _rightVC != nil {
                    showingRight = true
                    view.bringSubviewToFront(rightSideView)
                }
            }
            
            
            if showingLeft == true {

                if (leftSideView.frame.origin.x >= -_leftSpace && durationX > 0) {
                    //如果 左侧View 已经完全出现 并且是向左滑 则返回什么都不做
                    return
                }
                if canShowLeft == false || _leftVC == nil {
                    //如果 不可以出现左侧View 或左侧VC 为 nil 则返回什么都不做
                    return
                }

                //Set LeftView 
                var x = durationX + leftSideView.frame.origin.x
                //设置 模糊图片
                self.configureViewBlur(x + mainContentView.frame.size.width, scale: 1)


                if x >= -_leftSpace {
                    x = -_leftSpace
                }


                if leftSideView.frame.origin.x != x {
                    leftSideView.frame = CGRectMake(x, leftSideView.frame.origin.y, leftSideView.frame.size.width, leftSideView.frame.size.height)
                }

                
            }else{
                

                if canShowRight == false || _rightVC == nil {
                    //如果 不允许出现右侧View 或者右侧的Vc 是nil 则不做操作
                    return
                }

                // 设置右侧 View 的 frame 只改变 X
                var x = durationX + rightSideView.frame.origin.x

                if x <= mainContentView.frame.size.width - rightSideView.frame.size.width {

                    x = mainContentView.frame.size.width - rightSideView.frame.size.width
                }

                //
                self.configureViewBlur(_mainVC.view.frame.size.width - x, scale: 1)

                rightSideView.frame = CGRectMake(x, rightSideView.frame.origin.y, rightSideView.frame.size.width, rightSideView.frame.size.height)
                
            }

        }else if(panGes.state == .Ended){
            //滑动结束时

            weak var weakSelf = self

            if showingLeft {


                if canShowLeft == false || _leftVC == nil {
                    return
                }

                if leftSideView.frame.origin.x + leftSideView.frame.size.width > (leftSideView.frame.size.width - _leftSpace)/2 {

                    //Ifinset of left View > half most inset,then left view appears

                    let durationTime : Double = Double((-leftSideView.frame.origin.x)/(_mainVC.view.frame.size.width))
                    //calculate time of animation,left view ,s x 

                    UIView.animateWithDuration(durationTime, animations: {


                        weakSelf!.configureViewBlur(weakSelf!._mainVC.view.frame.size.width-weakSelf!._leftSpace, scale: 1)

                        weakSelf!.leftSideView.frame = CGRectMake(-weakSelf!._leftSpace, weakSelf!.leftSideView.frame.origin.y, weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.size.height)


                        }, completion: { (finished) in

                            weakSelf!.leftSideView.userInteractionEnabled = true
                            weakSelf!._tapGestureRec.enabled = true

                    })

                }else{

                    //如果zuoceView出现的偏移 小于等于 最大偏移量的 一半 则隐藏左侧view
                    let durationTime = 1 - (-leftSideView.frame.origin.x)/(_mainVC.view.frame.size.width)
                    UIView.animateWithDuration(Double(durationTime), animations: {


                        self.configureViewBlur(0, scale: 1)
                        weakSelf!.leftSideView.frame = CGRectMake(-weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.origin.y, weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.size.height)

                        }, completion: { (finished) in

                                weakSelf!.view.sendSubviewToBack(weakSelf!.leftSideView)
                            self.setDefaultSettingForShowMiddle()

                    })

                }

                return
            }



            if showingRight {


                if canShowRight == false || _rightVC == nil{
                    return
                }

                if rightSideView.frame.origin.x < _mainVC.view.frame.size.width / 2 {
                    //日过右侧View 出现的范围大于一半 右侧View 出现

                    let durationTime = rightSideView.frame.origin.x / _mainVC.view.frame.size.width

                    UIView.animateWithDuration(Double(durationTime), animations: {

                        //设置模糊图片 透明度 1
                        weakSelf!.configureViewBlur(weakSelf!._mainVC.view.frame.size.width, scale: 1)
                        //设置右侧View的X坐标
                        weakSelf!.rightSideView.frame = CGRectMake(0, weakSelf!.rightSideView.frame.origin.y, weakSelf!.rightSideView.frame.size.width, weakSelf!.rightSideView.frame.size.height)


                        }, completion: { (finished) in

                            weakSelf!.rightSideView.userInteractionEnabled = true
                            weakSelf!._tapGestureRec.enabled = true
                            if weakSelf!.finishShowRight != nil {
                                weakSelf!.finishShowRight!()
                            }

                    })


                }else{
                    //如果右侧View 出现的范围 小于等于 一半 隐藏右侧View

                    let durationTime = 1 - (rightSideView.frame.origin.x)/(_mainVC.view.frame.size.width)
                    UIView.animateWithDuration(Double(durationTime), animations: {


                        self.configureViewBlur(0, scale: 1)
                        weakSelf?.rightSideView.frame = CGRectMake(weakSelf!._mainVC.view.frame.size.width, weakSelf!.rightSideView.frame.origin.y, weakSelf!.rightSideView.frame.size.width, weakSelf!.rightSideView.frame.size.height)


                        }, completion: { (finish) in

                            weakSelf?.view.sendSubviewToBack(weakSelf!.rightSideView)
                            weakSelf!.setDefaultSettingForShowMiddle()

                    })

                }

            }

        }
        
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
        
        
        if showingRight {
            self.closeSideBar()
            return
        }
        
        if canShowRight || _rightVC == nil{
            return
        }
        
        showingRight = true
        view.bringSubviewToFront(rightSideView)
        self.configureViewBlur(0, scale: 1)
        UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {
            
            self.configureViewBlur(self._mainVC.view.frame.size.width, scale: 1)
            
            self.rightSideView.frame = CGRectMake(0, self.rightSideView.frame.origin.y, self.rightSideView.frame.size.width, self.rightSideView.frame.size.height)
            

            }) { (finished) in
                
                self.rightSideView.userInteractionEnabled = true
                self._tapGestureRec.enabled = true
                if self.finishShowRight != nil {
                    self.finishShowRight!()
                }
                
        }
        
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




        _tapGestureRec = UITapGestureRecognizer(target: self,action: #selector(MDYSliderVC.closeSideBar))
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
            let image = BlurHelp.getImageFromView(_mainVC.view)

            //图片添加模糊效果
            _mainBackgroundIV.setImageTOBlur(image, blurRadius: kBlurredImageDefaultBlurRadius, completion: { Void->Void in


            })
            _mainVC.view.addSubview(_mainBackgroundIV) // 加了模糊效果的图片 加到 中间的View (mainVC.view)

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
        
        self.closeSideBarT(animate: true, Complete: {(finished:Bool)->Void in
        
        
        
        })
        
    }
    
    
    func closeSideBarT(animate animated:Bool,Complete complete:(finished:Bool)->Void){
        
        
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
            //  左边栏已经展开 关闭左边栏
            
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


    func showLeftVC(){

        if showingLeft == false {
            self.closeSideBar()
            return
        }

        if canShowLeft == false || _leftVC == nil{
            return
        }


        showingLeft = true
        view.bringSubviewToFront(leftSideView)

        self.configureViewBlur(0, scale: 1)
        weak var weakSelf = self
        UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {

            weakSelf!.configureViewBlur(weakSelf!._mainVC.view.frame.size.width - weakSelf!._leftSpace, scale: 1)

            weakSelf!.leftSideView.frame = CGRectMake(-weakSelf!._leftSpace, weakSelf!.leftSideView.frame.origin.y, weakSelf!.leftSideView.frame.size.width, weakSelf!.leftSideView.frame.size.height)


        }) { (finish) in

            weakSelf!.leftSideView.userInteractionEnabled = true
            weakSelf!._tapGestureRec.enabled = true

        }

    }





    func showRightVC(){

        if showingRight == false {
            self.closeSideBar();return
        }

        if canShowRight == false || _rightVC == nil {
            return
        }

        showingRight = true;view.bringSubviewToFront(rightSideView)

        self.configureViewBlur(0, scale: 1)

        weak var weakSelf = self
        UIView.animateWithDuration(Common_Show_Close_Duration_Time, animations: {

            weakSelf!.configureViewBlur(weakSelf!._mainVC.view.frame.size.width, scale: 1)
            weakSelf!.rightSideView.frame = CGRectMake(0, weakSelf!.rightSideView.frame.origin.y, weakSelf!.rightSideView.frame.size.width, weakSelf!.rightSideView.frame.size.height)


        }) { (finish) in

            weakSelf!.rightSideView.userInteractionEnabled = true
            weakSelf!._tapGestureRec.enabled = true
            if weakSelf!.finishShowRight != nil {
                weakSelf?.finishShowRight!()
            }
            
        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private init() {
        canShowLeft = true
        canShowRight = true
        showingLeft = false
        showingRight = false
        super.init(nibName: nil, bundle: nil)
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
