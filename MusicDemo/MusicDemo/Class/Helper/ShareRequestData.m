//
//  ShareRequestData.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "ShareRequestData.h"
#import "MusicModel.h"

@interface ShareRequestData()
@property (nonatomic, strong)NSMutableArray * musicArray;

@end
@implementation ShareRequestData


+ (ShareRequestData *)sharedManager
{
    static  ShareRequestData * sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

/**
 *  懒加载的好处
 *
 *  1> 不必将创建对象的代码全部写在viewDidLoad方法中，代码的可读性更强
 *
 *  2> 每个属性的getter方法中分别负责各自的实例化处理，代码彼此之间的独立性强，松耦合
 *
 *  3>只有当真正需要资源时，再去加载，节省了内存资源。
 */
- (NSMutableArray *)musicArray
{
    //判断是否已经存在，若没有，则进行实例化
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

/**
 *  根据Url请求数据
 *
 *  @param url   接口地址
 *  @param block 回调数据,刷新页面
 *  @param view  在哪个view上显示加载"菊花"(MBProgessHUD)
 */
- (void)requestDataWithUrl:(NSString *)url musicBlock:(musicBlock)block toView:(UIView *)view
{
    [MBProgressHUD showMessage:@"正在加载" toView:view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
        
        for (NSDictionary * dic in array) {
            MusicModel * model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.musicArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
        });
    });
   
}

/**
 *  定义count就是为了不让存放数据的数组暴露出来,同时在tableView里面显示对应的行数
 */
-(NSInteger)count
{
    return _musicArray.count;
}


/**
 *  通过下标取出对应的Model
 *
 *  @param index 数组中的索引(下标)
 *
 *  @return 返回下标所对应的Model
 *
 */
- (MusicModel *)getModelWithIndePath:(NSInteger)index

{
    return _musicArray[index];
}


@end
