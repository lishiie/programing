//
//  MusicTableViewCell.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "MusicModel.h"
@interface MusicTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *music_Image;//音乐图片

@property (weak, nonatomic) IBOutlet UILabel *music_name;//音乐名字

@property (weak, nonatomic) IBOutlet UILabel *music_Singer;//歌手名字

@end

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setValueWithModel:(MusicModel *)model
{
    [self.music_Image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.music_name.text = model.name;
    self.music_Singer.text = model.singer;
     
}



@end
