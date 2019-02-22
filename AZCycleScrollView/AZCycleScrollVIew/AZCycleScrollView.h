//
//  AZCycleScrollView.h
//  test
//
//  Created by PerhapYs on 2018/1/11.
//  Copyright © 2018年 PerhapYs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZCycleScrollView;

@protocol AZCycleScrollViewDelegate <NSObject>

@optional

- (void)Az_cylceScrollView:(AZCycleScrollView *)scrollView didSelectedItemAtIndex:(NSInteger)index;

@required

-(NSInteger)Az_numberOfItemInAzCycleScrollView:(AZCycleScrollView *)scrollView;

- (Class)Az_CustomCycleCollectionViewCellForAzCycleScrollView:(AZCycleScrollView *)scrollView;

- (void)Az_cycleScrollView:(AZCycleScrollView *)scrollView customCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index;

@end

@interface AZCycleScrollView : UIView

@property (nonatomic, weak) id<AZCycleScrollViewDelegate> AZDelegate;

-(void)haha;

@end
