//
//  MyUtil.m
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+ (UILabel*)createLabel:(CGRect)frame text:(NSString *)title alignment:(NSTextAlignment)alignment fontSize:(CGFloat)Size
{
    UILabel* label = [[UILabel alloc] init];
    label.frame = frame;
    if(title)
    {
        label.text = title;
    }
    if(alignment)
    {
        label.textAlignment = alignment;
    }
    if(Size)
    {
        label.font = [UIFont systemFontOfSize:Size];
    }
    return label;
}

+ (UIImageView*)createImageView:(CGRect)frame imageName:(NSString *)imagename
{
    UIImageView* view = [[UIImageView alloc] init];
    view.frame = frame;
    if(imagename)
    {
        view.image = [UIImage imageNamed:imagename];
    }
    return view;
}

+ (UIButton*)createButton:(CGRect)frame title:(NSString *)title BtnImage:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if(title)
    {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if(imageName)
    {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if(selectImageName)
    {
        [button setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if(target && action)
    {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}


#pragma mark - 自动适配文字宽度／高度
+ (CGFloat)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize.width;
}
@end
