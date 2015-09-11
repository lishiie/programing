//
//  MusicTableViewCell.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface MusicTableViewCell : UITableViewCell

/**
 *  通过model进行赋值
 *
 *  @param model 音乐的模型
 */
- (void)setValueWithModel:(MusicModel *)model;

@end
