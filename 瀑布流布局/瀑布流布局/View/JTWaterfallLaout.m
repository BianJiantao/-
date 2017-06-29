//
//  JTWaterfallLaout.m
//  瀑布流布局
//
//  Created by BJT on 17/6/29.
//  Copyright © 2017年 BJT. All rights reserved.
//

#import "JTWaterfallLaout.h"


@interface JTWaterfallLaout ()
/** 所有 item 的布局属性 */
@property (nonatomic,strong) NSMutableArray *attrsArr;
/** 存放每一列的 item 的最大 Y 值 */
@property (nonatomic,strong) NSMutableDictionary *columnMaxY_Dict;
/** 每一列宽度 */
@property (nonatomic,assign) CGFloat columnWidth;

@end

@implementation JTWaterfallLaout

- (NSMutableArray *)attrsArr
{
    if (_attrsArr == nil) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableDictionary *)columnMaxY_Dict
{
    if (_columnMaxY_Dict == nil) {
        _columnMaxY_Dict = [[NSMutableDictionary alloc] init];
    }
    return _columnMaxY_Dict;
}


- (instancetype)init
{
    if (self = [super init]) {
        // 设置默认属性值
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnsCount = 3;
    }
    return self;
}

/**
 *  bounds变化,就刷新
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
/**
 *  每次布局之前的准备
 */
-(void)prepareLayout
{
//    NSLog(@"prepareLayout");
    
    [super prepareLayout];
    
    // 计算 item 宽度
    self.columnWidth = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin)/self.columnsCount;
    
    // 每次拖拽刷新时, 最大 y 值字典重新赋值
    for (int i = 0; i < self.columnsCount; i++) {
        NSString *columnKey = [NSString stringWithFormat:@"%d",i];
        self.columnMaxY_Dict[columnKey] = @(self.sectionInset.top);
    }
    
    // 布局属性的数组也应先清空
    [self.attrsArr removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArr addObject:attrs];
    }
//    NSLog(@"%zd",self.attrsArr.count);
    
}

/**
 *  滚动范围 content size
 */
-(CGSize)collectionViewContentSize
{
    
    // 遍历字典,找到所有列最大y值中最大的 y值
    __block CGFloat maxYValue = 0; // 默认第一列最小
    [self.columnMaxY_Dict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        
        if ([maxY floatValue] > maxYValue) {
            maxYValue = [maxY floatValue];
        }
        
    }];
    return CGSizeMake(0, maxYValue + self.sectionInset.bottom);
}


/**
 *  返回rect范围内的布局属性
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
//        NSLog(@"%@",NSStringFromCGRect(rect));
//    NSLog(@"layoutAttributesForElementsInRect");
    
    
    return self.attrsArr;
}

/**
 *  返回indexPath这个位置Item的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"layoutAttributesForItemAtIndexPath");
   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 遍历字典,找到所有列最大y值中,最小的那一列
    __block NSString *minColumn = @"0"; // 默认第一列最小
    [self.columnMaxY_Dict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
       
        if ([maxY floatValue] < [self.columnMaxY_Dict[minColumn] floatValue]) {
            minColumn = column;
        }
        
    }];
//    NSLog(@"%@",minColumn);
    // 计算 item 的 frame
    CGFloat x = self.sectionInset.left + [minColumn integerValue] * (self.columnWidth + self.columnMargin);
    CGFloat y = [self.columnMaxY_Dict[minColumn] floatValue] + self.rowMargin;
    CGFloat height = [self.delegate waterfallLaout:self heightForWidth:self.columnWidth atIndexPath:indexPath];
    
    attrs.frame = CGRectMake(x, y, self.columnWidth, height);
    
    
    // 更新这一列的最大Y值
    self.columnMaxY_Dict[minColumn] = @(y + height);
    
//    NSLog(@"%@",NSStringFromCGRect(attrs.frame));
    
    
    return attrs;
    
}


@end
