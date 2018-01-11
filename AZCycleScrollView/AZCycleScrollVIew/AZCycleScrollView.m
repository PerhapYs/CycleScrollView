//
//  AZCycleScrollView.m
//  test
//
//  Created by PerhapYs on 2018/1/11.
//  Copyright © 2018年 PerhapYs. All rights reserved.
//

#import "AZCycleScrollView.h"
#import "AZCycleViewFlowLayout.h"
#import "AZCycleCollectionViewCell.h"

static NSString * const AZCycleCollectionViewIdentifier = @"cellIdentifierForCycle";

@interface AZCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSInteger _lastRowIndex;
}

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) UICollectionView *cycleView;

@property (nonatomic , assign) NSInteger totalRowNumber;

@property (nonatomic , assign) NSInteger dataNumber;

@end
@implementation AZCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Az_initializeData];
        [self Az_initializeInterface];
    }
    return self;
}

-(void)Az_initializeData{
    
}
-(void)Az_initializeInterface{
    
    NSInteger itemWidth = (self.bounds.size.width - 60)  / 3;
    AZCycleViewFlowLayout *layout = [[AZCycleViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = self.bounds.size.height * 0.5 + 1; // 确保只出现一行
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height * 0.3);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.decelerationRate = 0.5;
    [mainView registerClass:[AZCycleCollectionViewCell class] forCellWithReuseIdentifier:AZCycleCollectionViewIdentifier];
    [self addSubview:mainView];
    _cycleView = mainView;
}
#pragma mark -- AZDelegate
-(void)setAZDelegate:(id<AZCycleScrollViewDelegate>)AZDelegate{
 
    _AZDelegate = AZDelegate;
    if ([self.AZDelegate respondsToSelector:@selector(Az_CustomCycleCollectionViewCellForAzCycleScrollView:)] && [self.AZDelegate respondsToSelector:@selector(Az_cycleScrollView:customCell:atIndex:)]) {
        [_cycleView registerClass:[self.AZDelegate Az_CustomCycleCollectionViewCellForAzCycleScrollView:self] forCellWithReuseIdentifier:AZCycleCollectionViewIdentifier];
    }
}

-(void)setIsAutoScroll:(BOOL)isAutoScroll{
    _isAutoScroll = isAutoScroll;
    if (isAutoScroll == YES) {
        [self setupTimer];
    }
}

#pragma mark -- timer

// 释放timer
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}
// 创建timer
- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScrollCycle) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma mark -- cycle
-(NSInteger)showIndex:(NSInteger)row{
    return row % _dataNumber;
}
- (NSInteger)currentIndex
{
    return MAX(0, _lastRowIndex);
}
-(void)autoScrollCycle{
    if (0 == _totalRowNumber) return;
    NSInteger index = [self currentIndex];
    [self scrollToIndex:index];
}
- (void)scrollToIndex:(NSInteger)targetIndex
{
    if (targetIndex >= _totalRowNumber - _dataNumber || targetIndex <= _dataNumber) {  // 如果超出范围则跳转到中间位置，保持循环
        targetIndex = _totalRowNumber * 0.5;
        [_cycleView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
    // 正常跳转
    [_cycleView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
#pragma mark -- <UICollectionViewDataSource,UICollectionViewDelegate>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.AZDelegate respondsToSelector:@selector(Az_numberOfItemInAzCycleScrollView:)]) {
        NSInteger dataNumber = [self.AZDelegate Az_numberOfItemInAzCycleScrollView:self];
        
        _dataNumber = dataNumber;
        _totalRowNumber = dataNumber * 100;
       
    }
    return _totalRowNumber;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _lastRowIndex = indexPath.row;
    
    AZCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AZCycleCollectionViewIdentifier forIndexPath:indexPath];
    
    NSInteger showIndex = [self showIndex:indexPath.item];
    
    if ([self.AZDelegate respondsToSelector:@selector(Az_CustomCycleCollectionViewCellForAzCycleScrollView:)] && [self.AZDelegate respondsToSelector:@selector(Az_cycleScrollView:customCell:atIndex:)] &&
        [self.AZDelegate Az_CustomCycleCollectionViewCellForAzCycleScrollView:self]) {
        
        [self.AZDelegate Az_cycleScrollView:self customCell:cell atIndex:showIndex];
        
        return cell;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger showIndex = [self showIndex:indexPath.item];
    [self.AZDelegate Az_cylceScrollView:self didSelectedItemAtIndex:showIndex];
}
#pragma mark -- scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll) {
       [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll) {
        [self setupTimer];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:_cycleView];
//}
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    if (!_dataSource.count) return; // 解决清除timer时偶尔会出现的问题
//    NSInteger itemIndex = [self currentIndex];
//    NSInteger indexOnPageControl = [self showIndex:itemIndex];
//
//    //    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
//    //        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
//    //    } else if (self.itemDidScrollOperationBlock) {
//    //        self.itemDidScrollOperationBlock(indexOnPageControl);
//    //    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (!_dataSource.count) return; // 解决清除timer时偶尔会出现的问题
//    NSInteger itemIndex = [self currentIndex];
//    NSInteger indexOnPageControl = [self showIndex:itemIndex];
//
//    //    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
//    //        TAPageControl *pageControl = (TAPageControl *)_pageControl;
//    //        pageControl.currentPage = indexOnPageControl;
//    //    } else {
//    //        UIPageControl *pageControl = (UIPageControl *)_pageControl;
//    //        pageControl.currentPage = indexOnPageControl;
//    //    }
//}
@end
