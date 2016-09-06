//
//  ViewController.m
//  GithubCommits
//
//  Created by dongshangxian on 16/8/6.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "ViewController.h"
#define SXRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ItemEntity : NSObject<NSCoding>

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,assign)NSInteger commitCount;

@end

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *compwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *useremailTxt;
@property (weak, nonatomic) IBOutlet UITextField *comusersTxt;

@property(nonatomic,assign)NSInteger dayCount;
@property(nonatomic,strong)NSArray *colorArray;
@property(nonatomic,strong)NSArray *timesArray;
@property(nonatomic,strong)UIView *drawView;

@property(nonatomic,strong)UITextField *saveNameTxt;

@property(nonatomic,strong)UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 数据源
@property(nonatomic,strong)NSMutableArray<ItemEntity *> *itemEntityArray;
@property(nonatomic,strong)NSMutableArray *localFiles;
@property(nonatomic,strong)NSString *currentName;

@property(nonatomic,assign)BOOL isClearing;

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
    
    self.compwdTxt.text = @"5678";
    self.useremailTxt.text = @"dantesx2012@gmail.com";
    self.usernameTxt.text = @"dongshangxian";
    self.comusersTxt.text = @"dsx";
    
    [self createItemEntityArray];
    [self createCollectionView];
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.layer.cornerRadius = 4;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tableView.layer.borderWidth = 2;
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
    self.itemEntityArray = [NSMutableArray array];
    for (int i = 0; i<self.dayCount; i++) {
        ItemEntity *entity = [ItemEntity new];
        entity.bgColor = SXRGBColor(234, 234, 234);
        entity.date = [self dataStringWithDeltaDay:self.dayCount - i -1];
        [self.itemEntityArray addObject:entity];
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
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 150, 650, 82) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:self.collectionView];
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
    if (self.itemEntityArray.count > indexPath.row + 1) {
        ItemEntity *currentEntity = [self.itemEntityArray objectAtIndex:indexPath.item];
        cell.backgroundColor = currentEntity.bgColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.item);
    ItemEntity *currentEntity = [self.itemEntityArray objectAtIndex:indexPath.item];
    if (self.isClearing) {
        currentEntity.bgColor = self.colorArray[0];
        currentEntity.commitCount = [self.timesArray[0] integerValue];
    }else{
        UIColor *bgColor = currentEntity.bgColor;
        NSInteger index = [self.colorArray indexOfObject:bgColor];
        bgColor = [self.colorArray objectAtIndex:(index + 1)%5];
        currentEntity.bgColor = bgColor;
        currentEntity.commitCount = [[self.timesArray objectAtIndex:(index + 1)%5] integerValue];
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isClearing = !self.isClearing;
}

#pragma mark -
#pragma mark 数据源代理方法tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = self.localFiles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.localFiles[indexPath.row];
    self.currentName = [name substringToIndex:name.length - 4];
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:name];
    self.itemEntityArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self.collectionView reloadData];
    self.tableView.hidden = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:self.localFiles[indexPath.row]];
    [self.localFiles removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSFileManager* fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        if ([fm isDeletableFileAtPath:path]) {
            [fm removeItemAtPath:path error:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"清";
}

#pragma mark -
#pragma mark 操作类方法

- (IBAction)resetBtnClick:(UIButton *)sender {
    [self createItemEntityArray];
    [self.collectionView reloadData];
}
- (IBAction)generater:(UIButton *)sender {
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"#!/usr/bin/expect\n#spawn cd /Users/dsx/Desktop\n#spawn mkdir SXCommitBoard\n#spawn cd SXCommitBoard\nspawn sudo echo 请稍等3分钟不要关闭\nexpect {\n    \"*assword*\" {\n        send \"%@\\n\"\n        exp_continue\n    }\n}\n",self.compwdTxt.text];
    [str appendFormat:@"exec git config user.name %@\nexec git config user.email %@\n",self.usernameTxt.text,self.useremailTxt.text];
    for (int i = 0; i < self.itemEntityArray.count; ++i) {
        ItemEntity *entity = [self.itemEntityArray objectAtIndex:i];
        if (entity.commitCount != 0) {
            [str appendFormat:@"exec sudo date %@\n",entity.date];
            for (int j = 0; j < entity.commitCount; ++j) {
                [str appendFormat:@"exec touch %@_%@.txt\nexec sleep 0.1\n",[entity.date substringToIndex:12],[self randomSix]];
                [str appendString:@"exec git add .\nexec sleep 0.1\nexec git commit -m \"happy\"\nexec sleep 0.1\n"];
            }
        }
    }
    [str appendFormat:@"exec sudo date %@\n",[self dataStringWithDeltaDay:0]];
    [str appendString:@"exec touch thelast.txt\nexec git add .\nexec git commit -m \"thelast\"\nexec git checkout .\n"];
    NSLog(@"%@",str);
    NSString *file = [NSString stringWithFormat:@"/Users/%@/Desktop/dsx.sh",self.comusersTxt.text];
    [str writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
- (IBAction)randomDesign:(UIButton *)sender {
    [self createItemEntityArray];
    for (ItemEntity *entity in self.itemEntityArray) {
        NSInteger ra = arc4random()%9;
        entity.commitCount = [[self.timesArray objectAtIndex:ra > 4 ? 0 : ra]integerValue];
        entity.bgColor = [self.colorArray objectAtIndex:ra > 4 ? 0 : ra];
        if ((entity.commitCount == 7) && (arc4random()%10 < 5)) {
            entity.commitCount = 3;
            entity.bgColor = self.colorArray[1];
        }
    }
    [self.collectionView reloadData];
}
- (IBAction)saveBoard {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"保存画板" message:@"输入保存的名字" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"键盘回调");
        self.saveNameTxt = textField;
        if (self.currentName) {
            self.saveNameTxt.text = self.currentName;
        }
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dsx",self.saveNameTxt.text]];
        NSLog(@"path=%@",path);
        NSFileManager* fm=[NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            if ([fm isDeletableFileAtPath:path]) {
                [fm removeItemAtPath:path error:nil];
            }
        }
        [NSKeyedArchiver archiveRootObject:self.itemEntityArray toFile:path];
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)openBoard {
    if (!self.tableView.hidden) {
        self.tableView.hidden = YES;
        return;
    }
    NSFileManager* fm= [NSFileManager defaultManager];
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    if([fm fileExistsAtPath:docPath]){
        //取得一个目录下得所有文件名
        NSArray *files = [fm subpathsAtPath: docPath];
        NSMutableArray *userfuls = [NSMutableArray array];
        for (NSString *name in files) {
            if([name hasSuffix:@".dsx"]){
                [userfuls addObject:name];
            }
        }
        self.localFiles = userfuls;
        if (self.localFiles.count > 0) {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    }
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

-(void)encodeWithCoder:(NSCoder *)aCoder
 {
    [aCoder encodeObject:self.bgColor forKey:@"bgColor"];
    [aCoder encodeInteger:self.commitCount forKey:@"commitCount"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

 -(id)initWithCoder:(NSCoder *)aDecoder
 {
    if (self =[super init]) {
        self.bgColor =[aDecoder decodeObjectForKey:@"bgColor"];
        self.commitCount =[aDecoder decodeIntegerForKey:@"commitCount"];
        self.date =[aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
