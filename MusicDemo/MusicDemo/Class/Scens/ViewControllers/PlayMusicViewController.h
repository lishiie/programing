//
//  PlayMusicViewController.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

@interface PlayMusicViewController : UIViewController

+ (PlayMusicViewController *)sharedManager;

@property (nonatomic, assign)NSInteger musicIdex;//点击cell的下标

@end
