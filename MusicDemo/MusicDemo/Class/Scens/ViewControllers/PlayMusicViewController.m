//
//  PlayMusicViewController.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "PlayerMusic.h"
#import "MusicModel.h"
#import "ShareRequestData.h"
#import "MusicLyricModel.h"
@interface PlayMusicViewController()<PlayerMusicDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)NSInteger tempIndex;//存放点击cell下标

@property (weak, nonatomic) IBOutlet UIImageView *music_Image;//音乐图片

@property (weak, nonatomic) IBOutlet UITableView *LyricTableView;//显示歌词的cell

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;//显示进度条的slider

@property (weak, nonatomic) IBOutlet UILabel *currentLable;//显示正在播放的当前时间控件

@property (weak, nonatomic) IBOutlet UILabel *totalLable;//显示该音乐总时间的控件

//@property (nonatomic, strong)CABasicAnimation *rotationAnimation;//旋转图片

@property (nonatomic, strong)MusicModel * musicModel;

@end

@implementation PlayMusicViewController

/**
 *  单利控制器:为了保证这个控制器永远只有一个对象
 *
 */
+ (PlayMusicViewController *)sharedManager
{
    static  PlayMusicViewController * sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"playMusic_VC"];
    });
    return sharedManager;
}

/**
 *  当视图将要显示的时候,因为单利控制器只走一次ViewDidload.
 */
- (void)viewWillAppear:(BOOL)animated
{
    //判断是否为当前播放对象
    //若果是不做其他操作
    if (self.tempIndex == self.musicIdex) {
        return;
    }
    //否则重新加载数据
    [self play];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tempIndex = -1;//为了判断所以给它设定为初值-1(因为0在计数器中以nil对象来代替,所以如果上个页面传值过来的是0,那么计入判断条件的时候index就为nil对象)
    self.automaticallyAdjustsScrollViewInsets = NO;//iOS 8.0之后所有的scrollerView的子类都会向下偏移64个像素
    [self.music_Image layoutIfNeeded];//重新j
    self.music_Image.clipsToBounds = YES;
    //设置圆角
    self.music_Image.layer.cornerRadius = self.music_Image.frame.size.width/ 2;
    
    [PlayerMusic sharedManager].delegate = self;
    self.LyricTableView.delegate = self;
    self.LyricTableView.dataSource = self;
    self.LyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressSlider.value = 0;
    
}

/**
 *  播放音乐
 */
- (void)play
{
    self.musicModel = [[ShareRequestData sharedManager] getModelWithIndePath:self.musicIdex];
    [[PlayerMusic sharedManager] preparePlayMusicWithUrl:self.musicModel.mp3Url];
    [self.music_Image sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
    self.tempIndex = self.musicIdex;
    [self.LyricTableView reloadData];
}

//上一首
- (IBAction)lastMusicAction:(id)sender {
    if (self.musicIdex > 0) {
        self.musicIdex --;
    }else
    {
        self.musicIdex = [ShareRequestData sharedManager].count - 1;
    }
    [self play];
}

//下一首
- (IBAction)nextMusicAction:(id)sender {
    
    if (self.musicIdex < [ShareRequestData sharedManager].count - 1) {
        self.musicIdex ++;
    }else
    {
        self.musicIdex = 0;
    }
    [self play];
}

//暂停/播放
- (IBAction)pauseOrPlayMusicAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = !sender.selected;
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
        [[PlayerMusic sharedManager] playMusic];
    }else
    {
        sender.selected = !sender.selected;
        [[PlayerMusic sharedManager] pauseMusic];
        [sender setTitle:@"播放" forState:(UIControlStateNormal)];
    }
}

/**
 *  UISlider的拖动事件
 */
- (IBAction)progressAction:(UISlider *)sender {
    NSLog(@"%f",sender.value);
    [[PlayerMusic sharedManager] bySliderVauleChangeProgress:sender.value];
    
}


#pragma mark -- PlayerMusicDelegate
//获取进度条,开始时间,总时间等代理
-(void)playerMusicWithCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)progress
{
    self.currentLable.text = currentTime;
    self.totalLable.text = totalTime;
    self.progressSlider.value = progress;
    //滚动歌词
    NSInteger index = [[PlayerMusic sharedManager]byTimeFetchIndexToLyric:currentTime];
    if (index == -1) {
        return;
    }
    [self.LyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    CGAffineTransformRotate(self.music_Image.transform, M_PI / 181);
}

/**
 *  让音乐图片旋转
 */
- (void)musicImageTransForm
{
    //旋转动画
//    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    self.rotationAnimation.delegate = self;
//    self.rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI *2.0];
//    self.rotationAnimation.duration = MAX_CANON;
//    self.rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [self.rotationAnimation setValue:@"rotationAnimation" forKey:@"MyAnimationType"];
//    [self.music_Image.layer addAnimation:self.rotationAnimation forKey:@""];
}

#pragma mark --tableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PlayerMusic sharedManager] allLyricItemWithLyric:self.musicModel.lyric].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lyric_cell"];
    MusicLyricModel * model = [[PlayerMusic sharedManager] allLyricItemWithLyric:self.musicModel.lyric][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = model.lyricStr;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.selectedBackgroundView = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    return cell;
}

//监听音乐播放完成代理
-(void)playerMusicEnd
{
    
    [self nextMusicAction:nil];
}
@end
