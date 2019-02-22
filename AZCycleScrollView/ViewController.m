//
//  ViewController.m
//  AZCycleScrollView
//
//  Created by PerhapYs on 2018/1/11.
//  Copyright © 2018年 PerhapYs. All rights reserved.
//

#import "ViewController.h"
#import "AZCycleScrollView.h"
#import "TestCollectionViewCell.h"
@interface ViewController ()<AZCycleScrollViewDelegate>{
    AZCycleScrollView *_test;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    AZCycleScrollView *cycle = [[AZCycleScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    cycle.AZDelegate = self;
  
    [self.view addSubview:cycle];
    _test = cycle;
}
-(void)viewDidLayoutSubviews{
    [_test haha];
}
-(NSInteger)Az_numberOfItemInAzCycleScrollView:(AZCycleScrollView *)scrollView{
    return 3;
}
-(Class)Az_CustomCycleCollectionViewCellForAzCycleScrollView:(AZCycleScrollView *)scrollView
{
    return [TestCollectionViewCell class];
}

-(void)Az_cycleScrollView:(AZCycleScrollView *)scrollView customCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index{
    
}

-(void)Az_cylceScrollView:(AZCycleScrollView *)scrollView didSelectedItemAtIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
