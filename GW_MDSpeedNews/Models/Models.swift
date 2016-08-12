//
//  Models.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/12.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import Foundation



class MDCategoryModel: NSObject {


    var dic : NSDictionary! = nil
    var tid : String! = ""
    var tname : String! = ""

    convenience init(dic: NSDictionary) {
        self.init()
        self.dic = dic
        self.tid = dic["tid"] as! String
        self.tname = dic["tname"] as! String
    }

}




