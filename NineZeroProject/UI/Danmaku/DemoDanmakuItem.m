//
//  DemoDanmakuItem.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/2/13.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "DemoDanmakuItem.h"
#import "DemoDanmakuItemData.h"
#import "UIImageView+CornerRadius.h"
#import "HTUIHeader.h"

@interface DemoDanmakuItem ()

@property (nonatomic, readonly) CGFloat avatarLength;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation DemoDanmakuItem

+ (NSString *)reuseIdentifier {
    return @"DemoItemIdentifier";
}

+ (CGFloat)itemHeight {
    return 30;
}

- (CGFloat)avatarLength {
    return 20;
}

#pragma mark - Overrides
#pragma mark LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:[[self class] reuseIdentifier]];
}

// if you custom your item through xib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
}

#pragma mark Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarImageView.image = nil;
    self.descLabel.text = nil;
}

- (void)itemWillBeDisplayedWithData:(DemoDanmakuItemData *)data {
    self.backView.layer.cornerRadius = 15;
    self.backView.backgroundColor = data.backColor;
//    self.avatarImageView.image = [UIImage imageNamed:data.avatarName];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.avatarName] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    self.descLabel.text = data.desc;
}

#pragma mark - Setup
- (void)setupSubViews {
    [self.avatarImageView zy_cornerRadiusAdvance:self.avatarLength/2.0 rectCornerType:UIRectCornerAllCorners];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.textAlignment = NSTextAlignmentLeft;
}

@end