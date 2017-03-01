//
//  YHCImageBrowser.m
//  YHCImageViewer
//
//  Created by yaohongchao on 17/2/28.
//  Copyright © 2017年 yaohongchao. All rights reserved.
//

#import "YHCImageBrowser.h"
#import "YHCImageCell.h"

@interface YHCImageBrowser ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate>
@property (nonatomic,weak   ) UICollectionView *collectionView;
@property (nonatomic,weak   ) UILabel          *lblPage;
@property (nonatomic,assign ) BOOL             isFirst;
@end
static NSString *reuseCellIdentifier = @"reuseCellIdentifier";

@implementation YHCImageBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


-(void)dealloc{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView removeFromSuperview];
    self.mArrData = nil;
    self.mArrFilted = nil;
    self.collectionView = nil;
    self.lblPage = nil;
}

-(void)setCurrentPhotoIndex:(NSInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    //做个保护
    if(currentPhotoIndex >= self.mArrData.count){
        _currentPhotoIndex = self.mArrData.count > 0 ? self.mArrData.count-1 : 0;
    }
}

-(void)setup{
    self.view.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 40.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-20, 0, SCREEN_WIDTH+40, SCREEN_HEIGHT) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[YHCImageCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILabel *lblPage = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 20, 70, 25)];
    lblPage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    lblPage.textAlignment = NSTextAlignmentCenter;
    lblPage.font = [UIFont systemFontOfSize:14];
    lblPage.textColor = [UIColor whiteColor];
    lblPage.layer.masksToBounds = YES;
    lblPage.layer.cornerRadius = CGRectGetHeight(lblPage.frame)/2;
    [self.view addSubview:lblPage];
    self.lblPage = lblPage;
    if(self.mArrData.count > 0 && self.mArrData.count > self.currentPhotoIndex){
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self refreshPageIndex:self.currentPhotoIndex];
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mArrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHCImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    id obj = [self.mArrData objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.tapBlock = ^(){
        [weakSelf dismiss:YES];
    };
    NSString *thumbUrl = [self.mArrFilted objectAtIndex:indexPath.row];
    if([thumbUrl isKindOfClass:[NSString class]] && thumbUrl.length > 0){
        cell.thumbUrl = [self.mArrFilted objectAtIndex:indexPath.row];
    }
    if(self.isFirst){
        cell.imageContainerView.hidden = YES;
    }else{
        cell.imageContainerView.hidden = NO;
    }
    cell.photo = obj;
    return cell;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = [self getIndex];
    [self refreshPageIndex:index];
}


-(void)refreshPageIndex:(NSInteger)index{
    NSInteger curIndex = index + 1;
    if(self.mArrData.count < curIndex){
        curIndex = self.mArrData.count;
    }
    self.lblPage.text = [NSString stringWithFormat:@"%ld/%lu",(long)curIndex,(unsigned long)self.mArrData.count];
}

-(NSUInteger)getIndex{
    if(self.mArrData.count == 0){
        return -1;
    }else{
        return (NSInteger)self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    }
}

-(void)show:(CGRect)frame{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    if(CGRectEqualToRect(frame, CGRectZero)){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateWithDuration:0.4 animations:^{
            self.collectionView.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
        }];
    }else{
        self.isFirst = YES;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YHCImageCell *cell = (YHCImageCell*)[weakSelf.collectionView cellForItemAtIndexPath:
                                                           [NSIndexPath indexPathForRow:weakSelf.currentPhotoIndex inSection:0]];
            [cell setContainerFrame:frame];
            cell.imageContainerView.frame = frame;
            cell.imageContainerView.hidden = NO;
        });
        weakSelf.collectionView.backgroundColor = [UIColor blackColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isFirst = NO;
            [weakSelf showFirstWithAnimate:frame];
            [weakSelf scrollViewDidEndDecelerating:weakSelf.collectionView];
        });
    }
}

-(void)showFirstWithAnimate:(CGRect)frame{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    });
    YHCImageCell *cell = (YHCImageCell*)[self.collectionView cellForItemAtIndexPath:
                                                   [NSIndexPath indexPathForRow:self.currentPhotoIndex inSection:0]];
    cell.imageContainerView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.imageContainerView.frame = [cell getContainerFrame];
        [cell setContainerFrame:[cell getContainerFrame]];
        cell.imageContainerView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [cell resizeSubviews];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismiss:(BOOL)animate{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if(animate){
        [UIView animateWithDuration:0.4 animations:^{
            self.view.alpha=0;
        } completion:^(BOOL finished) {
            if(finished){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view removeFromSuperview];
                    [self removeFromParentViewController];
                });
            }
        }];
    }else{
        self.view.alpha=0;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}


@end
