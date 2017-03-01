//
//  ViewController.m
//  YHCImageViewer
//
//  Created by yaohongchao on 17/2/28.
//  Copyright © 2017年 yaohongchao. All rights reserved.
//

#import "ViewController.h"
#import "YHCImageBrowser.h"

@interface ViewController ()
@property(nonatomic,strong) NSMutableArray *imgs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgs = [NSMutableArray array];
    CGRect frame = CGRectMake(-85, 200, 90, 90);
    for (int i = 0; i < 3; i++) {
        frame.origin.x += 100;
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"jpg"]];
        [self.imgs addObject:image];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:frame];
        imgV.image = image;
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.tag = 100 + i;
        [self.view addSubview:imgV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((320-100)/2, 400, 100, 40)];
    [btn setTitle:@"加载网络图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClick:(UIButton*)btn{
    YHCImageBrowser *browser = [[YHCImageBrowser alloc]init];
    browser.mArrData = @[@"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",
                         @"http://img.zcool.cn/community/01445b56f1ef176ac7257d207ce87d.jpg@900w_1l_2o_100sh.jpg",
                         @"http://img4.duitang.com/uploads/item/201507/30/20150730163204_A24MX.thumb.700_0.jpeg",
                         @"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",
                         @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/29/c2/10087294_10087294_1325133605031_mthumb.jpg"].mutableCopy;
    [browser show:CGRectZero];
}

-(void)tap:(UIGestureRecognizer*)rec{
    UIImageView *imgV = (UIImageView*)rec.view;
    NSInteger index = imgV.tag - 100;
    YHCImageBrowser *browser = [[YHCImageBrowser alloc]init];
    browser.mArrData = self.imgs;
    browser.currentPhotoIndex = index;
    [browser show:imgV.frame];
}
@end
