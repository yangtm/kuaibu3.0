//
//  HomePageSearchViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePageSearchViewController.h"

@interface HomePageSearchViewController ()

//历史数据
@property (strong, nonatomic) NSArray *historyWords;
//热搜数据
@property (strong, nonatomic) NSArray *hotWords;
@property (strong, nonatomic) UIView *HotWordsView;
@end

@implementation HomePageSearchViewController


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.8118 green:0.8157 blue:0.8196 alpha:1];
    
    [self getHotWords];
    self.hotWords = [NSArray array];
    self.hotWords = @[@"手机", @"洗发水", @"电视机", @"女衬衫 新品", @"T恤 男", @"四件套", @"手表", @"春装 女包", @"儿童套装", @"运动裤", @"连衣裙"];
    
    [self.view addSubview:self.HotWordsView];
    [self setupHotWords];
}

//获取热门搜索关键字
- (void)getHotWords
{
    /*
     [self.manager requestHotwordsWithType:7 complete:^(NSArray *hotWords) {
     
     self.hotWords = hotWords;
     [self.collectionView reloadData];
     
     } error:^(NSString *error) {
     
     }];*/
}

-(void)setupHotWords
{
    UILabel *hotwordslabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 70, 20)];
    hotwordslabel.text = @"热门搜索";
    // hotwordslabel.textColor = [UIColor blackColor];
    hotwordslabel.font = [UIFont systemFontOfSize:14];
    [_HotWordsView addSubview:hotwordslabel];
    
    UIButton *wordsFirst = [[UIButton alloc]initWithFrame:CGRectMake(10 + hotwordslabel.width , 20, 0, 0)];
    
    //NSLog(@"first=%f",wordsFirst.frame.origin.x);
    for (NSInteger i = 0; i < self.hotWords.count; i++) {
        
        UIButton *words =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [words setTitle:[_hotWords objectAtIndex:i] forState:UIControlStateNormal];
        [words setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSLog(@"%@",words.titleLabel.text);
       // words.backgroundColor = [UIColor redColor];
        CGSize textBlockMinSize = {130, 25};
        CGSize pricesize = [words.titleLabel.text sizeWithFont:words.titleLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
        [words setFrame:CGRectMake(pricesize.width + wordsFirst.frame.origin.x, 20, pricesize.width, pricesize.height)];
        //NSLog(@"lozation=%f",words.width);
        wordsFirst = words;
        [_HotWordsView addSubview:words];
    }
}

- (UIView *)HotWordsView
{
    if (!_HotWordsView) {
        _HotWordsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 100)];
        _HotWordsView.backgroundColor = [UIColor whiteColor];
    }
    return _HotWordsView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
