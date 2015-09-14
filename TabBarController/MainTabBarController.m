//
//  MainTabBarController.m
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomePageViewController.h"
#import "FriendsViewController.h"
#import "MineViewController.h"
#import "SearchViewController.h"
#import "ThirdViewController.h"
#import "ThirdViewController.h"
#import "BuyDetailViewController.h"
#import "YHBPublishBuyViewController.h"
#import "YHBPublishSupplyViewController.h"
#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "HZCookie.h"
#import "AppDelegate.h"


@interface MainTabBarController ()<UITabBarControllerDelegate,UIActionSheetDelegate>
{
    BOOL _isLogin;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self createViewControllers];
}

#pragma mark - 创建视图控制器
- (void)createViewControllers
{
    //视图控制器数组
    NSArray *vcArray = @[@"HomePageViewController",
                         @"SearchViewController",
                         @"ThirdViewController",
                         @"FriendsViewController",
                         @"MineViewController"];
    //tabbar按钮图片
    NSArray * imageArray = @[@"55副本",
                             @"3",
                             @"60",
                             @"62副本",
                             @"64副本"];
    //tabbar选中按钮的图片
    NSArray * clickImageArray = @[@"55",
                                  @"4",
                                  @"60",
                                  @"62",
                                  @"64"];
    NSArray * titleArray = @[@"首页",@"发现",@"布得了",@"朋友",@"我的"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //循环创建视图控制器
    for (int i = 0; i < vcArray.count; i++) {
        UIViewController *vc = [[NSClassFromString(vcArray[i]) alloc] init];
        vc.tabBarItem.title = titleArray[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:clickImageArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        navi.tabBarItem.tag = i;
        [array addObject:navi];
    }
    self.viewControllers = array;
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if ((tabBarController.selectedIndex==4 || tabBarController.selectedIndex == 3) && !app.isLoginedIn) {
        _newSelectIndex = 0;
        //先检查用户是否保存了账号密码
        //        [ProgressHUD show:@"加载中..."];
        tabBarController.selectedIndex =0;
        NSString *usernameInfile = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
        NSString *passwordInfile = [[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
        if([usernameInfile isEqualToString:@""]||[passwordInfile isEqualToString:@""])
        {
            //如果用户名或密码为空,那用户可能是第一次登录，或者没有记住用户名密码
            //直接推出登录界面
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *loginNavi = [[UINavigationController alloc]initWithRootViewController:loginVC];
            tabBarController.selectedIndex =0;
            [tabBarController presentViewController:loginNavi animated:YES completion:^{
                
                [ProgressHUD dismiss];
            }];
            
            
        }
        else{
            //如果用户名密码都有保存在本地,那检查用户的session登录状态
            //取出保存的session
            [HZCookie setCookie];
            NSString *url = nil;
            kYHBRequestUrl(@"member/memberInfo", url);
            [NetworkService postWithURL:url paramters:nil success:^(NSData *receiveData) {
                [ProgressHUD dismiss];
                
                NSDictionary *resDic =[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                if ([resDic[@"RESPCODE"] integerValue] == 0) {
                    app.isLoginedIn = 1;
                    tabBarController.selectedIndex = 4;
                }else{
                    [HZCookie removeCookie];
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                    tabBarController.selectedIndex =0;
                    [viewController presentViewController:navi animated:YES completion:^{
                        
                    }];
                }
            } failure:^(NSError *error) {
                [ProgressHUD showError:@"网络超时"];
            }];
            
        }
    }else if (tabBarController.selectedIndex == 2){
        tabBarController.selectedIndex = _newSelectIndex;
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布采购",@"发布商品",@"以图搜布", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }else if (tabBarController.selectedIndex == 0){
        _newSelectIndex = tabBarController.selectedIndex;
    }else if (tabBarController.selectedIndex == 1){
        _newSelectIndex = tabBarController.selectedIndex;
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf=self;
    switch (buttonIndex) {
        case 0:
        {
            if (app.isLoginedIn) {
                YHBPublishBuyViewController *supplyVC = [[YHBPublishBuyViewController alloc] init];
                
                [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:supplyVC] animated:YES completion:^{
                    
                }];
            }else{
                [weakSelf showAlertWithMessage:@"请先登入" automaticDismiss:YES];
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                UINavigationController *loginNavi = [[UINavigationController alloc]initWithRootViewController:loginVC];
                app.tabBarVC.selectedIndex =0;
                [self presentViewController:loginNavi animated:YES completion:^{
                    
                }];
            }
            
        }
            break;
        case 1:
        {
            if (app.isLoginedIn) {
                YHBPublishSupplyViewController *supplyVC = [[YHBPublishSupplyViewController alloc] init];
                
                [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:supplyVC] animated:YES completion:^{
                    
                }];
            }else{
                [weakSelf showAlertWithMessage:@"请先登入" automaticDismiss:YES];
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                UINavigationController *loginNavi = [[UINavigationController alloc]initWithRootViewController:loginVC];
                app.tabBarVC.selectedIndex =0;
                [self presentViewController:loginNavi animated:YES completion:^{
                    
                }];
            }
            
        }
            break;
        case 2:
        {
            if (app.isLoginedIn) {
                
            }else{
                [weakSelf showAlertWithMessage:@"请先登入" automaticDismiss:YES];
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                UINavigationController *loginNavi = [[UINavigationController alloc]initWithRootViewController:loginVC];
                app.tabBarVC.selectedIndex =0;
                [self presentViewController:loginNavi animated:YES completion:^{
                    
                }];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if(automatic)
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.0f];
    
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

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    NSLog(@"....");
    
}

-(void) showTabBarController
{
    if(self.tabBar)
    {
        self.tabBar.hidden = NO;
    }
}

-(void) hiddenTabBarController
{
    if(self.tabBar)
    {
        self.tabBar.hidden = YES;
    }
}



@end
