//
//  YHCImageBrowser.h
//  YHCImageViewer
//
//  Created by yaohongchao on 17/2/28.
//  Copyright © 2017年 yaohongchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCImageBrowser : UIViewController

@property (nonatomic,assign) NSInteger      currentPhotoIndex;///<当前图片的索引
@property (nonatomic,strong) NSMutableArray *mArrData;///<图片数组或url数组
@property (nonatomic,strong) NSMutableArray *mArrFilted;///<缩略图数组


/**
 显示图片浏览器
 
 @param frame 点击图片所在的frame
 */
-(void)show:(CGRect)frame;

@end
