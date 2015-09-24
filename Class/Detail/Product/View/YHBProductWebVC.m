//
//  YHBProductWebVC.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/25.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBProductWebVC.h"

@interface YHBProductWebVC ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIButton *backbutton;
@property (strong, nonatomic) NSString *htmlStr;

@end

@implementation YHBProductWebVC

-(void)back
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sethtmlStr:(NSString *)htmlStr
{
    _htmlStr = htmlStr;
    [self.webView loadHTMLString:_htmlStr baseURL:nil];
    MLOG(@"%@",htmlStr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
    [self.webView loadHTMLString:self.htmlStr baseURL:nil];
}

- (UIButton *)backbutton
{
    if (_backbutton == nil) {
        _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backbutton.frame = CGRectMake(0, 0, 30, 30);
        [_backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backbutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backbutton;
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
