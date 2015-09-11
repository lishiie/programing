//
//  MusicListTableViewController.m
//  MusicDemo
//
//  Created by 李士杰 on 15/9/1.
//  Copyright (c) 2015年 李士杰. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicTableViewCell.h"
#import "ShareRequestData.h"
#import "PlayerMusic.h"
#import "MusicModel.h"
#import "PlayMusicViewController.h"
@interface MusicListTableViewController ()

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"music_cell"];
    [[ShareRequestData sharedManager] requestDataWithUrl:kMusicUrl musicBlock:^{
        [self.tableView reloadData];
        
    }toView:self.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [ShareRequestData sharedManager].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music_cell" forIndexPath:indexPath];
    [cell setValueWithModel:[[ShareRequestData sharedManager] getModelWithIndePath:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayMusicViewController *playVC = [PlayMusicViewController sharedManager];
        playVC.musicIdex = indexPath.row;
    [self.navigationController showViewController:playVC sender:nil];
    NSLog(@"%ld",indexPath.row);
    
}
@end
