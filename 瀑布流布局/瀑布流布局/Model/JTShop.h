//
//  JTShop.h
//  瀑布流布局
//
//  Created by BJT on 17/6/29.
//  Copyright © 2017年 BJT. All rights reserved.
// 瀑布流展示的商品对应的模型

#import <UIKit/UIKit.h>

@interface JTShop : NSObject

/** 图片宽度 */
@property (nonatomic, assign) CGFloat w;
/** 图片高度 */
@property (nonatomic, assign) CGFloat h;
/** 图片 url */
@property (nonatomic, copy) NSString *img;
/** 商品价格 */
@property (nonatomic, copy) NSString *price;


@end
