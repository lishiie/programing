//
//  PlayerManager.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/4.
//  Copyright © 2015年 李士杰. All rights reserved.
//

import UIKit
import AVFoundation
extension Int64 {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}
@objc protocol playerManagerDelegate
{
    //音乐播放结束代理
    func playerManagerMusicPlayToEnd() ->Void
    //音乐播放进度,播放总时间等代理
    func playerMusicWithCurrentTime(currentTime currentTime:String,totaTime:String,progress:Float) ->Void
    
}

class PlayerManager: NSObject {


    internal static let singleton:PlayerManager = PlayerManager()
    //初始化AVPlayer
    var player: AVPlayer?
    //声明代理
    var delegate:playerManagerDelegate?
    //定时器
    var timer:NSTimer?
    //存放歌词Model的数组
    var allLyricArray:NSMutableArray = NSMutableArray()
    
    
    //重写父类init方法
    override init() {
        super.init()
        //初始化AVplayer
        self.player = AVPlayer()
        //监听播放结束
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"playMusicToEnd", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }

    //根据Url播放音乐
    func preparePlayMusicWithUrl(MusicUrl : String) ->Void
    {
        
        //判断是否有item在播放
        if self.player?.currentItem != nil
        {   //如果有先移出原来观察的对象
            self.player?.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
        }
        //初始化item给一个Url
        let item = AVPlayerItem.init(URL: NSURL(string: MusicUrl)!)
        //添加观察者
        item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        //替换播放item
        self.player?.replaceCurrentItemWithPlayerItem(item)
    }
   //音乐播放结束监听
    func playMusicToEnd() ->Void{
        self.delegate?.playerManagerMusicPlayToEnd()
    }
    
    //播放音乐
    func playMusic() ->Void
    {
        self.player?.play()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "monitorPlayMusic", userInfo: nil, repeats: true)
    }
    //暂停音乐
    func pauseMusic() ->Void
    {
        self.player?.pause()
        self.timer?.invalidate()
        self.timer = nil
        
    }

     override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
         self.playMusic()
    }
    //一直监听音乐播放
    func monitorPlayMusic() ->Void
    {
        self.delegate?.playerMusicWithCurrentTime(currentTime:self.secondChangaString(self.fetchCurrentTimeValue()), totaTime: self.secondChangaString(self.fetchTotalTimeValue()), progress: self.fetchProgressValue())
    }
    //获取播放音乐当前时间
    func fetchCurrentTimeValue() ->Int64
    {
        let time: CMTime = (self.player?.currentTime())!
        
        if (time.timescale == 0){
            return 0
        }else{
            return Int64(time.value) / Int64(time.timescale)
        }
    }
    //获取音乐总时间
    func fetchTotalTimeValue() ->Int64
    {
        let time:CMTime = (self.player?.currentItem?.duration)!
        if (time.timescale == 0){
            return 0
        }else{
            return Int64(time.value) / Int64(time.timescale)
        }
    }
    //获取进度
    func fetchProgressValue() ->Float
    {
        return Float(self.fetchCurrentTimeValue()) / Float(self.fetchTotalTimeValue())
    }
    //把秒数转化为时间格式00:00
    func secondChangaString(time:Int64) ->String{
          let minute = time / 60
        let second = time % 60
        return "\(minute):\(second)"
        
    }
    //根据滑动的进度播放音乐
    func bySliderVauleChangeProgress(progress:Float) ->Void
    {
        self.pauseMusic()
        
        let totalTime = self.fetchTotalTimeValue() * 100
        let intProgress = Int64(progress * 100)
        let CurrentTime = (intProgress * totalTime) / 10000
        
        self.player?.seekToTime(CMTimeMake(CurrentTime, 1), completionHandler: { (finshed:Bool) -> Void in
            if finshed == true
            {
                self.playMusic()
            }
        })
        print("总时间:\(totalTime) 进度:\(CurrentTime)")
    }
    //返回数组中存放的是歌词的Model
    func byLyricCutTimeAndLyricStr(lyric:String) ->NSMutableArray
    {
        self.allLyricArray.removeAllObjects()
        //组件分离
        let contenArray = lyric.componentsSeparatedByString("\n")
        for contenStr in contenArray
        {
            let tempArray = contenStr.componentsSeparatedByString("]")

            let str:Int = tempArray[0].lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            if str < 1{
                break
            }
        }
        return self.allLyricArray
    }

}

