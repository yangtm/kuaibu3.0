//
//  BannerDetailViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/9.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BannerDetailViewController.h"

@interface BannerDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation BannerDetailViewController

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.url = url;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super.navigationController setToolbarHidden:YES animated:TRUE];
    super.navigationController.hidesBottomBarWhenPushed = YES;
    //self.view=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    self.webView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    [self.webView loadRequest:request];
    self.webView.delegate = self;
     
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.webView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    //返回按钮
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 100, 20)];
    [btn1 setTitle:@"返回" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    //self.navigationItem.leftBarButtonItem = item;
    
    
    [FGGProgressHUD showLoadingOnView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    __weak typeof(self) weakSelf=self;
    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    __weak typeof(self) weakSelf=self;
    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    __weak typeof(self) weakSelf=self;
    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, point.y)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
    }
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
