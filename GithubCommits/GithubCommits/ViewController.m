//
//  ViewController.m
//  GithubCommits
//
//  Created by dongshangxian on 16/8/6.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "ViewController.h"
#define SXRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ViewController ()

@property(nonatomic,strong)NSArray *colorArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.colorArray = @[SXRGBColor(234, 234, 234),SXRGBColor(205, 227, 115),SXRGBColor(123, 190, 83),SXRGBColor(56, 150, 49),SXRGBColor(25, 87, 27)];
    
    int col = 0;
    int row = 0;
    int x = 0;
    int y = 0;
    int width = 10;
    int height = 10;
    for (int i = 0; i< 370; ++i) {
        col = i/7;
        row = i%7;
        x = 50 + col * (width + 2);
        y = 100 + row * (width +2);
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(x, y, width, height);
        btn.backgroundColor = SXRGBColor(234, 234, 234);
        [self.view addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
