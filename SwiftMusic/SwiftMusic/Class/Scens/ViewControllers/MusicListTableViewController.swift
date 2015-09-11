//
//  MusicListTableViewController.swift
//  SwiftMusic
//
//  Created by 李士杰 on 15/9/4.
//  Copyright © 2015年 李士杰. All rights reserved.
//

import UIKit

class MusicListTableViewController: UITableViewController , ShareRequestDataDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        //注册自定义cell
        self.tableView.registerNib(UINib.init(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_id")
        //请求数据
        ShareRequestData.singleton.requestDataWithUrl(kUrls,toView: self.view)
        //绑定代理
        ShareRequestData.singleton.delegate = self
    }
    
    //返回分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    //返回行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ShareRequestData.singleton.allDataMutableArray.count
    }

    //返回cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : MusicTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell_id", forIndexPath: indexPath) as! MusicTableViewCell

        cell.setValueToCellWithModel(ShareRequestData.singleton.getModelWithIndex(indexPath.row))
        let model = ShareRequestData.singleton.getModelWithIndex(indexPath.row)
        print(model.mp3Url)
        return cell
    }
    
    //shareRequestData代理 为了刷新UI
    func shareRequestDataUpdateUI() {
        
        self.tableView.reloadData()
    }
    //点击cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let musicPlayVC = MusicPlayViewController.sharedSinger
        musicPlayVC.indexRow = indexPath.row
        self.navigationController?.pushViewController(musicPlayVC, animated: true)
        
    }
}
