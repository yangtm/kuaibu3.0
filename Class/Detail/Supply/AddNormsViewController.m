//
//  AddNormsViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "AddNormsViewController.h"
#import "NormsModle.h"
#import "NormsManager.h"

@interface AddNormsViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) NormsModle *norms;
@property (nonatomic,assign) BOOL isEditing;
@end

@implementation AddNormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEditing = _model != nil;
    NSString *title = _isEditing?@"修改":@"保存";
    self.norms = [NormsModle shareNormsModle];
    
    [self settitleLabel:@"添加规格"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(clickLeftBtn)];
    [self setRightButton:nil title:title target:self action:@selector(clickRightBtn)];
    
   
    UILabel *nameLabel = [MyUtil createLabel:CGRectMake(10, 100, 80, 44) text:@"规格名称 : " alignment:NSTextAlignmentRight fontSize:15];
    [self.view addSubview:nameLabel];
    UILabel *priceLabel = [MyUtil createLabel:CGRectMake(10, 160, 80, 44) text:@"价格 : " alignment:NSTextAlignmentRight fontSize:15];
    [self.view addSubview:priceLabel];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.right + 5, 100, 150, 40)];
    _nameTextField.placeholder = @"请输入规格名称";
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _nameTextField.delegate = self;
    [self.view addSubview:_nameTextField];
    
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(priceLabel.right + 5, 160, 120, 40)];
    _priceTextField.placeholder = @"请输入价格";
    _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
    _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    _priceTextField.delegate = self;
    [self.view addSubview:_priceTextField];
    
    UILabel *label = [MyUtil createLabel:CGRectMake(_priceTextField.right + 5, 160, 20, 44) text:@"元" alignment:NSTextAlignmentLeft fontSize:15];
    [self.view addSubview:label];
    
    if (_model) {
        _nameTextField.text = _model.specificationName;
        _priceTextField.text = _model.price;
    }
    
}

- (void)clickLeftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn
{
    
    if (_nameTextField.text.length >0 && _priceTextField.text.length > 0) {
        //查询标题是否重复
        self.norms.specificationName = _nameTextField.text;
        self.norms.price = _priceTextField.text;
    
        NormsManager * manger = [NormsManager shareManager];
        
        if ([manger selectByName:self.norms.specificationName]) {
            
            UIAlertView * alert1  = [[UIAlertView alloc] initWithTitle:nil message:@"规格名已经存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert1 show];
            [alert1 dismissWithClickedButtonIndex:1 animated:YES];
            return;
        }
        if (!_isEditing) {
            [self addDataToDataBase:self.norms];
            
            UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert dismissWithClickedButtonIndex:1 animated:YES];
        }else{
            NormsManager *manager = [NormsManager shareManager];
            [manager updateName:_nameTextField.text price:_priceTextField.text];
            [manager showTableDetail];
            UIAlertView * alert1  = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert1 show];
            [alert1 dismissWithClickedButtonIndex:1 animated:YES];
        }

        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:nil message:@"内容不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [al show];
        [al dismissWithClickedButtonIndex:1 animated:YES];
    }
}

#pragma mark - 存入数据库
- (void)addDataToDataBase:(NormsModle *)norms
{
    NormsManager * manager = [NormsManager shareManager];
    [manager insertData:norms];
    NSLog(@"%@",norms.price);
    [manager showTableDetail];
    
    NSLog(@"%@", NSHomeDirectory());
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
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
