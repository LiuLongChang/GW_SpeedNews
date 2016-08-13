//
//  GWDeleteButton.swift
//  GW_MDSpeedNews
//
//  Created by 刘隆昌 on 16/8/13.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import UIKit


enum GWDeleteButtonStatus : Int {
    case Normal = 0,NeverDelete,CanDelete
}

class GWDeleteButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var _deleteStatus : GWDeleteButtonStatus?
    var deleteStatus : GWDeleteButtonStatus?{
        
        set{
            if _deleteStatus == GWDeleteButtonStatus.NeverDelete {
                return
            }
            switch deleteStatus!.rawValue {
            case GWDeleteButtonStatus.Normal.rawValue:
                
                smallDeleteButton?.hidden = true
                
            case GWDeleteButtonStatus.NeverDelete.rawValue:
                
                smallDeleteButton?.hidden = true
                
            case GWDeleteButtonStatus.CanDelete.rawValue:
                
                smallDeleteButton?.hidden = false
            
            default:
                break
            }
            _deleteStatus = deleteStatus
        }
        get{
            return _deleteStatus
        }
        
    }
    
    
    
    
    
    var _smallDeleteButton : UIButton?
    var smallDeleteButton : UIButton?{
    
        set{
            _smallDeleteButton = newValue
        }
        get{
            
            if _smallDeleteButton == nil {
             
                _smallDeleteButton = UIButton(type:.Custom)
                _smallDeleteButton?.frame = CGRectMake(self.frame.size.width - 13, -6, 19, 19)
                _smallDeleteButton?.setImage(UIImage(named: "close"), forState: .Normal)
                self.addSubview(_smallDeleteButton!)
            }
            return _smallDeleteButton
            
        }
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
