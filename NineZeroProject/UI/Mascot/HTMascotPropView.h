//
//  HTMascotPropView.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTModel.h"

// 零仔道具页面
@interface HTMascotPropView : UIView
- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props;
@end

@interface HTMascotPropItem : UIButton
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, copy) void(^didClickPropItem)(HTMascotPropItem *item);
@end
