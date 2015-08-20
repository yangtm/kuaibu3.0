//
//  LSNavigationController.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-11.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "LSNavigationController.h"
#import <objc/runtime.h>

@interface LSNavigationController ()
{
    NSString *unEnablePopGestureRcognizer;
}
@end

@implementation LSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak LSNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    unEnablePopGestureRcognizer = [self getIvarObject:@"unEnablePopGesture"target:viewController];
    
    if(self.navigationBarHidden == YES)
    {
        unEnablePopGestureRcognizer = @"NO";
    }
    if(unEnablePopGestureRcognizer && [unEnablePopGestureRcognizer compare:@"NO"] == 0)
    {
        if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    else
    {
        if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (id)getIvarObject:(NSString *)ivarName target:(id)aTarget
{
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([aTarget class], &outCount);
    NSString *propertyName = nil;
    for(int i=0; i<outCount; i++)
    {
        Ivar ivar = vars[i];
        const char *cVarName = ivar_getName(ivar);
        propertyName = [[NSString alloc] initWithCString:cVarName encoding:NSUTF8StringEncoding];
        NSString *instanceVar = [NSString stringWithFormat:@"_%@",ivarName];
        if([propertyName compare:ivarName] == 0 || [propertyName compare:instanceVar] == 0)
        {
            break;
        }
        else
        {
            propertyName = nil;
        }
    }
    id resultid = nil;
    if(propertyName)
    {
        resultid = [aTarget valueForKey:propertyName];
    }
    return resultid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
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
