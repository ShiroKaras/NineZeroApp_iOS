//
//  HTProfileSettingController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileSettingController.h"
#import "HTProfileLocationController.h"
#import "HTFeedbackController.h"
#import "HTAboutController.h"
#import "HTProfileSettingCell.h"
#import "HTUIHeader.h"
#import "UIViewController+ImagePicker.h"
#import "HTLoginRootController.h"

@protocol HTProfileSettingChangeNameViewDelegate <NSObject>
- (void)onClickUserButtonWithUserInfo:(HTUserInfo *)userInfo;
@end
@interface HTProfileSettingChangeNameView : UIView <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, strong) HTUserInfo *userInfo;
@property (nonatomic, weak) id<HTProfileSettingChangeNameViewDelegate> delegate;

@property (nonatomic, strong) UILabel *tipsLabel;                ///< 提示
@property (nonatomic, strong) UIView *tipsBackView;              ///< 提示背景

- (void)showTipsWithText:(NSString *)text;

@end

@implementation HTProfileSettingChangeNameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDimmingView)];
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
        
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBackView];
        
        _textField = [[UITextField alloc] init];
        _textField.textColor = COMMON_GREEN_COLOR;
        _textField.delegate = self;
        _textField.text = @"用户名";
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_whiteBackView addSubview:_textField];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COMMON_GREEN_COLOR;
        _sureButton.layer.cornerRadius = 5.0f;
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        _sureButton.titleLabel.textColor = [UIColor whiteColor];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
        [_whiteBackView addSubview:_sureButton];
        
        // 5. 提示
        _tipsBackView = [[UIView alloc] init];
        _tipsBackView.backgroundColor = COMMON_PINK_COLOR;
        _tipsBackView.hidden = YES;
        [_dimmingView addSubview:_tipsBackView];
        
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor whiteColor];
        [_tipsBackView addSubview:_tipsLabel];
        
        // 5. 提示
        [_tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dimmingView).offset(20);
            make.width.equalTo(_dimmingView);
            make.height.equalTo(@30);
        }];
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tipsBackView);
        }];
    }
    return self;
}

- (void)setUserInfo:(HTUserInfo *)userInfo {
    _userInfo = [userInfo copy];
    _textField.text = userInfo.user_name;
}

- (void)setCoverOffsetYInScreen:(CGFloat)offsetY {
    _offsetY = offsetY;
    [self setNeedsLayout];
}

- (void)onClickDimmingView {
    [self removeFromSuperview];
}

- (void)onClickSureButton {
    if ([_textField.text isEqualToString:@""]||_textField.text==nil) {
        [self showTipsWithText:@"昵称不可为空"];
    } else if (![_userInfo.user_name isEqualToString:_textField.text]) {
        HTUserInfo *userInfo = [_userInfo copy];
        userInfo.user_name = _textField.text;
        [self.delegate onClickUserButtonWithUserInfo:userInfo];
    } else {
        [self removeFromSuperview];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickSureButton];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _textField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _dimmingView.frame = self.bounds;
    _whiteBackView.frame = CGRectMake(0, _offsetY, self.width, 51);
    _textField.frame = CGRectMake(23, 0, SCREEN_WIDTH - 150, 51);
    _sureButton.frame = CGRectMake(0, 0, 85, 30);
    _sureButton.right = self.width - 8;
    _sureButton.centerY = _whiteBackView.height / 2.0;
}

- (void)showTipsWithText:(NSString *)text {
    _tipsLabel.text = text;
    CGFloat tipsBottom = _tipsBackView.bottom;
    _tipsBackView.bottom = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _tipsBackView.hidden = NO;
        _tipsBackView.bottom = tipsBottom;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _tipsBackView.bottom = 0;
            } completion:^(BOOL finished) {
                _tipsBackView.bottom = tipsBottom;
                _tipsBackView.hidden = YES;
            }];
        });
    }];
}

@end

