//
//  OrderSuccessController.m
//  kuaibu
//
//  Created by zxy on 15/9/24.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderSuccessController.h"

#import "MineViewController.h"

@interface OrderSuccessController ()

@property (nonatomic,strong) UILabel *orderNoLabel;
@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,strong) UILabel *methodLabel;
@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation OrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"订单提交成功"];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 180)];
    view1.backgroundColor = kViewBackgroundColor;
    [self.view addSubview:view1];
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(10, 0, 80, 60) title:@"订单编号 "];
    label1.font = kLabelFont;
    [view1 addSubview:label1];
    [self addBottomLine:label1];
    
    _orderNoLabel = [self formTitleLabel:CGRectMake(label1.right, 0, kMainScreenWidth - 100, 60) title:@"56145612312318"];
    _orderNoLabel.textColor = [UIColor lightGrayColor];
    _orderNoLabel.font = kLabelFont;
    [view1 addSubview:_orderNoLabel];
    
    UILabel *label2 = [self formTitleLabel:CGRectMake(10, label1.bottom, 80, 60) title:@"订单金额 "];
    label2.font = kLabelFont;
    [view1 addSubview:label2];
    [self addBottomLine:label2];
    
    _payLabel = [self formTitleLabel:CGRectMake(label2.right, label1.bottom, kMainScreenWidth - 100, 60) title:@"565元"];
    _payLabel.textColor = kBackgroundColor;
    _payLabel.font = kLabelFont;
    [view1 addSubview:_payLabel];
    
    UILabel *label3 = [self formTitleLabel:CGRectMake(10, label2.bottom, 80, 60) title:@"支付方式 "];
    label3.font = kLabelFont;
    [view1 addSubview:label3];
//    [self addBottomLine:label3];
    
    _methodLabel = [self formTitleLabel:CGRectMake(label3.right, label2.bottom, kMainScreenWidth - 100, 60) title:@"货到付款"];
    _methodLabel.font = kLabelFont;
    _methodLabel.textColor = [UIColor lightGrayColor];
    [view1 addSubview:_methodLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _methodLabel.bottom, kMainScreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:line];
    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 264, kMainScreenWidth, 100)];
//    view2.backgroundColor = kViewBackgroundColor;
//    [self.view addSubview:view2];
    
//    UILabel *label4 = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth, 40) title:@"你还可以继续 "];
//    label4.textColor = [UIColor lightGrayColor];
//    [view2 addSubview:label4];
    self.publishButton.frame = CGRectMake(0, 264, kMainScreenWidth, 44);
    [self.view addSubview:self.publishButton];
    
}

- (UIButton *)publishButton
{
    if (_publishButton == nil) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _publishButton.layer.cornerRadius = 2.5;
        _publishButton.backgroundColor = kViewBackgroundColor;
        [_publishButton setTitle:@". . 点 击 这 里 可 以 继 续 购 物 . ." forState:UIControlStateNormal];
        [_publishButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [_publishButton addTarget:self action:@selector(clickBtn)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (void)clickBtn
{
    MainTabBarController * svc = [[MainTabBarController alloc] init];
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController = svc;
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
