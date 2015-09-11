//
//  ShareRequestData.h
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
typedef void (^musicBlock)();
@interface ShareRequestData : NSObject

/**
 *  定义count就是为了不让存放数据的数组暴露出来,同时在tableView里面显示对应的行数
 */
@property (nonatomic, assign)NSInteger count;//数组中的元素
/**
 *  单利;就是为了保证每一次进去就一个音乐器在播放.
 */
+ (ShareRequestData *)sharedManager;

/**
 *  根据Url请求数据
 *
 *  @param url   接口地址
 *  @param block 回调数据,刷新页面
 *  @param view  在哪个view上显示加载"菊花"(MBProgessHUD)
 */
- (void)requestDataWithUrl:(NSString *)url musicBlock:(musicBlock)block toView:(UIView *)view;

/**
 *  通过下标取出对应的Model
 *
 *  @param index 数组中的索引(下标)
 *
 *  @return 返回下标所对应的Model
 *
 */
- (MusicModel *)getModelWithIndePath:(NSInteger)index;

@end