typedef enum : NSUInteger {
    HTProfileSettingTypeAvatar,
    HTProfileSettingTypeName,
    HTProfileSettingTypeLocation,
    HTProfileSettingTypeExplain,
    HTProfileSettingTypeBlank,
    HTProfileSettingTypePush,
    HTProfileSettingTypeFeedback,
    HTProfileSettingTypeClearCache,
    HTProfileSettingTypeAbout,
    HTProfileSettingTypeQuitLogin,
} HTProfileSettingType;

static NSInteger const kChangeNameViewTag = 12345;

@interface HTProfileSettingController () <HTProfileSettingPushCellDelegate, HTProfileSettingChangeNameViewDelegate>

@end

@implementation HTProfileSettingController {
    NSArray<NSNumber *> *_cellTypes;
    HTUserInfo *_userInfo;
}

- (instancetype)initWithUserInfo:(HTUserInfo *)userInfo {
    if (self = [super init]) {
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    self.navigationItem.title = @"设置";
    _cellTypes = @[@(HTProfileSettingTypeAvatar), @(HTProfileSettingTypeName), @(HTProfileSettingTypeLocation), @(HTProfileSettingTypeExplain), @(HTProfileSettingTypeBlank), @(HTProfileSettingTypePush), @(HTProfileSettingTypeFeedback), @(HTProfileSettingTypeClearCache), @(HTProfileSettingTypeAbout), @(HTProfileSettingTypeBlank), @(HTProfileSettingTypeQuitLogin)];
    [self.tableView registerClass:[HTProfileSettingAvatarCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingAvatarCell class])];
    [self.tableView registerClass:[HTProfileSettingTextFieldCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingTextFieldCell class])];
    [self.tableView registerClass:[HTProfileSettingCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingCell class])];
    [self.tableView registerClass:[HTProfileSettingTextCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingTextCell class])];
    [self.tableView registerClass:[HTProfileSettingPushCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingPushCell class])];
    [self.tableView registerClass:[HTProfileSettingBlankCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingBlankCell class])];
    [self.tableView registerClass:[HTProfileSettingQuitLoginCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileSettingQuitLoginCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeAvatar) {
        HTProfileSettingAvatarCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingAvatarCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        [cell setDetailTitleText:@"修改头像"];
        [cell setImageAvatarURL:[NSURL URLWithString:_userInfo.user_avatar]];
        return cell;
    } else if (type == HTProfileSettingTypeName) {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell setDetailTitleText:@"修改昵称"];
        [cell setTitleText:_userInfo.user_name];
        [cell setTitleColor:COMMON_GREEN_COLOR];
        return cell;
    } else if (type == HTProfileSettingTypeBlank) {
        HTProfileSettingBlankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingBlankCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypePush) {
        HTProfileSettingPushCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingPushCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        [cell setSwitchValueOn:_userInfo.push_setting];
        cell.delegate = self;
        return cell;
    } else if (type == HTProfileSettingTypeAbout) {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell showAccessoryArrow:NO];
        [cell setDetailTitleText:@"v1.0"];
        [cell setTitleColor:[UIColor whiteColor]];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypeQuitLogin) {
        HTProfileSettingQuitLoginCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingQuitLoginCell class]) forIndexPath:indexPath];
        return cell;
    } else {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        [cell setTitleColor:[UIColor whiteColor]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeAvatar) return 68;
    else if (type == HTProfileSettingTypeBlank) return 30;
    else if (type == HTProfileSettingTypeQuitLogin) return 50;
    else return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeLocation) {
        HTProfileLocationController *locationController = [[HTProfileLocationController alloc] initWithUserInfo:_userInfo];
        [self.navigationController pushViewController:locationController animated:YES];
    } else if (type == HTProfileSettingTypeAbout) {
        HTAboutController *aboutController = [[HTAboutController alloc] init];
        [self.navigationController pushViewController:aboutController animated:YES];
    } else if (type == HTProfileSettingTypeFeedback) {
        HTFeedbackController *feedbackController = [[HTFeedbackController alloc] init];
        [self.navigationController pushViewController:feedbackController animated:YES];
    } else if (type == HTProfileSettingTypeAvatar) {
        [self presentSystemPhotoLibraryController];
    } else if (type == HTProfileSettingTypeQuitLogin) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    } else if (type == HTProfileSettingTypeName) {
        HTProfileSettingChangeNameView *changeView = [[HTProfileSettingChangeNameView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [changeView setUserInfo:_userInfo];
        changeView.tag = kChangeNameViewTag;
        changeView.delegate = self;
        [changeView setOffsetY:68 + 44 + 20 - self.tableView.contentOffset.y];
        [KEY_WINDOW addSubview:changeView];
    } else if (type ==HTProfileSettingTypeClearCache) {
        [MBProgressHUD bwm_showTitle:@"清除成功" toView:KEY_WINDOW hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
    } else if (type ==HTProfileSettingTypeExplain){
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        [[[HTServiceManager sharedInstance] loginService] quitLogin];
        HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];

    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"处理中" animated:YES];
    NSString *avatarKey = [NSString avatarName];
    [[[HTServiceManager sharedInstance] qiniuService] putData:imageData key:avatarKey token:[[HTStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        if (info.statusCode == 200) {
            _userInfo.user_avatar = [NSString qiniuDownloadURLWithFileName:key];
            _userInfo.settingType = HTUpdateUserInfoTypeAvatar;
            [[[HTServiceManager sharedInstance] profileService] updateUserInfo:_userInfo completion:^(BOOL success, HTResponsePackage *response) {
                [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
                if (success) {
                    HTProfileSettingAvatarCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    [cell setImage:image];
                } else {
                    [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
                }
            }];
        } else {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
        }
    } option:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (HTProfileSettingType)typeWithIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = (HTProfileSettingType)[[_cellTypes objectAtIndex:indexPath.row] integerValue];
    return type;
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeAvatar) return @"修改头像";
    if (type == HTProfileSettingTypeName) return @"用户名";
    if (type == HTProfileSettingTypeLocation) return @"管理地址";
    if (type == HTProfileSettingTypeExplain) return @"什么是九零？";
    if (type == HTProfileSettingTypePush) return @"消息推送";
    if (type == HTProfileSettingTypeFeedback) return @"帮助我们进步";
    if (type == HTProfileSettingTypeClearCache) return @"清除缓存";
    if (type == HTProfileSettingTypeAbout) return @"关于";
    return @"";
}

#pragma mark - HTProfileSettingPushCell Delegate

- (void)onClickPushSettingSwitch:(BOOL)switchOn {
    _userInfo.push_setting = switchOn;
    _userInfo.settingType = HTUpdateUserInfoTypePushSetting;
    [[[HTServiceManager sharedInstance] profileService] updateUserInfo:_userInfo completion:^(BOOL success, HTResponsePackage *response) {
    }];
}

#pragma mark - HTProfileSettingChangeNameView Delegate

- (void)onClickUserButtonWithUserInfo:(HTUserInfo *)userInfo {
    [HTProgressHUD show];
    userInfo.settingType = HTUpdateUserInfoTypeName;
    HTProfileSettingTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[[HTServiceManager sharedInstance] profileService] updateUserInfo:userInfo completion:^(BOOL success, HTResponsePackage *response) {
        [HTProgressHUD dismiss];
        if (response.resultCode == 0) {
            _userInfo = userInfo;
            [cell setTitleText:userInfo.user_name];
            [[KEY_WINDOW viewWithTag:kChangeNameViewTag] removeFromSuperview];
        } else if (response.resultCode == -2002) {
            [self showTipsWithText:@"该用户名已存在" offset:20];
        }
        DLog(@"Name: %@", _userInfo.user_name);
    }];
}

@end
