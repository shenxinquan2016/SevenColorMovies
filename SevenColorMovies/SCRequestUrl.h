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
// homePage接口
#define HomePageUrl @"http://10.177.1.222:5040/filmlist?epgid=909191&spid=20151103&cpid=10001000&ctype=9"

// banner接口
#define BannerURL [NetUrlManager.domainName stringByAppendingString:url_Banner]
// 片单接口
#define FilmList [NetUrlManager.domainName stringByAppendingString:url_FilmList]
// filmClass接口
#define FilmClass @"http://interface5.voole.com/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=gf201606271730129921467019536749"
// 点播播放接口
#define VODUrl  @"http://10.177.1.245/Service.do?action=b2bplayauth&pid=101001&playtype=0&checkproduct=0&checkuser=0&adversion=1.3.7&area=1208&hid=00301bba02db&oemid=781&epgid=600111&spid=20120528&uid=0"

// 电影 电视剧等 sourceUrl
#define FilmSourceUrl @"http://10.177.1.236/b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=4"
// 综艺 生活栏目  sourceUrl
#define ArtsAndLifeSourceUrl @"http://10.177.1.236/b2b/filmlist.php?v=3.0&spid=20151103&epgid=909191&isad=0&ctype=102"
// 推荐影片接口
#define RecommendUrl @"http://10.177.1.236:9040?epgid=909191&format=1&type=1&limit=6"









#endif /* SCRequestUrl_h */
