# YHCImageViewer

一个简单的图片浏览器，基本功能已具备，方便二次开发

![image](https://github.com/yhcflyy/YHCImageViewer/blob/master/screenShot/QQ20170301-161656.gif)
使用方法

YHCImageBrowser *browser = [[YHCImageBrowser alloc]init];
browser.mArrData = @[@"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",
                         @"http://img.zcool.cn/community/01445b56f1ef176ac7257d207ce87d.jpg@900w_1l_2o_100sh.jpg",
                         @"http://img4.duitang.com/uploads/item/201507/30/20150730163204_A24MX.thumb.700_0.jpeg",
                         @"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",
                         @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/29/c2/10087294_10087294_1325133605031_mthumb.jpg"].mutableCopy;
[browser show:CGRectZero];

说明：如果加载网络图片时有缩略图可将缩略图的连接赋值到mArrFilted数组，YHCImageBrowser的show函数有一个CGRect的入参，如果需要显示动画则将点击图片的frame传进去
                         
