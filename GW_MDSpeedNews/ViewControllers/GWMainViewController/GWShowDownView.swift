//
//  GWShowDownView.swift
//  GW_MDSpeedNews
//
//  Created by 刘隆昌 on 16/8/13.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit



func IPhone4_5_6_6P(if4:CGFloat,if5:CGFloat,if6:CGFloat,if6P:CGFloat) -> CGFloat {
    
    if CGSizeEqualToSize(CGSizeMake(320, 480), UIScreen.mainScreen().bounds.size) {
        return if4
    }
    
    if CGSizeEqualToSize(CGSizeMake(320, 568), UIScreen.mainScreen().bounds.size) {
        return if5
    }
    
    if CGSizeEqualToSize(CGSizeMake(375, 667), UIScreen.mainScreen().bounds.size) {
        return if6
    }
    
    if CGSizeEqualToSize(CGSizeMake(414, 736), UIScreen.mainScreen().bounds.size) {
        return if6P
    }
    
}


func GWXFrom6(x:CGFloat)->CGFloat {
    return UIScreen.mainScreen().bounds.size.width / 375.0 * x
}


func GWYFrom6(y:CGFloat) -> CGFloat {
    return UIScreen.mainScreen().bounds.size.height / 667.0 * y
}


func RGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}





typealias ClickedButtonIndex = (index:Int)->Void
typealias ClickedDeleteButtonIndex = (index:Int)->Void

typealias ClickedAddButtonIndex = (index:Int)->Void




class GWShowDownView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var isAnimating : Bool! = false
    
    
    var _showFrame : CGRect?
    var showFrame : CGRect?{
        
        set{
            
            _showFrame = newValue
            _scrollView.frame = CGRectMake(0, _originY, self.frame.size.width, showFrame!.size.height - _originY)
            
        }
        get{
            return _showFrame
        }
        
    }
    
    
    
    
    var clickedButtonIndex : ClickedButtonIndex?
    var clickedDeleteButtonIndex : ClickedDeleteButtonIndex?
    var clickedAddButtonIndex : ClickedAddButtonIndex?
    
    
    
    
    
    private var _originFrame : CGRect!
    
    private var _originY : CGFloat = 0
    
    private var _scrollView : UIScrollView!
    
    private var _showingArray : NSMutableArray = []
    
    private var _canAddArray : NSMutableArray = []
    
    private var _buttonWidth : CGFloat = 0
    
    private var _buttonHeight : CGFloat = 0
    
    private var _leading : CGFloat = 0
    
    private var _horSpacing : CGFloat = 0
    
    private var _verSpacing : CGFloat = 0
    
    private var _addLabel : UILabel! = nil
    
    private var _isDeleting : Bool = false
    
    private var _upBeginY : CGFloat = 0
    
    private var _downBeginY : CGFloat = 0
    
    private var _canAddMaxSumNum : Int = 0
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _canAddMaxSumNum = 24
        
        _isDeleting = false
        
        
        _originFrame = frame
        
        _buttonWidth = GWXFrom6(74.0)
        _buttonHeight = GWYFrom6(34.0)
        _leading = GWXFrom6(15)
        _horSpacing = (self.frame.size.width - 4 * _buttonWidth - _leading * 2) / 3.0
        _verSpacing = GWXFrom6(15.0)
        
        _upBeginY = _verSpacing
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //====
    func hide(){
        
        isAnimating = true
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            
            weakSelf!.frame = weakSelf!._originFrame
            
            }) { (finish) in
                
                weakSelf!.isAnimating = false
                
        }
    }
    
    //====
    
    func show(){
        
        if _isDeleting == true {
            self.showDeleteStatus(nil)
        }
        isAnimating = true
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            
            weakSelf!.alpha = 1.0
            weakSelf!.frame = weakSelf!.showFrame!
            
            }) { (finshed) in
                
             weakSelf!.isAnimating = false
                
        }
        
    }
    
    
    //===
    
    func buttonWithFrame(frame:CGRect)->GWDeleteButton{
        
        
        var button : GWDeleteButton = GWDeleteButton(type: .Custom)
        button.frame = frame
        button.smallDeleteButton?.addTarget(self, action: Selector(), forControlEvents: .TouchUpInside)
        
        button.deleteStatus = GWDeleteButtonStatus.Normal
        
        button.setBackgroundImage(UIImage(named: "column.png"), forState: .Normal)
        
        button.setTitleColor(RGB(51, g: 51, b: 51), forState: .Normal)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        return button
        
    }
    
    
    
    //==
    func showDeleteStatus(button:UIButton?){
        
        if _isDeleting == true {
            
            _isDeleting = false
            for btn in _showingArray {
                let btnU : GWDeleteButton = btn as! GWDeleteButton
                btnU.deleteStatus = GWDeleteButtonStatus.Normal
            }
            _addLabel.hidden = false
            _scrollView.hidden = false
            
        }else{
            
            _isDeleting = true
            for btn in _showingArray {
                let btnU : GWDeleteButton = btn as! GWDeleteButton
                btnU.deleteStatus = GWDeleteButtonStatus.CanDelete
            }
            _addLabel.hidden = true
            _scrollView.hidden = true
        }
        
    }
    
    
    func showAlertView(message:String){
       let alertController = UIAlertController(title: "温馨提示",message: message,preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "确定",style: .Default,handler: { (action:UIAlertAction) -> Void in
        
        
        })
        alertController.addAction(alertAction)
        self.viewController(UIViewController)?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    func addShowingCategory(title:String){
        
        _originY = _verSpacing + (_buttonHeight + _verSpacing) * (CGFloat(_showingArray.count) / 4)
        
        var button : GWDeleteButton = self.buttonWithFrame(CGRectMake(_leading + (_buttonWidth + _horSpacing) * (CGFloat(_showingArray.count) % 4), _originY, _buttonWidth, _buttonHeight))
        
        
        if _showingArray.count == 0 {
            button.deleteStatus = GWDeleteButtonStatus.NeverDelete
        }
        
        
        button.addTarget(self, action: Selector(), forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        self.addSubview(button)
        
        _showingArray.addObject(button)
        
    }
    
    
    //=====
    
    func addCategoryLabelAndScrollView(){
        //MARK: 添加栏目标签
        
        _originY += _buttonHeight + _verSpacing
        
        _addLabel = UILabel(frame: CGRectMake(0,_originY,self.frame.size.width,GWXFrom6(43.0)))
        
        _addLabel.text = "   点击添加栏目"
        
        _addLabel.font = UIFont.systemFontOfSize(IPhone4_5_6_6P(16, if5: 16, if6: 17, if6P: 18))
        
        _addLabel.textColor = RGB(153, g: 153, b: 153)
        _addLabel.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(_addLabel)
        
        _originY += _addLabel.frame.size.height
        
        _scrollView = UIScrollView(frame:CGRectMake(0,_originY,self.frame.size.width,self.showFrame!.size.height - _originY))
        self.addSubview(_scrollView)
        
        _downBeginY = _verSpacing
        
    }
    
    
    
    
    
    
    
    
    
    

}




extension UIView{
    

    func viewController(aClass: AnyClass) -> UIViewController? {
        
        var next : UIResponder? = self
        while next != nil {
            if next!.isKindOfClass(aClass) {
                return next as? UIViewController
            }
            next = next?.nextResponder()
        }
        return nil
    }
    
    
}






