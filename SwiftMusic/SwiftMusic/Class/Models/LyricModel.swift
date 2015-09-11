//
//  LyricModel.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/7.
//  Copyright © 2015年 李士杰. All rights reserved.
//

import UIKit

class LyricModel: NSObject {
    var lyricTime = ""
    var lyricStr = ""
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
     init(time:String,lyricString:String)
    {
            self.lyricStr = lyricString
            self.lyricTime = time
    }
}
