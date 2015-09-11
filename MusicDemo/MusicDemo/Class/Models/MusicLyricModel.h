//
//  MusicLyricModel.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLyricModel : NSObject
@property (nonatomic, strong)NSString * lyricTime;//歌词的时间
@property (nonatomic, strong)NSString * lyricStr;//每段歌词

- (instancetype)initWithLyricTime:(NSString *)lyricTime lyricStr:(NSString*)lyricStr;
@end
