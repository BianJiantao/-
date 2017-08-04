//
//  JTWaterfallLaout.h
//  瀑布流布局
//
//  Created by BJT on 17/6/29.
//  Copyright © 2017年 BJT. All rights reserved.
//  瀑布流布局

#import <UIKit/UIKit.h>


@class JTWaterfallLaout;

@protocol JTWaterfallLaoutDelegate <NSObject>
/** 获取 indexpath 对应的 item 的高度 */
-(CGFloat)waterfallLaout:(JTWaterfallLaout *)waterfallLaout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexpath;

@end


@interface JTWaterfallLaout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;
/** 代理 */
@property (nonatomic,weak) id<JTWaterfallLaoutDelegate> delegate;
@end
