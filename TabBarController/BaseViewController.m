//
//  BaseViewController.m
//  kuaibu3.0
//
//  Created by zxy on 15/8/20.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewInteraction.h"
#import "MobClick.h"


@interface BaseViewController ()
{
    UILabel *titleLabel;
}
@end

@implementation BaseViewController

@synthesize g_OffsetY;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if (self != [self.navigationController.viewControllers objectAtIndex:0])
//    {
//        [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
//    }
}

- (void)dealloc
{
    _headerView.scrollView = nil;
    _footerView.scrollView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackgroundimg:(UIImage *)aBackgroundimg
{
    if(aBackgroundimg)
    {
        _backgroundimg = [aBackgroundimg resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        [imgview setImage:_backgroundimg];
        [self.view addSubview:imgview];
    }
}

- (void)setLeftButton:(UIImage *)aImg title:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector
{
    CGRect buttonFrame = CGRectMake(-5, 0, 44, 44);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.backgroundColor = [UIColor clearColor];
    
    CGRect viewFrame = CGRectMake(0, 0, 88/2, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    if(aImg)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 30, 30)];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        imageView.image = aImg;
        [view addSubview:imageView];
    }
    if(aTitle)
    {
        [button setTitle:aTitle forState:UIControlStateNormal];
    }
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    if(self.navigationController && self.navigationItem)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

- (void)settitleLabel:(NSString*)aTitle
{
    if(!titleLabel)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, self.navigationController.navigationBar.frame.size.height)];
        self.navigationItem.titleView = titleLabel;
    }
    titleLabel.center = self.navigationController.navigationBar.center;
    titleLabel.backgroundColor = kClearColor;
    titleLabel.textColor = kNaviTitleColor;
    titleLabel.font = kFont20;
    titleLabel.text = aTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setRightButton:(UIImage *)aImg title:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector
{
    CGRect buttonFrame = CGRectMake(5, 0, 59.0f, 44.0f);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect viewFrame = CGRectMake(0, 0, 88/2, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    if(aImg)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 11, 25, 25)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.image = aImg;
        [view addSubview:imageView];
    }
    if(aTitle)
    {
        [button setTitle:aTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    [view addSubview:button];
    if(self.navigationController && self.navigationItem)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
    _rightButton = button;
}

- (void)pushView:(UIView*)aView
{
    [ViewInteraction viewPresentAnimationFromRight:self.view toView:aView];
}

- (void)popView:(UIView*)aView completeBlock:(void(^)(BOOL isComplete))aCompleteblock
{
    [ViewInteraction viewDissmissAnimationToRight:aView isRemove:NO completeBlock:^(BOOL isComplete) {
        aCompleteblock(isComplete);
    }];
}

/**
 *  警告视图
 *
 *  @param message   警告信息
 *  @param automatic 警告视图是否自动消失
 */
-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if(automatic)
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2.0f];
    
}
/**
 *  消失警告视图
 *
 *  @param alert 警告视图
 */
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self shadedStar:label];
    return label;
}

- (void) shadedStar:(UILabel *)label
{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
        label.attributedText = attrubuteStr;
    }
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = 101;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}
@end
