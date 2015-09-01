//
//  RootTabBarController.h
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarController : UITabBarController<UITabBarControllerDelegate,UITabBarDelegate,UIActionSheetDelegate>
-(void) showTabBarController;

-(void) hiddenTabBarController;
@end
