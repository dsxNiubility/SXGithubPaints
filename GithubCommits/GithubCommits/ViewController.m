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
@property (weak, nonatomic) IBOutlet UITextField *compwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *useremailTxt;

@property(nonatomic,assign)NSInteger dayCount;
@property(nonatomic,strong)NSArray *colorArray;
@property(nonatomic,strong)NSArray *timesArray;
@property(nonatomic,strong)UIView *drawView;

@property(nonatomic,strong)UICollectionView *collectionView;
// 数据源
@property(nonatomic,strong)NSMutableArray<ItemEntity *> *colorItemArray;

@end

@implementation ViewController

#pragma mark -
#pragma mark 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [self createDateEnv];
    NSLog(@"%@",[NSDate date]);
    NSLog(@"%@",[NSDate dateWithTimeIntervalSince1970:[NSDate new].timeIntervalSince1970 - 86400*5]);
    NSLog(@"%@",[self dataStringWithDeltaDay:5]);

    self.colorArray = @[SXRGBColor(234, 234, 234),SXRGBColor(205, 227, 115),SXRGBColor(123, 190, 83),SXRGBColor(56, 150, 49),SXRGBColor(25, 87, 27)];
    self.timesArray = @[@0,@1,@3,@5,@7];
    
    [self createItemEntityArray];
//    [self createOperationModule];
    [self createCollectionView];
}

// 初始化天
- (void)createDateEnv
{
    NSString *week = [self weekStringFromDate:[NSDate date]];
    self.dayCount = 0;
    if ([week isEqualToString:@"Sunday"]) {
        self.dayCount = 371+1;
    }else if ([week isEqualToString:@"Monday"]){
        self.dayCount = 371+2;
    }else if ([week isEqualToString:@"Tuesday"]){
        self.dayCount = 371+3;
    }else if ([week isEqualToString:@"Wednesday"]){
        self.dayCount = 371+4;
    }else if ([week isEqualToString:@"Thursday"]){
        self.dayCount = 371+5;
    }else if ([week isEqualToString:@"Friday"]){
        self.dayCount = 371+6;
    }else if ([week isEqualToString:@"Saturday"]){
        self.dayCount = 371;
    }
}

// 初始化内容模型
- (void)createItemEntityArray
{
    self.colorItemArray = [NSMutableArray array];
    for (int i = 0; i<self.dayCount; i++) {
        ItemEntity *entity = [ItemEntity new];
        entity.bgColor = SXRGBColor(234, 234, 234);
        entity.date = [self dataStringWithDeltaDay:self.dayCount - i -1];
        [self.colorItemArray addObject:entity];
    }
}

// 初始化collectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(10, 10);
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 100, 650, 82) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:self.collectionView];
}

// 创建操作类按钮
- (void)createOperationModule
{
    UIButton *resetBtn = [UIButton new];
    resetBtn.frame = CGRectMake(50, 50, 90, 30);
    resetBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetBoard) forControlEvents:UIControlEventTouchUpInside];
    
    // 点击打印自定义图案的时间和次数
    UIButton *printBtn = [UIButton new];
    printBtn.frame = CGRectMake(150, 50, 90, 30);
    printBtn.backgroundColor = [UIColor yellowColor];
    [printBtn addTarget:self action:@selector(printCommitBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printBtn];
}

#pragma mark -
#pragma mark 数据源代理方法CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayCount;
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
    NSLog(@"%@",currentEntity.date);
    UIColor *bgColor = currentEntity.bgColor;
    NSInteger index = [self.colorArray indexOfObject:bgColor];
    bgColor = [self.colorArray objectAtIndex:(index + 1)%5];
    currentEntity.bgColor = bgColor;
    currentEntity.commitCount = [[self.timesArray objectAtIndex:(index + 1)%5] integerValue];
    NSLog(@"%ld",currentEntity.commitCount);
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    NSLog(@"%@",[self randomSix]);
}

#pragma mark -
#pragma mark 操作类方法

