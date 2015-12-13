//
//  HTPreviewItem.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTPreviewItem;

@protocol HTPreviewItemDelegate <NSObject>

- (void)previewItem:(HTPreviewItem *)previewItem didClickComposeButton:(UIButton *)composeButton;

@end

@interface HTPreviewItem : UIView

@property (weak, nonatomic) id<HTPreviewItemDelegate> delegate;

@end
