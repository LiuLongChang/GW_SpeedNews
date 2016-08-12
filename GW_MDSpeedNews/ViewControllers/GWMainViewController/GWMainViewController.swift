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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.redColor()




        let imgView = UIImageView()
        imgView.frame = CGRectMake(0, 100, ScreenWidth,ScreenWidth/284*177)
        view.addSubview(imgView)
        imgView.image = UIImage(named: "images.jpeg")


        
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
