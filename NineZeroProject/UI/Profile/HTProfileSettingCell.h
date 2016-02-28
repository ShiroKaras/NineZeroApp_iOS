//
//  HTProfileSettingCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTProfileSettingCell : UITableViewCell
- (void)setTitleText:(NSString *)text;
- (void)showSeparator:(BOOL)show;
@end

@interface HTProfileSettingTextCell : HTProfileSettingCell
- (void)setTitleColor:(UIColor *)color;
- (void)showAccessoryArrow:(BOOL)show;
- (void)setDetailTitleText:(NSString *)text;
@end

@interface HTProfileSettingTextFieldCell :HTProfileSettingCell
@end

@interface HTProfileSettingPushCell : HTProfileSettingCell
@end

@interface HTProfileSettingAvatarCell : HTProfileSettingTextCell
- (void)setImageAvatarURL:(NSURL *)url;
- (void)setImage:(UIImage *)image;
@end

@interface HTProfileSettingBlankCell : HTProfileSettingCell
@end

@interface HTProfileSettingQuitLoginCell : UITableViewCell
@end