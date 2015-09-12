//
//  MainTabBarController.h
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController<UITabBarControllerDelegate,UITabBarDelegate,UIActionSheetDelegate>
@property(strong,nonatomic) UITabBarController *controller;
-(void) showTabBarController;

-(void) hiddenTabBarController;

@end
