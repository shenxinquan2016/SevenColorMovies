//
//  SCRequestUrl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef SCRequestUrl_h
#define SCRequestUrl_h

/******************************************首页接口的URL*******************************************/
// bannerURL
#define url_Banner @"/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=cate_EPG50sy_EPG50syjdlbt_liaoningyidong"
// 片单URL
#define url_FilmList @"/b2b/filmlist.php?v=3.0&epgid=600111&spid=20120528"



/******************************************首页接口*******************************************/
// 动态域名接口  内网
//#define DynamicDomainEntrance @"http://10.177.1.222:8050/entry?uid=21&oemid=30050&hid=741e93d05fc2&app_version=sksjd_1.0"

// 动态域名接口  外网
//#define DynamicDomainEntrance @"http://125.223.98.233:40398/entry?uid=21&oemid=30118&hid=741e93d05fc2&app_version=sksjd_outernet"
#define DynamicDomainEntrance @"http://scc.96396.cn:31002/entry?uid=21&oemid=30118&app_version=sksjd_outernet_www"

// homePage接口
#define HomePageUrl @""
// banner接口
#define BannerURL [NetUrlManager.domainName stringByAppendingString:url_Banner]
// 片单接口
#define FilmList [NetUrlManager.domainName stringByAppendingString:url_FilmList]
// filmClass接口
//#define FilmClass @"http://interface5.voole.com/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=gf201606271730129921467019536749"
// 点播播放接口
#define VODUrl @""

// 直播页接口
#define LivePageUrl @""
// 直播节目列表接口
#define LiveProgramList @""
// 获取直播节目播放流url接口
#define ToGetLiveVideoSignalFlowUrl @""
// 获取时移播放流接口
#define ToGetLiveTimeShiftVideoSignalFlowUrl @""
// 获取回看节目播放流url接口
#define ToGetProgramHavePastVideoSignalFlowUrl @""

// 电影 电视剧等 sourceUrl
#define FilmSourceUrl @"" //  /b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=4
// 综艺 生活栏目  sourceUrl
#define ArtsAndLifeSourceUrl @"" //  /b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=102
// 推荐影片接口
#define RecommendUrl @"" //  ?epgid=909191&format=1&type=1&limit=6

// 筛选选项卡接口
#define FilterOptionTypeTabUrl @"" //  /b2b/itvservice/search.php?icoId=B2BSTBOXMovie|1413364584&epgid=909191&spid=20120528&cnt=&column=13346&ctype=100&mtype=6&v=3.0
#define FilterOptionAreaAndTimeTab2Url @""  //  /b2b/itvservice/search.php?cate=&epgid=909191&cnt=5&spid=20120528&ctype=102&v=3.0
// 筛选搜索
#define FilterUrl @""  //  /b2b/itvservice/search.php?pagesize=15&epgid=909191&spid=20151103&typekey=5&ctype=2&category=&search=&v=3.0




#define testUrl @"http://interfaceclientzhibosy.voole.com/usrarea_2400/level_0/b2b/livetv/service.php?ctype=4&oemid=30050&uid=21&hid=001e4fed8159"


/******************************************影片搜索接口*******************************************/
// 点播搜索接口
#define SearchVODUrl @"" //  /?serachtype=2&ispid=20151103&epgid=909191&field=&categoryid=&weight=&years=&limit=50&format=1&mtype=
// 回看搜获接口
#define SearchProgramHavePastUrl @""  //  /live/?areaid=cwtest&uid=0&oemid=30050&hid=&limit=50
// 获取channel logo接口
#define GetChannelLogoUrl @""  //  /b2b/livetv/service.php?ctype=11&oemid=30050

/***************************************观看记录管理接口*****************************************/
// 添加观看历史记录
#define AddWatchHistory @""  //  /b2b/resume?ctype=2&spid=20151103&epgid=909191&uid=0&totalsid=999&&version=3.0
// 查看观看历史记录
#define GetWatchHistory @""  //  /b2b/resume?ctype=3&spid=20151103&epgid=909191&uid=0&orderby=1&version=3.0&pagesize=1000
// 删除观看历史记录
#define DeleteWatchHistory @""  //  /b2b/resume?ctype=4&spid=20151103&epgid=909191&uid=0&&ip=&&version=3.0
// 删除全部历史记录
#define DeleteAllWatchHistory @""  // /b2b/resume?ctype=4&spid=20151103&epgid=909191&uid=0&version=3.0
// 查看观看时间
#define GetTimeHaveWatched @"http://interface.voole.com/b2b/resume/service.php?ctype=1&spid=20151103&epgid=909191&uid=0&detailurl="


// 直播推屏时tvId转换  该接口直返回完整地址
#define GetLiveNewTvId @""

// 数据采集接口 黑网内网
#define CollectCustomerBehaviorData @"http://scc.96396.cn:10013/appjh_mmserver/gather/addDatasIos.do"

/***************************************萌娃*****************************************/
#define LovelyBabyLogin @"http://125.223.98.233:10013/appjh_mmserver/member/login.do" // 登录
#define LovelyBabyRegister @"http://125.223.98.233:10013/appjh_mmserver/member/addMember.do" // 注册
#define LovelyBabyVideoList @"http://125.223.98.233:10013/appjh_mmserver/paikeInfo/searchInfo.do" // 视频列表
#define LovelyBabyVideoDetailInfo @"http://125.223.98.233:10013/appjh_mmserver/paikeInfo/searchDetails.do" // 视频详情
#define LovelyBabyVote @"http://125.223.98.233:10013/appjh_mmserver/vote/userVote.do"  // 投票
#define LovelyBabyVideoUpload @"http://125.223.98.233:10013/appjh_mmserver/upload/makingUpload.do?" // 视频上传
#define LovelyBabyVideoTask @"http://125.223.98.233:10013/appjh_mmserver/paikeInfo/searchTask.do?" // 拍客任务列表
#define LovelyBabyDeleteVideo @"http://125.223.98.233:10013/appjh_mmserver/paikeInfo/delPaikeData.do?" // 删除视频

/***************************************语音控器通信接口*****************************************/
#define CloudRemoteControl @"192.168.31.224:9099"









#endif /* SCRequestUrl_h */
