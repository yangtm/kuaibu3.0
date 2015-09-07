//
//  UIScrollView+AvoidingKeyboard.m
//  AutoAdjustScrollView
//
//  Created by 童小波 on 15/2/13.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import "UIScrollView+AvoidingKeyboard.h"
#import <objc/runtime.h>

static CGRect oldFrame;
static const void *IndieOldFrameKey = &IndieOldFrameKey;
static const void *IndieTextFieldArrayKey = &IndieTextFieldArrayKey;
static const void *IndieCurrentTextFieldKey = &IndieCurrentTextFieldKey;

@interface UIScrollView()

@property(assign, nonatomic) CGRect oldFrame;
@property(strong, nonatomic) NSMutableArray *textFieldArray;
@property(strong, nonatomic) UIView *currentTextField;

@end

@implementation UIScrollView (AvoidingKeyboard)

- (void) autoAdjust
{
    oldFrame = self.frame;
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [self setupReturnKeyType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) removeAdjust
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupReturnKeyType
{
    NSArray *subViewsArray = self.subviews;
    self.textFieldArray = [NSMutableArray array];
    for (UIView *view in subViewsArray) {
        UITextField *textField = [self acquireTextField:view];
        if (textField != nil) {
            textField.returnKeyType = UIReturnKeyNext;
            [textField addTarget:self action:@selector(textFieldDidDoneButtonClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [textField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [self insertTextField:view];
        }
    }
    UIView *lastTextField = [self.textFieldArray lastObject];
    UITextField *textField = [self acquireTextField:lastTextField];
    textField.returnKeyType = UIReturnKeyDone;
}

- (void) insertTextField:(UIView *)view
{
    int i = (int)self.textFieldArray.count - 1;
    for (; i >= 0; i--) {
        UIView *aView = self.textFieldArray[i];
        if (aView.frame.origin.y < view.frame.origin.y) {
            break;
        }
    }
    i++;
    [self.textFieldArray insertObject:view atIndex:i];
}

- (UITextField *) acquireTextField:(UIView *)view
{
    if ([view isKindOfClass:[UITextField class]]) {
        return (UITextField *)view;
    }
    else{
        return nil;
    }
}

- (void) textFieldDidDoneButtonClick:(UITextField *)textField
{
    for (int i = 0; i < self.textFieldArray.count; i++) {
        UITextField *aTextField = [self acquireTextField:self.textFieldArray[i]];
        if (textField == aTextField && i != self.textFieldArray.count - 1) {
            UITextField *nextTextField = [self acquireTextField:self.textFieldArray[i+1]];
            [nextTextField becomeFirstResponder];
        }
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect newFrame = self.frame;
    newFrame.size.height = oldFrame.size.height - keyboardBounds.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    self.frame = newFrame;
    [UIView commitAnimations];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)keyboardWillHide:(NSNotification*)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.frame = oldFrame;
    // commit animations
    [UIView commitAnimations];
}

- (void) didTapped:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

- (void)setTextFieldArray:(NSMutableArray *)textFieldArray
{
    objc_setAssociatedObject(self, IndieTextFieldArrayKey, textFieldArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)textFieldArray
{
    return objc_getAssociatedObject(self, IndieTextFieldArrayKey);
}

- (void)setCurrentTextField:(UIView *)currentTextField
{
    objc_setAssociatedObject(self, IndieCurrentTextFieldKey, currentTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)currentTextField
{
    return objc_getAssociatedObject(self, IndieCurrentTextFieldKey);
}

- (void)setOldFrame:(CGRect)oldFrame
{
    objc_setAssociatedObject(self, IndieOldFrameKey, (__bridge id)(&oldFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)oldFrame
{
    CGRect *pRect = (__bridge CGRect*)objc_getAssociatedObject(self, IndieOldFrameKey);
    return *pRect;
}

@end
