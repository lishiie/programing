//
//  MusicLyricModel.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "MusicLyricModel.h"

@implementation MusicLyricModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithLyricTime:(NSString *)lyricTime lyricStr:(NSString *)lyricStr
{
    self = [super init];
    if (self) {
        self.lyricTime = lyricTime;
        self.lyricStr = lyricStr;
    }
    return self;
}
@end
