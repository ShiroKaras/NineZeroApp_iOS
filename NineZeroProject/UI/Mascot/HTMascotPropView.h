//
//  HTMascotPropView.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTModel.h"
@class HTMascotPropView;
@protocol HTMascotPropViewDelegate <NSObject>
@required;
- (void)didClickBottomArrawInMascotPropView:(HTMascotPropView *)mascotPropView;
@end
// 零仔道具主页面
@interface HTMascotPropView : UIView
- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props;
@property (nonatomic, weak) id<HTMascotPropViewDelegate> delegate;
@end

@interface HTMascotPropItem : UIButton
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, copy) void(^didClickPropItem)(HTMascotPropItem *item);
@end
