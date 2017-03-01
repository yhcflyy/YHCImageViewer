//
//  YHCImageCell.m
//  YHCImageViewer
//
//  Created by yaohongchao on 17/2/28.
//  Copyright © 2017年 yaohongchao. All rights reserved.
//

#import "YHCImageCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

#define cellWidth CGRectGetWidth(self.bounds)
#define cellHeight CGRectGetHeight(self.bounds)

@interface YHCImageCell()<UIScrollViewDelegate>
@property (nonatomic, weak  ) UIScrollView       *scrollView;
@property (nonatomic, weak  ) UIImageView        *imageView;
@end

@implementation YHCImageCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setui];
    }
    return self;
}

-(void)setui{
    self.backgroundColor = [UIColor clearColor];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.bouncesZoom = YES;
    scrollView.maximumZoomScale = 2.5;
    scrollView.minimumZoomScale = 1.0;
    scrollView.multipleTouchEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *imageContainerView = [[UIView alloc] init];
    imageContainerView.clipsToBounds = YES;
    [scrollView addSubview:imageContainerView];
    self.imageContainerView = imageContainerView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    [imageContainerView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
}

-(void)setPhoto:(id)photo{
    _photo = photo;
    self.imageView.image = nil;
    if([photo isKindOfClass:[UIImage class]]){
        self.imageView.image = photo;
        [self resizeSubviews];
    }if([photo isKindOfClass:[NSString class]]){
        __weak typeof(self) weakSelf = self;
        NSURL *url = [[NSURL alloc] initWithString:photo];
        NSString *key =  [[SDWebImageManager sharedManager]cacheKeyForURL:url];
        UIImage *img = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];
        if(img){
            [self setImage:img];
        }else{
            NSString *imgUrl = self.thumbUrl.length ? self.thumbUrl : photo;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakSelf setImage:image1];
                if(weakSelf.thumbUrl.length > 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.imageView sd_setImageWithURL:url placeholderImage:image1 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                            //                            CGFloat progress = receivedSize/(CGFloat)expectedSize;
                            
                        } completed:^(UIImage * image, NSError *error, SDImageCacheType cacheType, NSURL * imageURL) {
                            [weakSelf setImage:image];
                        }];
                    });
                }
            }];
        }
    }
}

- (void)resizeSubviews {
    CGRect frame = self.imageContainerView.frame;
    frame.origin = CGPointZero;
    frame.size.width = cellWidth;
    self.imageContainerView.frame = frame;
    
    UIImage *image = self.imageView.image;
    if (image.size.height / image.size.width > cellHeight / cellWidth) {
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = floor(image.size.height / (image.size.width / cellWidth));
        self.imageContainerView.frame = frame;
    } else {
        CGFloat height = image.size.height / image.size.width * cellWidth;
        if (height < 1 || isnan(height)) height = cellHeight;
        height = floor(height);
        
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = height;
        self.imageContainerView.frame = frame;
        self.imageContainerView.center = CGPointMake(self.imageContainerView.center.x, cellHeight/2);
    }
    
    if (CGRectGetHeight(self.imageContainerView.frame) > cellHeight && CGRectGetHeight(self.imageContainerView.frame) - cellHeight <= 1) {
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = cellHeight;
        self.imageContainerView.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(cellWidth, MAX(CGRectGetHeight(self.imageContainerView.frame), cellHeight));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = CGRectGetHeight(self.imageContainerView.frame) <= cellHeight ? NO : YES;
    self.imageView.frame = self.imageContainerView.bounds;
}

-(CGRect)getContainerFrame{
    CGRect frameOut = self.imageContainerView.frame;
    frameOut.origin = CGPointZero;
    frameOut.size.width = cellWidth;
    self.imageContainerView.frame = frameOut;
    
    UIImage *image = self.imageView.image;
    if (image.size.height / image.size.width > cellHeight / cellWidth) {
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = floor(image.size.height / (image.size.width / cellWidth));
        frameOut = frame;
    } else {
        CGFloat height = image.size.height / image.size.width * cellWidth;
        if (height < 1 || isnan(height)) height = cellHeight;
        height = floor(height);
        
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = height;
        self.imageContainerView.center = CGPointMake(self.imageContainerView.center.x, cellHeight/2);
        frameOut = frame;
    }
    
    if (CGRectGetHeight(self.imageContainerView.frame) > cellHeight && CGRectGetHeight(self.imageContainerView.frame) - cellHeight <= 1) {
        CGRect frame = self.imageContainerView.frame;
        frame.size.height = cellHeight;
        frameOut = frame;
    }
    return frameOut;
}

-(void)setContainerFrame:(CGRect)frame{
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}
#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if(self.tapBlock) self.tapBlock();
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat scrollWidth = SCREEN_WIDTH;
    CGFloat scrollHeight = CGRectGetHeight(scrollView.frame);
    
    CGFloat offsetX = (scrollWidth > scrollView.contentSize.width) ? (scrollWidth - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollHeight > scrollView.contentSize.height) ? (scrollHeight - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


-(UIImage*)getShowImage{
    return  self.imageView.image;
}


-(void)setImage:(UIImage*)image{
    if(image){
        self.imageView.image = image;
    }else{
        self.imageView.image = [UIImage imageNamed:@"ic_default_imgp_298"];
    }
    [self resizeSubviews];
}

@end
