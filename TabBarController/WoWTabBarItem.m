//
//  WoWTabBarItem.m
//  WoWMusiPlayer
//
//  Created by 童小波 on 15/6/10.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import "WoWTabBarItem.h"
//#import <pop/POP.h>

@implementation WoWTabBarItem

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.resposeEnable = YES;
        
        self.userInteractionEnabled = NO;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _imageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 - 7);
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        if (![title isEqualToString:@""] && title != nil) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 18, self.bounds.size.width, 12)];
            _label.text = title;
            _label.font = [UIFont systemFontOfSize:12.0];
            _label.textColor = RGBCOLOR(79, 76, 76);
            _label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_label];
        }
        else{
            _imageView.frame = CGRectMake(0, 0, 40, 40);
            _imageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        }
    }
    return self;
}

- (void)setSelect
{
//    self.backgroundColor = [UIColor redColor];
    if (!_resposeEnable) {
        return;
    }
//    _label.hidden = YES;
    _imageView.image = [UIImage imageNamed:@"55"];
//    [UIView animateWithDuration:0.4 animations:^{
//        
//        _imageView.layer.transform = CATransform3DTranslate(_imageView.layer.transform, 0, 6, 0);
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            _imageView.layer.transform = CATransform3DScale(_imageView.layer.transform, 1.5, 1.5, 1);
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//    }];
}

- (void)setUnselect
{
    if (!_resposeEnable) {
        return;
    }
//    _label.alpha = 0.0;
//    _label.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        
//        _imageView.layer.transform = CATransform3DTranslate(_imageView.layer.transform, 0, -10, 0);
        _imageView.layer.transform = CATransform3DIdentity;
        _label.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
//    self.backgroundColor = [UIColor clearColor];
}

@end
