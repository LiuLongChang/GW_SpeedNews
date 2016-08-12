//
//  GWScrollView.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/12.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit



typealias EndScrollToView = (view:UIView)->Void
typealias ScrollToIndex = (index:Int)->Void
typealias ScrollViewDidScroll = (scrollView:UIScrollView)->Void



class GWScrollView: UIView,UIScrollViewDelegate {



    var _scrollView : UIScrollView! = nil
    var _arrayOfView : NSMutableArray! = nil




    var endScrollToView : EndScrollToView?
    var scrollToIndex : ScrollToIndex?
    var scrollViewDidScroll : ScrollToIndex?





    var _currentView : UIView?
    var currentView : UIView?{

        set{
            _currentView = newValue
        }
        get{
            let currentIndex = Int(_scrollView.contentOffset.x / _scrollView.frame.size.width)
            var view : UIView? = nil

            if _arrayOfView.count > currentIndex {
                view = _arrayOfView[currentIndex] as? UIView
            }else{

            }
            _currentView = view
            return _currentView
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _scrollView = UIScrollView(frame: bounds)
        _scrollView.backgroundColor = UIColor.clearColor()
        _scrollView.pagingEnabled = true
        _scrollView.delegate = self
        self.addSubview(_scrollView)
        _arrayOfView = NSMutableArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func loadView(view:UIView){
        view.frame = CGRectMake(CGFloat(_arrayOfView.count) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)
        _scrollView.addSubview(view)
        _arrayOfView.addObject(view)
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * CGFloat(_arrayOfView.count), _scrollView.frame.size.height)
    }




    func deleteView(index:NSInteger){

        let arrayIndex = index - 1

        if _arrayOfView.count > arrayIndex {
            let view = _arrayOfView[arrayIndex]
            view.removeFromSuperview()


            for i in arrayIndex+1 ..< _arrayOfView.count {
                let afterView : UIView = _arrayOfView[i] as! UIView
                afterView.frame = CGRectOffset(afterView.frame, -view.frame.size.width, 0)
            }
            _arrayOfView.removeObject(arrayIndex)

            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * CGFloat(_arrayOfView.count), _scrollView.frame.size.height)

            // 刷新列表 和 相应的UI, 如果是当前显示的View的话
            self.endScroll()

        }else{

            NSLog("数组越界index:  %ld,in %@,方法： %s, 行号： %d", arrayIndex,self,#line)

        }

    }



    //MARK: UIScrollViewDelegate

    func scrollViewDidScroll(scrollView: UIScrollView) {

        if (self.scrollViewDidScroll != nil) {
            self.scrollViewDidScroll(scrollView)
        }

    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.endScroll()
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.endScroll()
    }

    func endScroll(){

        let currentView = self.currentView
        if self.endScrollToView != nil {
            self.endScrollToView!(view: currentView!)
        }
        //Stop Slide ,Current View is Which Index, Pass out
        let currentIndex = _scrollView.contentOffset.x / _scrollView.frame.size.width
        if self.scrollToIndex != nil {
            self.scrollToIndex!(index: Int(currentIndex) + 1)
        }

    }

    func scrollToView(index:Int){

        let contentOffSetX = ( CGFloat(index - 1 ) * _scrollView.frame.size.width)
        _scrollView.setContentOffset(CGPointMake(contentOffSetX, 0), animated: false)
        self.endScroll()

    }

}