- (IBAction)resetBtnClick:(UIButton *)sender {
    [self createItemEntityArray];
    [self.collectionView reloadData];
}
- (IBAction)generater:(UIButton *)sender {
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"#!/usr/bin/expect\n#spawn cd /Users/dsx/Desktop\n#spawn mkdir SXCommitBoard\n#spawn cd SXCommitBoard\nspawn sudo echo 1\nexpect {\n    \"*assword*\" {\n        send \"5678\\n\"\n        exp_continue\n    }\n}\nspawn git init\n"];
    for (int i = 0; i < self.colorItemArray.count; ++i) {
        ItemEntity *entity = [self.colorItemArray objectAtIndex:i];
        if (entity.commitCount != 0) {
            [str appendFormat:@"spawn sudo date %@\n",entity.date];
            for (int j = 0; j < entity.commitCount; ++j) {
                [str appendFormat:@"spawn touch %@_%@.txt\n",[entity.date substringToIndex:12],[self randomSix]];
                [str appendString:@"spawn git add .\nspawn git commit -m \"happy\"\n"];
            }
        }
    }
    [str appendFormat:@"spawn sudo date %@\n",[self dataStringWithDeltaDay:0]];
    [str appendString:@"spawn touch thelast.txt\nspawn git add .\nspawn git commit -m \"thelast\"\nspawn git checkout .\n"];
    NSLog(@"%@",str);
    [str writeToFile:@"/Users/dsx/Desktop/dsx.sh" atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
- (IBAction)randomDesign:(UIButton *)sender {
    [self createItemEntityArray];
    for (ItemEntity *entity in self.colorItemArray) {
        NSInteger ra = arc4random()%9;
        entity.commitCount = [[self.timesArray objectAtIndex:ra > 4 ? 0 : ra]integerValue];
        entity.bgColor = [self.colorArray objectAtIndex:ra > 4 ? 0 : ra];
    }
    [self.collectionView reloadData];
}

- (void)resetBoard
{
    [self createItemEntityArray];
    [self.collectionView reloadData];
}

- (void)printCommitBoard
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"#!/usr/bin/expect\n#spawn cd /Users/dsx/Desktop\n#spawn mkdir SXCommitBoard\n#spawn cd SXCommitBoard\nspawn sudo echo 1\nexpect {\n    \"*assword*\" {\n        send \"5678\\n\"\n        exp_continue\n    }\n}\nspawn git init\n"];
    for (int i = 0; i < self.colorItemArray.count; ++i) {
        ItemEntity *entity = [self.colorItemArray objectAtIndex:i];
        if (entity.commitCount != 0) {
            [str appendFormat:@"spawn sudo date %@\n",entity.date];
            for (int j = 0; j < entity.commitCount; ++j) {
                [str appendFormat:@"spawn touch %@_%@.txt\n",[entity.date substringToIndex:12],[self randomSix]];
                [str appendString:@"spawn git add .\nspawn git commit -m \"happy\"\n"];
            }
        }
    }
    [str appendFormat:@"spawn sudo date %@\n",[self dataStringWithDeltaDay:0]];
    [str appendString:@"spawn touch thelast.txt\nspawn git add .\nspawn git commit -m \"thelast\"\nspawn git checkout .\n"];
    NSLog(@"%@",str);
    [str writeToFile:@"/Users/dsx/Desktop/dsx.sh" atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}


#pragma mark -
#pragma mark 工具类方法
/**
 *  判断今天是星期几
 */
-(NSString *)weekStringFromDate:(NSDate *)date{
    NSArray *weeks=@[[NSNull null],@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit= NSCalendarUnitWeekday;
    NSDateComponents *components=[calendar components:calendarUnit fromDate:date];
    return [weeks objectAtIndex:components.weekday];
}

/**
 *  通过天数差得到具体的时间字符串（适配终端指令）
 */
- (NSString *)dataStringWithDeltaDay:(NSInteger)deltaDay
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate new].timeIntervalSince1970 - 86400 * deltaDay];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMddHHmmyyyy.ss"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

/**
 *  随机生成一个6位数
 */
- (NSString *)randomSix
{
    NSInteger random = arc4random_uniform(9999);
    return [NSString stringWithFormat:@"%04ld",(long)random];
}

@end

#pragma mark -

@implementation ItemEntity

@end
