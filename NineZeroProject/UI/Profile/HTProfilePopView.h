//
//  HTProfilePopView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/24.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTProfilePopView;
@protocol HTProfilePopViewDelegate <NSObject>
- (void)profilePopViewWillDismiss:(HTProfilePopView *)popView;
@end

@interface HTProfilePopView : UIView
@property (nonatomic, weak) id<HTProfilePopViewDelegate> delegate;
@end
