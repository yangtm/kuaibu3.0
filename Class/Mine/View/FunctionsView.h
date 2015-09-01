//
//  FunctionsView.h
//  Register
//
//  Created by zxy on 15/8/27.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionsView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
