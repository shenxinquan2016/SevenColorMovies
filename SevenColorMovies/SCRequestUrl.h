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
// 动态域名接口
#define DynamicDomainEntrance @"http://10.177.1.222:8050/entry?uid=21&oemid=30050&hid=741e93d05fc2&app_version=sksjd_1.0"
// homePage接口
#define HomePageUrl @"/filmlist?epgid=909191&spid=20151103&cpid=10001000&ctype=9"
// banner接口
#define BannerURL [NetUrlManager.domainName stringByAppendingString:url_Banner]
// 片单接口
#define FilmList [NetUrlManager.domainName stringByAppendingString:url_FilmList]
// filmClass接口
//#define FilmClass @"http://interface5.voole.com/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=gf201606271730129921467019536749"
// 点播播放接口
#define VODUrl  @"http://userauthb2b.voole.com/Service.do?action=b2bplayauth&pid=101001&playtype=0&checkproduct=0&checkuser=0&adversion=1.3.7&area=1208&hid=00301bba02db&oemid=30050&epgid=909191&spid=20151103&uid=0"

// 直播页接口
#define LivePageUrl @"/b2b/livetv/service.php?ctype=4&oemid=30050&uid=0&hid=58:48:22:6b:f3:009"
// 直播节目列表接口
#define LiveProgramList @"/b2b/livetv/service.php?ctype=12&tvid=14&oemid=30050"
// 获取直播节目播放流url接口
#define ToGetLiveVideoSignalFlowUrl @"/Service.do?action=b2bplayauth&playtype=1000&mid=1&sid=1&pid=1&uid=10&oemid=30050"
// 获取时移播放流接口
#define ToGetLiveTimeShiftVideoSignalFlowUrl @"/Service.do?action=b2bplayauth&playtype=1100&mid=1&sid=1&pid=1&uid=10&oemid=30050"
// 获取回看节目播放流url接口
#define ToGetProgramHavePastVideoSignalFlowUrl @"/Service.do?action=b2bplayauth&mid=1&sid=1&pid=1&playtype=1500&oemid=30050&hid=&uid=10"

// 电影 电视剧等 sourceUrl
#define FilmSourceUrl @"http://hljdesktop.voole.com/b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=4"
// 综艺 生活栏目  sourceUrl
#define ArtsAndLifeSourceUrl @"http://hljdesktop.voole.com/b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=102"
// 推荐影片接口
#define RecommendUrl @"http://10.177.1.236:9040?epgid=909191&format=1&type=1&limit=6"

// 筛选选项卡接口
#define FilterOptionTypeTabUrl @"http://10.177.1.236/b2b/itvservice/search.php?icoId=B2BSTBOXMovie|1413364584&epgid=909191&spid=20120528&cnt=&column=13346&ctype=100&mtype=6&v=3.0"
#define FilterOptionAreaAndTimeTab2Url @"http://10.177.1.236/b2b/itvservice/search.php?cate=&epgid=909191&cnt=5&spid=20120528&ctype=102&v=3.0"
// 筛选搜索
#define FilterUrl @"http://10.177.1.236/b2b/itvservice/search.php?pagesize=15&epgid=909191&spid=20151103&typekey=5&ctype=2&category=&search=&v=3.0"




#define testUrl @"http://interfaceclientzhibosy.voole.com/usrarea_2400/level_0/b2b/livetv/service.php?ctype=4&oemid=30050&uid=21&hid=001e4fed8159"


/******************************************影片搜索接口*******************************************/
// 点播搜索接口
#define SearchVODUrl @"http://10.177.1.235:8060/?serachtype=2&ispid=20151103&epgid=909191&field=&categoryid=&weight=&years=&limit=50&format=1&mtype="
// 回看搜获接口
#define SearchProgramHavePastUrl @"http://javasearchtest.voole.com:8060/live/?areaid=cwtest&uid=0&oemid=30050&hid=&limit=50"
// 获取channel logo接口
#define GetChannelLogoUrl @"http://10.177.1.236:9000/b2b/livetv/service.php?ctype=11&oemid=30050"

/***************************************观看记录管理接口*****************************************/
// 添加观看历史记录
#define AddWatchHistory @"http://10.177.1.236:8080/b2b/resume?ctype=2&spid=20151103&epgid=909191&uid=0&totalsid=999&&version=3.0"
// 查看观看历史记录
#define GetWatchHistory @"http://10.177.1.236:8080/b2b/resume?ctype=3&spid=20151103&epgid=909191&uid=0&orderby=1&version=3.0&pagesize=1000"
// 删除观看历史记录
#define DeleteWatchHistory @"http://10.177.1.236:8080/b2b/resume?ctype=4&spid=20151103&epgid=909191&uid=0&&ip=&&version=3.0"
// 删除全部历史记录
#define DeleteAllWatchHistory @"http://10.177.1.236:8080/b2b/resume?ctype=4&spid=20151103&epgid=909191&uid=0&version=3.0"
// 查看观看时间
#define GetTimeHaveWatched @"http://interface.voole.com/b2b/resume/service.php?ctype=1&spid=20151103&epgid=909191&uid=0&detailurl="


// 直播推屏时tvId转换
#define GetLiveNewTvId @"http://10.177.1.222:8095/b2b/search/getCodeByServiceId.htm?serviceId=new"




/***************************************云遥控器通信接口*****************************************/
#define CloudRemoteControl @"192.168.31.224:9099"









#endif /* SCRequestUrl_h */
