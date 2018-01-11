//
//  AZCycleViewFlowLayout.m
//  test
//
//  Created by PerhapYs on 2018/1/11.
//  Copyright © 2018年 PerhapYs. All rights reserved.
//

#import "AZCycleViewFlowLayout.h"

@implementation AZCycleViewFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //获得super已经计算好的布局属性
    NSArray *array1 =[super layoutAttributesForElementsInRect:rect] ;
    
    NSArray *array =  [[NSArray alloc]initWithArray:array1 copyItems:YES];
    //计算collectionView最中心点的X的值(用contentsize的X偏移量+collectionView宽度的一半)
    CGFloat centerX = self.collectionView.contentOffset.x +self.collectionView.frame.size.width*0.5;
    
    //在原有布局的基础上,进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat delta = ABS(attrs.center.x - centerX);
        //根据间距值 计算cell的缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width ;
        //设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale,scale);
    }
    return array;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
/*
 *这个方法的返回时就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //    //计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x =proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    //这里建议调用super,因为用self会把里面for循环的transform再算一遍,但我们仅仅想拿到中心点X,super中已经算好中心点X的值了
    NSArray *array =[super layoutAttributesForElementsInRect:rect];
    //计算collectionView最中心点的X的值
    /*
     proposedContentOffset 目的,原本
     拿到最后这个偏移量的X,最后这些cell,距离最后中心点的位置
     */
    CGFloat centerX = proposedContentOffset.x +self.collectionView.frame.size.width*0.5;
    
    //存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta)>ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        };
    }
    //修改原有的偏移量
    proposedContentOffset.x +=minDelta;
    
    return proposedContentOffset;
}

@end
