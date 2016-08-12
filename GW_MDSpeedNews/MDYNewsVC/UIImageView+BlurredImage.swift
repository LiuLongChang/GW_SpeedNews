//
//  UIImageView+BlurredImage.swift
//  GW_MDSpeedNews
//
//  Created by langyue on 16/8/11.
//  Copyright © 2016年 刘隆昌. All rights reserved.
//

import Foundation
import UIKit




typealias BlurredImageCompletionBlock = Void->Void


let kBlurredImageDefaultBlurRadius  : CGFloat = 10.0
let kBlurredImageDefaultSaturationDeltaFactor : CGFloat = 0.9



extension UIImageView{


    func setImageToBlur(image:UIImage,completion:BlurredImageCompletionBlock?){

        self.setImageTOBlur(image, blurRadius: kBlurredImageDefaultBlurRadius, completion: completion)

    }



    func setImageTOBlur(image:UIImage,blurRadius:CGFloat,completion:BlurredImageCompletionBlock?){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let blurredImage = image.applyBlurWithRadius(blurRadius, tintColor: nil, saturationDeltaFactor: kBlurredImageDefaultSaturationDeltaFactor, maskImage: nil)
            dispatch_async(dispatch_get_main_queue(), {

                self.image = blurredImage
                if completion != nil {
                    completion!()
                }

            })


        }

    }



}
