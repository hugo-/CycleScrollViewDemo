//
//  ViewController.m
//  CycleScrollViewDemo
//
//  Created by 袁 章敬 on 14-10-17.
//  Copyright (c) 2014年 袁 章敬. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<indexdelegate>
{
    UILabel *_label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<8; i++) {
        UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        if (i%2) {
            iv.backgroundColor = [UIColor blueColor];
        }else{
            iv.backgroundColor = [UIColor redColor];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:iv.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i+1];
        label.backgroundColor = [UIColor clearColor];
        [iv addSubview:label];
        [items addObject:iv];
    }
    
    CycleScrollView *sc = [[CycleScrollView alloc] initWithItems:items];
    sc.frame = CGRectMake(0, 20, ScreenWidth, 200);
    sc.delegate = self;
    [self.view addSubview:sc];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200-10, 60, 30)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
}

- (void)indexdidchangeto:(NSUInteger)index total:(NSUInteger)num
{
    NSLog(@"index did change to %lu/%lu",(unsigned long)index,(unsigned long)num);
    _label.text = [NSString stringWithFormat:@"%lu/%lu",index,num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
