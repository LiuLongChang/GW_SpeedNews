//
//  MDSetViewController.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/12.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit

class MDSetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()


        let tapGes = UITapGestureRecognizer(target: self,action: #selector(MDSetViewController.tapGes(_:)))
        view.addGestureRecognizer(tapGes)




        let viewBg = UIView(frame: CGRectMake(ScreenWidth/2,0,ScreenWidth/2,ScreenHeight))
        view.addSubview(viewBg)
        viewBg.backgroundColor = UIColor.blueColor()


    }


    func tapGes(tap:UITapGestureRecognizer){


        //Close Side Bar
        MDYSliderVC.sharedInstance.closeSideBar()



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
