//
//  MainTabBarController.h
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController
@property (nonatomic,assign) NSInteger newSelectIndex;
-(void) showTabBarController;

-(void) hiddenTabBarController;

@end
