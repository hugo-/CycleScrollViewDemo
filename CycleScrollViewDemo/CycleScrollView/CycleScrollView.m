//
//  CycleScrollView.m
//  scrollviewtest
//
//  Created by 袁 章敬 on 14-10-16.
//  Copyright (c) 2014年 袁 章敬. All rights reserved.
//

#import "CycleScrollView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CycleScrollView ()<UIScrollViewDelegate>
{
    UIScrollView * _containerview;
    NSMutableArray *_items;
    CGSize _pageSize;
    BOOL _isCycle;
}
@end

@implementation CycleScrollView

- (void)dealloc
{
    [_containerview release],_containerview = nil;
    [_items release],_items = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initContents];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (self) {
        [_items addObjectsFromArray:items];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContents];
        _pageSize = frame.size;
    }
    return self;
}

- (void)initContents
{
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (!_items) _items = [[NSMutableArray alloc] init];
    _pageSize = CGSizeMake(ScreenWidth, 250);
    if (!_containerview) {
        _containerview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _pageSize.width, _pageSize.height)];
        _containerview.contentSize = CGSizeMake(_pageSize.width*3, _containerview.bounds.size.height);
        _containerview.showsVerticalScrollIndicator = NO;
        _containerview.showsHorizontalScrollIndicator = NO;
        _containerview.pagingEnabled = YES;
        _containerview.bounces = NO;
        _containerview.alwaysBounceHorizontal = YES;
        _containerview.backgroundColor = [UIColor grayColor];
        _containerview.delegate = self;
        [self addSubview:_containerview];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _pageSize = frame.size;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _containerview.frame = self.bounds;
    if (_items.count==0)return;
    if (_items.count>2) {
        _containerview.contentSize = CGSizeMake(_pageSize.width*3, _pageSize.height);
        _containerview.bounces = NO;
        _isCycle = YES;
    }else{
        _containerview.contentSize = CGSizeMake(_pageSize.width*_items.count, _pageSize.height);
        _containerview.bounces = YES;
        _isCycle = NO;
    }
    [self resetScrollView];
}

#pragma mark - model data process

- (void)addItem:(UIView *)view
{
    [_items addObject:view];
    [self setNeedsDisplay];
}

- (void)addItems:(NSArray *)items
{
    [_items addObjectsFromArray:items];
    [self setNeedsDisplay];
}

- (void)insertItem:(UIView *)view atIndex:(NSUInteger)index
{
    [_items insertObject:view atIndex:index];
    [self setNeedsDisplay];
}

- (void)insertItems:(NSArray *)items atIndex:(NSUInteger)index
{
    if(items.count==0)return;
    if(index>=(items.count+_items.count))return;
    NSRange range = {index,[items count]};
    NSIndexSet *indexSet = [[[NSIndexSet alloc] initWithIndexesInRange:range] autorelease];
    [_items insertObjects:items atIndexes:indexSet];
    [self setNeedsDisplay];
}

- (void)deleteItem:(UIView *)view
{
    if (view) {
        [_items removeObject:view];
        [self setNeedsDisplay];
    }
}

- (void)clearAllItems
{
    [_items removeAllObjects];
    [self setNeedsDisplay];
}

- (void)resetItemsWith:(NSArray *)items
{
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
    [self setNeedsDisplay];
}

#pragma mark - view

- (void)resetScrollView
{
    [self resetScrollViewWithItem:[self getCurrentItem] scrollToCenter:YES];
}

- (void)resetScrollViewWithItem:(UIView *)view
{
    [[_containerview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!_isCycle) {
        for (int i=0; i<_items.count; i++) {
            UIView *iv = _items[i];
            CGRect f;
            f = iv.frame;
            f.origin.x = i*_pageSize.width;
            iv.frame = f;
            [_containerview addSubview:iv];
        }
    }else{
        UIView *current = view;
        UIView *first = [self getPrevItemForItem:current];
        UIView *last = [self getNextItemForItem:current];
        
        CGRect f;
        f = first.frame;
        f.origin.x = 0;
        first.frame = f;
        [_containerview addSubview:first];
        
        f = current.frame;
        f.origin.x = _pageSize.width;
        current.frame = f;
        [_containerview addSubview:current];
        
        f = last.frame;
        f.origin.x = 2*_pageSize.width;
        last.frame = f;
        [_containerview addSubview:last];
    }
    
    [self updateIndex];
}

- (void)resetScrollViewWithItem:(UIView *)view scrollToCenter:(BOOL)scroll
{
    [self resetScrollViewWithItem:view];
    if (scroll&&_isCycle) {
        _containerview.contentOffset = CGPointMake(_pageSize.width, _containerview.contentOffset.y);
    }
}

#pragma mark item

- (UIView *)getCurrentItem
{
    if (_items.count==0)return nil;
    if (_isCycle) {
        if(_containerview.subviews.count==0)return _items[0];
        return [_containerview.subviews objectAtIndex:1];
    }else{
        return _items[[self getCurrentItemIndex]-1];
    }
}

- (NSUInteger)getCurrentItemIndex
{
    if (_items.count==0)return 0;
    if (_isCycle) {
        id item = [self getCurrentItem];
        return [_items indexOfObject:item]+1;
    }else{
        return _containerview.contentOffset.x/_pageSize.width+1;
    }
}

- (UIView *)getNextItemForItem:(UIView *)iv
{
    NSUInteger index = [_items indexOfObject:iv];
    if (index == NSNotFound)return nil;
    if (index == _items.count-1) {
        return _items[0];
    }
    return _items[index+1];
}

- (UIView *)getPrevItemForItem:(UIView *)iv
{
    NSUInteger index = [_items indexOfObject:iv];
    if (index == NSNotFound)return nil;
    if (index==0) {
        return [_items lastObject];
    }
    return _items[index-1];
}

- (void)moveToNextPage
{
    id item = [self getCurrentItem];
    item = [self getNextItemForItem:item];
    [self resetScrollViewWithItem:item];
}

- (void)moveToPrevPage
{
    id item = [self getCurrentItem];
    item = [self getPrevItemForItem:item];
    [self resetScrollViewWithItem:item];
}

- (void)updateIndex
{
    NSLog(@"index did change to %lu",(unsigned long)[self getCurrentItemIndex]);
    if ([_delegate respondsToSelector:@selector(indexdidchangeto:total:)]) {
        [_delegate indexdidchangeto:[self getCurrentItemIndex] total:_items.count];
    }
}

#pragma mark - scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_isCycle)return;
    if (scrollView.contentOffset.x>_pageSize.width*1.5f) {
        [self moveToNextPage];
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-_pageSize.width, scrollView.contentOffset.y);
    }else if(scrollView.contentOffset.x<_pageSize.width*0.5f){
        [self moveToPrevPage];
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+_pageSize.width, scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetScrollViewWithItem:[self getCurrentItem] scrollToCenter:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self resetScrollViewWithItem:[self getCurrentItem] scrollToCenter:YES];
    }
}

@end
