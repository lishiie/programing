//
//  MusicPlayViewController.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/4.
//  Copyright © 2015年 李士杰. All rights reserved.
//

import UIKit

class MusicPlayViewController: UIViewController,playerManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var currentLable: UILabel!//当前时间
    @IBOutlet weak var musicSlider: UISlider!//进度条
    @IBOutlet weak var totalLable: UILabel!//总时间
    @IBOutlet weak var musicImage: UIImageView!//音乐图片
    @IBOutlet weak var lyricTableView: UITableView!//歌词TableVeiw
    var indexRow: Int!//存放上个页面的值
    var tempIndex: Int!//暂时存放
    var musicModel:MusicModel!//存放音乐的Model
    //单利
    internal static let sharedSinger:MusicPlayViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("musicPlay_id") as! MusicPlayViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tempIndex = -1
        PlayerManager.singleton.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.musicSlider.value = 1;
        self.lyricTableView.dataSource = self
        self.lyricTableView.delegate = self
    }
    //页面即将进入的时候
    override func viewWillAppear(animated: Bool) {
        if self.tempIndex == self.indexRow{
            return
        }
        self.playMusic()
    }
    
    //播放音乐
    func playMusic () ->Void{
        self.tempIndex = self.indexRow
        //通过下标获取model
        self.musicModel = (ShareRequestData.singleton.getModelWithIndex(self.indexRow))
        //根据URL播放音乐
        PlayerManager.singleton.preparePlayMusicWithUrl(musicModel.mp3Url)
        //显示音乐图片
        self.musicImage .sd_setImageWithURL(NSURL.init(string: musicModel.picUrl))
        self.musicImage.layoutIfNeeded()
        self.musicImage.clipsToBounds = true
        self.musicImage.layer.cornerRadius = self.musicImage.frame.size.height / 2
        
        
        
    }
    
    //播放/暂停按钮
    @IBAction func pauseAction( sender: UIButton) {
     //判断是暂停还是播放
        if sender.selected
        {
            sender.selected = !sender.selected
            sender.setTitle("暂停", forState: UIControlState.Normal)
            PlayerManager.singleton.playMusic()
        }else{
            sender.selected = !sender.selected
            sender.setTitle("播放", forState: UIControlState.Normal)
            PlayerManager.singleton.pauseMusic()
            
        }
    }
    
    //上一首
    @IBAction func lastAction(sender: AnyObject) {
        self.lastMusic()
    }
    
    //下一首点击按钮
    @IBAction func nextAction(sender: AnyObject) {
        self.nextMusic()
    }
    //音乐播放结束之后
    func playerManagerMusicPlayToEnd() {

        self.nextMusic()
    }
    
    //下一首方法
    func nextMusic() ->Void
    {
        let row = ShareRequestData.singleton.allDataMutableArray.count - 1
        
        if (self.indexRow < row){
            self.indexRow = self.indexRow + 1
        }else{
            self.indexRow = 0
        }
        self.playMusic()
    }
    //上一首方法
    func lastMusic () ->Void
    {
        if (self.indexRow > 0){
            self.indexRow = self.indexRow - 1
        }else{
            let row = ShareRequestData.singleton.allDataMutableArray.count
            
            self.indexRow = row - 1
        }
        self.playMusic()
    }
    
    //监听播放进度代理
    func playerMusicWithCurrentTime(currentTime currentTime: String, totaTime: String, progress: Float) {
//        print("当前时间:\(currentTime) 总时间:\(totaTime) 进度:\(progress)")
        self.currentLable.text = currentTime
        self.totalLable.text = totaTime
        self.musicSlider.value = progress
    }
    //滑动滑竿事件
    @IBAction func sliderAction(sender: UISlider) {
//        print("\(sender.value)")
        PlayerManager.singleton.bySliderVauleChangeProgress(sender.value)
        
    }
    
    //代理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableView_cell")
       PlayerManager.singleton.byLyricCutTimeAndLyricStr(self.musicModel.lyric)

        return (cell)!
    }
}
