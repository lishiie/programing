//
//  PlayerMusic.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "PlayerMusic.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicLyricModel.h"
@interface PlayerMusic()
@property (nonatomic, strong)AVPlayer * player;
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, strong)NSMutableArray * allLyricArray;
@end

@implementation PlayerMusic
+ (PlayerMusic *)sharedManager
{
    static  PlayerMusic * sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

//在init里面初始化AVPlayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //让app支持接受远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

//准备播放
- (void)preparePlayMusicWithUrl:(NSString *)url
{
    if (!url) {
        return;
    }
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

//观察AVPlayerItem播放状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
    switch (status) {
        case AVPlayerStatusFailed:
//            NSLog(@"播放失败");
            break;
        case AVPlayerStatusReadyToPlay:
//            NSLog(@"可以播放");
            [self playMusic];
            break;
        case AVPlayerStatusUnknown:
//            NSLog(@"未知错误");
            break;
            
        default:
            break;
    }
}


//暂停音乐
- (void)pauseMusic
{
    [self.player pause];
   
    [self.timer invalidate];
    self.timer = nil;
}

//播放音乐
- (void)playMusic
{
    [self.player play];
     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fetchProgress) userInfo:nil repeats:YES];
   
}

//NSTimer一直执行此方法
- (void)fetchProgress
{
    if ([self.delegate respondsToSelector:@selector(playerMusicWithCurrentTime:totalTime:progress:)]) {
        [self.delegate playerMusicWithCurrentTime:[self timeChangesString:[self fetchCurrentTime]] totalTime:[self timeChangesString:[self fetchTotalTime]] progress:[self fetchProgressTime]];
    }

}


//获取当前时间
- (NSInteger)fetchCurrentTime
{
    CMTime time = self.player.currentTime;
    if (time.timescale == 0) {
        return 0;
    }
    return time.value / time.timescale;
}

//获取总时间
- (NSInteger)fetchTotalTime
{
     CMTime time = self.player.currentItem.duration;
    if (time.timescale == 0) {
        return 0;
    }
    return time.value / time.timescale;
}

//获取进度
- (CGFloat)fetchProgressTime
{
    return (CGFloat)[self fetchCurrentTime] / (CGFloat)[self fetchTotalTime];
}

//把秒数转换为时间格式00:00
- (NSString *)timeChangesString:(NSInteger)time
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",time / 60,time % 60];
}

//通过滑动slider来改变播放进度
- (void)bySliderVauleChangeProgress:(CGFloat)progress
{
    //滑动slider 的时候用该把音乐暂停
    [self pauseMusic];
    [self.player seekToTime:CMTimeMake(progress * [self fetchTotalTime], 1) completionHandler:^(BOOL finished) {
        //完成滑动的时候再把音乐打开
        if (finished) {
            [self playMusic];
        }
    }];
}


- (NSMutableArray *)allLyricArray
{
    if (!_allLyricArray) {
        _allLyricArray = [NSMutableArray array];
    }
    return _allLyricArray;
}


- (NSArray *)allLyricItemWithLyric:(NSString *)lyric
{
    //进来之前首先删除所有的歌词,(因为每次换下首歌歌词都不一样)
    [self.allLyricArray removeAllObjects];
    //组件分离
    NSArray * contentArray = [lyric componentsSeparatedByString:@"\n"];
    for (NSString * contentStr in contentArray) {
        NSArray * temparray = [contentStr componentsSeparatedByString:@"]"];
        //安全判断
        if ([temparray.firstObject length] < 1) {
            break;
        }
        NSString * timeStr = [temparray.firstObject substringFromIndex:1];
        NSArray * timeArray = [timeStr componentsSeparatedByString:@"."];
        NSString * lyricTimeStr = timeArray.firstObject;
        NSString * lyricStr = temparray.lastObject;
        MusicLyricModel * model = [[MusicLyricModel alloc] initWithLyricTime:lyricTimeStr lyricStr:lyricStr];
        [self.allLyricArray addObject:model];

    }
    return _allLyricArray;
}

/**
 *  通过时间找到数组存放歌词的下标
 */

- (NSInteger)byTimeFetchIndexToLyric:(NSString *)time
{
    NSInteger index = -1;
    for (int i = 0; i < self.allLyricArray.count -1; i ++) {
        MusicLyricModel * model = self.allLyricArray[i];
        NSLog(@"model :%@  ,time%@",model.lyricTime,time);
        if ([model.lyricTime isEqualToString:time]) {
            index = i;
            NSLog(@"%ld",index);
            return index;
        }
    }
    return index;
}

- (void)playerEnd
{
    if ([self.delegate respondsToSelector:@selector(playerMusicEnd)]) {
        [self.delegate playerMusicEnd];
    }
}










@end
