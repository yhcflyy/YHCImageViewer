//
//  YHCImageCell.h
//  YHCImageViewer
//
//  Created by yaohongchao on 17/2/28.
//  Copyright © 2017年 yaohongchao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YHCImageCell : UICollectionViewCell

@property (nonatomic,strong) id  photo;///<能取到图片数据的对象
@property (nonatomic,strong) NSString  *thumbUrl;///<缩略图对象
@property(nonatomic,copy) void(^tapBlock)();
@property (nonatomic, weak) UIView *imageContainerView;

-(UIImage*)getShowImage;
-(CGRect)getContainerFrame;
-(void)setContainerFrame:(CGRect)frame;
-(void)resizeSubviews;

@end
