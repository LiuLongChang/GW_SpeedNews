//
//  BlurHelp.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/11.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import Foundation
import UIKit



class BlurHelp: NSObject {



    class func getImageFromView(view:UIView)->UIImage{

        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image

    }


    class func getRandomColor()->UIColor {

        return UIColor.init(red: (1+CGFloat(arc4random()%99))/100, green: (1+CGFloat(arc4random()%99))/100, blue: (1+CGFloat(arc4random()%99))/100, alpha: 1)

    }


    class func lerp(percent:Float,nMin:Float,nMax:Float)->Float{
        var result = nMin
        result = nMin + percent * ( nMax - nMin)
        return result
    }


}