//
//  GWMainViewController.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/12.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height


class GWMainViewController: UIViewController {

    var _canShowCategoryNum : NSInteger! = 0
    var _isChanged : Bool! = false


    /**分类 数组**/
    var categoryArray : NSMutableArray = []
    /**正在 显示的栏目的Model 数组**/
    var showingCategoryArray : NSMutableArray = []
    /** 可以添加 的栏目 的 Model 数组**/
    var canAddCategoryArray : NSMutableArray = []



    //
//    var _categoryView : GWCategoryView?
//    var categoryView : GWCategoryView?{
//
//        set{
//
//            _categoryView = GWCategoryView(frame:CGRectMake(0,64,view.frame.size.width,43))
//
//            for model in showingCategoryArray {
//
//
//                //categoryView
//            }
//
//            weak var weakSelf = self
//
//
//        }
//        get{
//            return _categoryView
//        }
//
//    }



//    var _mainScrollView : GWCategoryView?
//    var mainScrollView : GWCategoryView?{
//
//        set{
//
//            _categoryView = GWCategoryView(frame:CGRectMake(0,64,view.frame.size.width,43))
//
//            for model in showingCategoryArray {
//
//
//                //categoryView
//            }
//
//            weak var weakSelf = self
//            
//            
//        }
//        get{
//            return _categoryView
//        }
//        
//    }





    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.redColor()



        self.initData()
        initView()


        let imgView = UIImageView()
        imgView.frame = CGRectMake(0, 100, ScreenWidth,ScreenWidth/284*177)
        view.addSubview(imgView)
        imgView.image = UIImage(named: "images.jpeg")


        
        // Do any additional setup after loading the view.
    }



    func initView(){

        title = "新闻"
        //NavigationBar Right Btn
        ////self.setRightNavigationButton()
        //Cancel SlideView AutoInset
        automaticallyAdjustsScrollViewInsets = false
        //Add Category View
        /////view.addSubview(categoryView)

        ///view.addSubview(mainscr)





    }


    func initData(){

        //初始化 Can Show 10 Categories
        _canShowCategoryNum = 15
        //读取 缓存数据
        self.readCategoryCache()
        //
        var isReadedCahce = false
        if showingCategoryArray.count > 0 {
            isReadedCahce = true
            return
        }

        let pathData = NSBundle.mainBundle().pathForResource("allCategory", ofType: "txt")

        let data = NSData(contentsOfFile: pathData!)

        let array : NSArray =  try! NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableLeaves]) as! NSArray

        for dic in array {

            let subArray : NSArray = dic["tList"] as! NSArray
            for i in 0 ..< subArray.count {

                let subDic = subArray[i]
                let model = MDCategoryModel(dic:subDic as! NSDictionary)
                if showingCategoryArray.count < _canShowCategoryNum {
                    //
                    showingCategoryArray.addObject(model)
                }else{
                    canAddCategoryArray.addObject(model)
                }
                categoryArray.addObject(model)
            }
        }
    }


    func readCategoryCache(){




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



