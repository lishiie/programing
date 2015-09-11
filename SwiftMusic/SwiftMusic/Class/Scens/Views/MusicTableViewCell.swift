
//
//  MusicTableViewCell.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/4.
//  Copyright © 2015年 李士杰. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var music_image: UIImageView!//音乐图片
    @IBOutlet weak var music_name: UILabel!//音乐名字
    @IBOutlet weak var music_Singer: UILabel!//歌手名
    
    //根据model进行赋值
    func setValueToCellWithModel(model:MusicModel) ->Void
    {
        self.music_image.sd_setImageWithURL(NSURL(string: model.picUrl), placeholderImage: UIImage(named: ""))
        self.music_name.text = model.name
        self.music_Singer.text = model.singer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
