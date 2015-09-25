//
//  OrderTableView.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableView : UITableView<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,strong)MJRefreshHeaderView *headerView;
@property(nonatomic,strong)MJRefreshFooterView *footerView;
@property(nonatomic,copy)void (^selectBlock)(NSString *urlString);

@end
