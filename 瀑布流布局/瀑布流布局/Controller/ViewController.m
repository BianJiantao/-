//
//  ViewController.m
//  瀑布流布局
//
//  Created by BJT on 17/6/29.
//  Copyright © 2017年 BJT. All rights reserved.
//

#import "MJExtension.h"
#import "MJRefresh.h"

#import "ViewController.h"
#import "JTWaterfallLaout.h"
#import "JTShopCell.h"
#import "JTShop.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JTWaterfallLaoutDelegate>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *shops;
@end

static NSString *const reuseIdentifier = @"shop";
@implementation ViewController


- (NSMutableArray *)shops
{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
        
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    NSArray *shops = [JTShop objectArrayWithFilename:@"shops.plist"];
    [self.shops addObjectsFromArray:shops];
    
    JTWaterfallLaout *layout = [[JTWaterfallLaout alloc] init];
    layout.delegate = self;
//    layout.sectionInset = UIEdgeInsetsMake(50, 30, 30, 20);
//    layout.columnsCount = 4;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
//    collectionView.backgroundColor = [UIColor greenColor];
    // 注册 cell
    [collectionView registerNib:[UINib nibWithNibName:@"JTShopCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    // 上拉刷新,加载更多
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreShops)];
    
}

-(void)loadMoreShops
{
    // 延时模仿网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *moreShops = [JTShop objectArrayWithFilename:@"shops.plist"];
        [self.shops addObjectsFromArray:moreShops];
        [self.collectionView reloadData];
        // 结束上拉刷新
        [self.collectionView footerEndRefreshing];
        
    });
}

#pragma mark - JTWaterfallLaoutDelegate
-(CGFloat)waterfallLaout:(JTWaterfallLaout *)waterfallLaout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexpath
{
    JTShop *shop = self.shops[indexpath.item];
    // 按图片宽度高度比计算 item 的高度
    return width * shop.h / shop.w;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   JTShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

@end
