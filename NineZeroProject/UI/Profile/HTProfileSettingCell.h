//
//  HTProfileSettingCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTProfileSettingCell : UITableViewCell
- (void)setTitleText:(NSString *)text;
- (NSString *)titleText;
- (void)showSeparator:(BOOL)show;
@end

@interface HTProfileSettingTextCell : HTProfileSettingCell
- (void)setTitleColor:(UIColor *)color;
- (void)showAccessoryArrow:(BOOL)show;
- (void)setDetailTitleText:(NSString *)text;
@end

@interface HTProfileSettingTextFieldCell :HTProfileSettingCell
@end

@protocol HTProfileSettingPushCellDelegate <NSObject>
- (void)onClickPushSettingSwitch:(BOOL)switchOn;
@end
@interface HTProfileSettingPushCell : HTProfileSettingCell
- (void)setSwitchValueOn:(BOOL)on;
@property (nonatomic, weak) id<HTProfileSettingPushCellDelegate> delegate;
@end

@interface HTProfileSettingAvatarCell : HTProfileSettingTextCell
- (void)setImageAvatarURL:(NSURL *)url;
- (void)setImage:(UIImage *)image;
@end

@interface HTProfileSettingBlankCell : HTProfileSettingCell
@end

@interface HTProfileSettingQuitLoginCell : UITableViewCell
@end