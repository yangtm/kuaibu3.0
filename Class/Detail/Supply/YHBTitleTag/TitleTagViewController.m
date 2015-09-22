//
//  TitleTagViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 14/12/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "TitleTagViewController.h"
#import "SVProgressHUD.h"

@interface TitleTagViewController ()
{
    NSArray *itemArray;
    UITextField *textField;
    void(^myBlock)(NSString *aTitle);
}
@end

@implementation TitleTagViewController

- (void)useBlock:(void (^)(NSString *))aBlock
{
    myBlock = aBlock;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 62)];
    topView.backgroundColor = RGBCOLOR(249, 249, 249);
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 27.5, 30, 30)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [topView addSubview:leftBtn];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 25, kMainScreenWidth-42-64, 32)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 2.5;
    textField.placeholder = @"请输入标题";
    [topView addSubview:textField];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(textField.right+5, 20, 36, 44)];
    [rightBtn addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [topView addSubview:rightBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, topView.bottom+10, 100, 17)];
    label.font = kFont14;
    label.text = @"热门标签 : ";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    [self showFlower];
    
    int interVal = 10;
    float btnWidth = (kMainScreenWidth-interVal*5)/4.0;
    manage = [[TitleTagManage alloc] init];
    [manage getTitleTag:_type succBlock:^(NSArray *aArray) {
        
        [self dismissFlower];
        itemArray = aArray;
        int count = (kMainScreenWidth-10)/(10+btnWidth);
        int j=0;
        for (int i=0; i<aArray.count; i++)
        {
            NSString *str = [aArray objectAtIndex:i];
            j = i/count;
            float btnX = 10+(btnWidth+10)*(i%count);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, label.bottom+10+35*j, btnWidth, 25)];
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font = kFont14;
            [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10+i;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            btn.layer.borderWidth = 0.5;
            [self.view addSubview:btn];
        }
        
    } andFailBlock:^{
        
    }];
}

#pragma mark 菊花
- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

- (void)touchBtn:(UIButton *)aBtn
{
    int index = aBtn.tag-10;
    NSString *str = [itemArray objectAtIndex:index];
    textField.text = str;
}

- (void)touch
{
    NSString *text = textField.text;
    self.navigationController.navigationBarHidden = NO; 
    if (text==nil || [text isEqualToString:@" "] || [text isEqualToString:@"  "] || [text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空" cover:YES offsetY:kMainScreenHeight/2.0];
    }
    else
    {
        myBlock(textField.text);
        [self dismissFlower];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)back
{
    [self dismissFlower];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
