//
//  TestCollectionViewCell.m
//  AZCycleScrollView
//
//  Created by PerhapYs on 2018/1/11.
//  Copyright © 2018年 PerhapYs. All rights reserved.
//

#import "TestCollectionViewCell.h"

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

@end
