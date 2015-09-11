//
//  PlayerMusic.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MusicLyricModel;
@protocol PlayerMusicDelegate <NSObject>
/**
 *  PlayerMusic的代理
 *
 *  @param currentTime 正在播放的当前时间
 *  @param totalTime   总时间
 *  @param progress    进度
 */
- (void)playerMusicWithCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)progress;

/**
 *  播放结束
 */
- (void)playerMusicEnd;

@end

@interface PlayerMusic : NSObject

@property (nonatomic, weak)id <PlayerMusicDelegate>delegate;

+ (PlayerMusic *)sharedManager;
/**
 *  准备播放
 *
 *  @param url 播放音乐地址
 */
- (void)preparePlayMusicWithUrl:(NSString *)url;

/**
 *  暂停
 */
- (void)pauseMusic;

/**
 *  播放
 */
- (void)playMusic;

/**
 *  根据slider滑动改变播放进度
 *
 *  @param progress slider的value
 */
- (void)bySliderVauleChangeProgress:(CGFloat)progress;

/**
 *  歌词
 *
 *  @param lyric <#lyric description#>
 *
 *  @return <#return value description#>
 *
 *  @exception <#exception description#>
 */
- (NSArray *)allLyricItemWithLyric:(NSString *)lyric;

- (NSInteger)byTimeFetchIndexToLyric:(NSString *)time;

@end
