//
//  ShareRequestData.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/2.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

import UIKit

@objc protocol ShareRequestDataDelegate
{
    func shareRequestDataUpdateUI()
}

class ShareRequestData: NSObject {

    internal static let singleton:ShareRequestData = ShareRequestData()
    
    var allDataMutableArray = NSMutableArray()
    
    var delegate:ShareRequestDataDelegate?
    
  
    //请求数据
    func requestDataWithUrl(musicUrl:String,toView:UIView) {
        MBProgressHUD.showMessage("正在加载", toView: toView)
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            let url = NSURL(string: musicUrl)
            
            let array = NSMutableArray(contentsOfURL: url!)
            
            for item1 in array! {
                let music = MusicModel()
                music.setValuesForKeysWithDictionary(item1 as! [String : AnyObject])
                
                self.allDataMutableArray.addObject(music)
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.shareRequestDataUpdateUI()
                MBProgressHUD.hideHUDForView(toView, animated: true)
            });

        });
 
    }
    //通过下标返回model
    func getModelWithIndex (index:NSInteger) ->(MusicModel)
    {
        return self.allDataMutableArray[index] as! (MusicModel)
    }
}
