//
//  HTProfileSettingCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileSettingCell.h"
#import "HTUIHeader.h"
#import "HTLoginRootController.h"

@interface HTProfileSettingCell ()
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UIImageView *accessoryArrow;
@property (nonatomic, strong) UISwitch *theSwitch;
@end

@implementation HTProfileSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COMMON_BG_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor colorWithHex:0x1a1a1a];
        [self.contentView addSubview:_separator];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_titleLabel];
        
        _accessoryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_setting_right_arrow"]];
        [self.contentView addSubview:_accessoryArrow];
    }
    return self;
}

- (void)setTitleText:(NSString *)text {
    _titleLabel.text = text;
    [_titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)titleText {
    return _titleLabel.text;
}

- (void)showSeparator:(BOOL)show {
    _separator.hidden = !show;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _separator.frame = CGRectMake(0, self.height - 1, self.width, 1);
    _titleLabel.left = 23;
    _titleLabel.centerY = self.height / 2;
    _accessoryArrow.right = self.width - 6;
    _accessoryArrow.centerY = self.height / 2;
}

@end

@implementation HTProfileSettingTextFieldCell
@end

@implementation HTProfileSettingTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTitleLabel = [[UILabel alloc] init];
        self.detailTitleLabel.font = [UIFont systemFontOfSize:17];
        self.detailTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.detailTitleLabel];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
    [self setNeedsLayout];
}

- (void)setDetailTitleText:(NSString *)text {
    self.detailTitleLabel.text = text;
    [self.detailTitleLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)showAccessoryArrow:(BOOL)show {
    self.accessoryArrow.hidden = !show;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.accessoryArrow.hidden) {
        self.detailTitleLabel.right = SCREEN_WIDTH - 21;
    } else {
        self.detailTitleLabel.right = self.accessoryArrow.left - 17;
    }
    self.detailTitleLabel.centerY = self.height / 2;
    
    self.titleLabel.width = MIN(self.titleLabel.width, 200);
}

@end

typedef NS_ENUM(NSUInteger, WWKSwitchBoolValue) {
    WWKSwitchBoolValueNO,
    WWKSwitchBoolValueYES,
    WWKSwitchBoolValueUnknown,
};

@implementation HTProfileSettingPushCell {
    WWKSwitchBoolValue _lastSwitchState;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.theSwitch = [[UISwitch alloc] init];
        self.theSwitch.onTintColor = [UIColor colorWithHex:0xd50e88];
        [self.theSwitch addTarget:self action:@selector(turnSwitchChangeValue:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.theSwitch];
        
        _lastSwitchState = WWKSwitchBoolValueUnknown;
    }
    return self;
}

- (void)setSwitchValueOn:(BOOL)on {
    self.theSwitch.on = on;
    _lastSwitchState = (self.theSwitch.isOn) ? WWKSwitchBoolValueYES : WWKSwitchBoolValueNO;
}

- (void)turnSwitchChangeValue:(UISwitch *)turnSwitch {
    WWKSwitchBoolValue boolValue = (turnSwitch.isOn) ? WWKSwitchBoolValueYES : WWKSwitchBoolValueNO;
    if (_lastSwitchState == WWKSwitchBoolValueUnknown || _lastSwitchState != boolValue) {
        _lastSwitchState = boolValue;
        [self.delegate onClickPushSettingSwitch:turnSwitch.isOn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.accessoryArrow.hidden = YES;
    self.theSwitch.right = self.width - 20;
    self.theSwitch.centerY = self.height / 2;
}

@end

@implementation HTProfileSettingAvatarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [self.contentView addSubview:self.avatarImageView];
        self.titleLabel.hidden = YES;
    }
    return self;
}

- (void)setImageAvatarURL:(NSURL *)url {
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    if (image == nil) return;
    self.avatarImageView.image = image;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarImageView.layer.cornerRadius = 25.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.frame = CGRectMake(23, self.height / 2 - 25, 50, 50);
}

@end

@implementation HTProfileSettingBlankCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.hidden = YES;
    self.accessoryArrow.hidden = YES;
}
@end

@interface HTProfileSettingQuitLoginCell () <UIAlertViewDelegate>
@property (nonatomic, strong) UILabel *quitLabel;
@end
@implementation HTProfileSettingQuitLoginCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COMMON_GREEN_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        HTLoginButton *quitButton = [HTLoginButton buttonWithType:UIButtonTypeCustom];
        [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        quitButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        quitButton.enabled = YES;
        [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quitButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _quitLabel.centerX = self.width / 2;
    _quitLabel.centerY = self.height / 2;
}

- (void)quitButtonClick {
    [self.delegate onClickQuitSettingButton];
}


@end

