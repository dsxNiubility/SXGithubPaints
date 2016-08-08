//
//  ViewController.m
//  GithubCommits
//
//  Created by dongshangxian on 16/8/6.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "ViewController.h"
#define SXRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ItemEntity : NSObject

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,assign)NSInteger commitCount;

@end

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,assign)NSInteger dayCount;
@property(nonatomic,strong)NSArray *colorArray;
@property(nonatomic,strong)UIView *drawView;

@property(nonatomic,strong)UICollectionView *collectionView;
// 数据源
@property(nonatomic,strong)NSMutableArray<ItemEntity *> *colorItemArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dayCount = 371;
    self.colorArray = @[SXRGBColor(234, 234, 234),SXRGBColor(205, 227, 115),SXRGBColor(123, 190, 83),SXRGBColor(56, 150, 49),SXRGBColor(25, 87, 27)];
    [self createItemEntityArray];
    
    UIButton *resetBtn = [UIButton new];
    resetBtn.frame = CGRectMake(50, 50, 90, 30);
    resetBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
    
    // 点击打印自定义图案的时间和次数
    UIButton *printBtn = [UIButton new];
    printBtn.frame = CGRectMake(150, 50, 90, 30);
    printBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:printBtn];
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(10, 10);
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(50, 100, 650, 82) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:self.collectionView];
//    [self addView];
}

- (void)createItemEntityArray
{
    self.colorItemArray = [NSMutableArray array];
    for (int i = 0; i<self.dayCount; ++i) {
        ItemEntity *entity = [ItemEntity new];
        entity.bgColor = SXRGBColor(234, 234, 234);
        [self.colorItemArray addObject:entity];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 371;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    ItemEntity *currentEntity = [self.colorItemArray objectAtIndex:indexPath.item];
    cell.backgroundColor = currentEntity.bgColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.item);
    ItemEntity *currentEntity = [self.colorItemArray objectAtIndex:indexPath.item];
    UIColor *bgColor = currentEntity.bgColor;
    NSInteger index = [self.colorArray indexOfObject:bgColor];
    bgColor = [self.colorArray objectAtIndex:(index + 1)%5];
    currentEntity.bgColor = bgColor;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}



- (void)addView{
    self.drawView = [UIView new];
    self.drawView.frame = CGRectMake(50, 100, 1000, 1000);
    int col = 0;
    int row = 0;
    int x = 0;
    int y = 0;
    int width = 10;
    int height = 10;
    for (int i = 0; i< 370; ++i) {
        col = i/7;
        row = i%7;
        x = col * (width + 2);
        y = row * (width +2);
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(x, y, width, height);
        btn.backgroundColor = SXRGBColor(234, 234, 234);
        [btn addTarget:self action:@selector(viewTapOne:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(viewTapTwice:) forControlEvents:UIControlEventTouchUpOutside];
        [self.drawView addSubview:btn];
    }
    [self.view addSubview:self.drawView];
}

- (void)viewTapOne:(UIButton *)v{
    UIColor *bgColor = v.backgroundColor;
    NSInteger index = [self.colorArray indexOfObject:bgColor];
    if (index + 1 < self.colorArray.count) {
        bgColor = [self.colorArray objectAtIndex:index + 1];
        v.backgroundColor = bgColor;
    }
}

- (void)viewTapTwice:(UIButton *)v{
    UIColor *bgColor = v.backgroundColor;
    NSInteger index = [self.colorArray indexOfObject:bgColor];
    if (index - 1 >= 0) {
        bgColor = [self.colorArray objectAtIndex:index - 1];
        v.backgroundColor = bgColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ItemEntity

@end
