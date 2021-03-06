//
//  SKRegisterTextField.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKRegisterTextField : UIView

@property (nonatomic,copy) NSString *ly_placeholder;                //注释信息
@property (nonatomic,strong) UITextField *textField;                //文本框
@property (nonatomic,strong) UIColor *cursorColor;                  //光标颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;  //注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;  //注释选中状态下颜色

@end
