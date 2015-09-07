//
//  YHBPhotoViewController.h
//  TestButton
//
//  Created by Johnny's on 14/11/17.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBPhotoViewController : UIViewController


- (instancetype)initWithPhotoArray:(NSArray *)aPhotoArray andTitle:(NSString *)aTitle andBlock:(void(^)(NSArray *aArray))aBlock andPhotoCount:(int)aPhotoCount;
@end
