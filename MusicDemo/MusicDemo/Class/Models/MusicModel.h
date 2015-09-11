//
//  MusicModel.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, strong)NSString *lyric;//歌词、

@property (nonatomic, assign)NSInteger ID; //歌曲的ID

@property (nonatomic, assign)NSInteger duration;

@property (nonatomic, assign)NSString *blurPicUrl;

@property (nonatomic, strong)NSString *artists_name;

@property (nonatomic, strong)NSString *album;

@property (nonatomic, strong)NSString *mp3Url; //播放URL

@property (nonatomic, strong)NSString *name;    //歌曲名字

@property (nonatomic, strong)NSString *picUrl;

@property (nonatomic, strong)NSString *singer;

@end
