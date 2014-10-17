//
//  CycleScrollView.h
//  scrollviewtest
//
//  Created by 袁 章敬 on 14-10-16.
//  Copyright (c) 2014年 袁 章敬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol indexdelegate <NSObject>
@optional
- (void)indexdidchangeto:(NSUInteger)index total:(NSUInteger)num;
@end

@interface CycleScrollView : UIView

@property (nonatomic,assign) id<indexdelegate> delegate;

- (id)initWithItems:(NSArray *)items;

/*
 * Model related
 */

- (void)addItem:(UIView *)view;

- (void)addItems:(NSArray *)items;

- (void)insertItem:(UIView *)view atIndex:(NSUInteger)index;

- (void)insertItems:(NSArray *)items atIndex:(NSUInteger)index;

- (void)deleteItem:(UIView *)view;

- (void)clearAllItems;

- (void)resetItemsWith:(NSArray *)items;
/*
 * CycleScrollView related
 */
- (void)resetScrollView;

- (void)resetScrollViewWithItem:(UIView *)view;

- (void)resetScrollViewWithItem:(UIView *)view scrollToCenter:(BOOL)scroll;

@end
