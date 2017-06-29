//
//  JTShopCell.m
//  瀑布流布局
//
//  Created by BJT on 17/6/29.
//  Copyright © 2017年 BJT. All rights reserved.
//

#import "UIImageView+WebCache.h"

#import "JTShopCell.h"
#import "JTShop.h"

@interface JTShopCell ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation JTShopCell


-(void)setShop:(JTShop *)shop
{
    _shop = shop;
    
    [self.imgeV sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLabel.text = shop.price;
    
}

@end
