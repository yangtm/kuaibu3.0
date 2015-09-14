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



@end
