//
//  HTPreviewItem.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTQuestion;
@class HTPreviewItem;

@protocol HTPreviewItemDelegate <NSObject>

- (void)previewItem:(HTPreviewItem *)previewItem didClickComposeButton:(UIButton *)composeButton;
- (void)previewItem:(HTPreviewItem *)previewItem didClickContentButton:(UIButton *)contentButton;

@end

@interface HTPreviewItem : UIView

@property (strong, nonatomic) HTQuestion *question;
@property (weak, nonatomic) id<HTPreviewItemDelegate> delegate;

@end
