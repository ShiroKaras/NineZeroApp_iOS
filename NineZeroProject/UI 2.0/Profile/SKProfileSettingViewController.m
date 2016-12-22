//
//  SKProfileSettingViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/5.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileSettingViewController.h"
#import "HTUIHeader.h"
#import "FileService.h"

#import "UIViewController+ImagePicker.h"
#import "SKLoginRootViewController.h"

@interface SKProfileSettingViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *backView1;
@property (nonatomic, strong) UIView        *backView2;
@property (nonatomic, strong) UIView        *backView3;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *usernameLabel;
@property (nonatomic, strong) UITextField   *usernameTextField;
@property (nonatomic, strong) UIView        *dimmingView;
@property (nonatomic, strong) UILabel       *cacheLabel;

@end

@implementation SKProfileSettingViewController {
    SKUserInfo *_userInfo;
    float         cacheSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"settingpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"settingpage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserBaseInfoCallback:^(BOOL success, SKUserInfo *response) {
        _userInfo = response;
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _usernameLabel.text = _userInfo.user_name;
    }];
}

- (void)createUI {
    WS(weakself);
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(20);
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(@19);
    }];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 360+50+40);
    [self.view addSubview:_scrollView];
    
    [self createBackView1];
    [self createBackView2];
    [self createBackView3];
    
    UIButton *quitButton = [UIButton new];
    [quitButton addTarget:self action:@selector(quitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [quitButton setBackgroundImage:[UIImage imageWithColor:COMMON_RED_COLOR] forState:UIControlStateNormal];
    [quitButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    quitButton.layer.cornerRadius = 5;
    quitButton.layer.masksToBounds = YES;
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:quitButton];
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@(50));
        make.top.equalTo(_backView3.mas_bottom).offset(10);
        make.centerX.equalTo(_scrollView);
    }];
}

- (void)createBackView1 {
    _backView1 = [UIView new];
    _backView1.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView1.layer.cornerRadius = 5;
    _backView1.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView1];
    [_backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
 
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView1 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView1).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView1 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView1);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView1);
            make.top.equalTo(@(61*i));
        }];
        
        if (i==0) {
            _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
            _avatarImageView.layer.cornerRadius = 20;
            _avatarImageView.layer.masksToBounds = YES;
            _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:_avatarImageView];
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.equalTo(@40);
                make.centerY.equalTo(view);
                make.left.equalTo(@20);
            }];
        } else if (i==1) {
            _usernameLabel = [UILabel new];
            _usernameLabel.textColor = [UIColor whiteColor];
            _usernameLabel.text = @"用户昵称";
            _usernameLabel.font = PINGFANG_FONT_OF_SIZE(16);
            [_usernameLabel sizeToFit];
            [view addSubview:_usernameLabel];
            [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(@20);
            }];
        }
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
        [arrowImageView sizeToFit];
        [view addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
        }];
        
        UILabel *infoLabel = [UILabel new];
        infoLabel.textColor = [UIColor whiteColor];
        if (i == 0)     infoLabel.text = @"修改头像";
        else if (i == 1)     infoLabel.text = @"修改昵称";
        infoLabel.font = PINGFANG_FONT_OF_SIZE(16);
        [view addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-5);
            make.centerY.equalTo(view);
        }];
        
        UIButton *button = [UIButton new];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(view);
            make.center.equalTo(view);
        }];
        
        if (i==0) {
            [button addTarget:self action:@selector(presentSystemPhotoLibraryController) forControlEvents:UIControlEventTouchUpInside];
        } else if (i==1) {
            [button addTarget:self action:@selector(updateUsername:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)createBackView2 {
    _backView2 = [UIView new];
    _backView2.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView2.layer.cornerRadius = 5;
    _backView2.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView2];
    [_backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView1.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView2 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView2).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView2 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView2);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView2);
            make.top.equalTo(@(61*i));
        }];
        
        if (i == 0) {
            UISwitch *notificationSwitch = [UISwitch new];
            notificationSwitch.onTintColor = COMMON_GREEN_COLOR;
            [view addSubview:notificationSwitch];
            [notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-20);
            }];
        } else if (i == 1) {
            _cacheLabel = [UILabel new];
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            [self listFileAtPath:cacheFilePath];
            _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
            _cacheLabel.textColor = [UIColor whiteColor];
            _cacheLabel.font = PINGFANG_FONT_OF_SIZE(16);
            [view addSubview:_cacheLabel];
            [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-20);
            }];
            
            UIButton *clearCacheButton = [UIButton new];
            [clearCacheButton addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:clearCacheButton];
            [clearCacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(view);
                make.center.equalTo(view);
            }];
        }
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        if (i == 0)     titleLabel.text = @"消息推送";
        else if (i == 1)     titleLabel.text = @"清除缓存";
        titleLabel.font = PINGFANG_FONT_OF_SIZE(16);
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view);
        }];
    }
}

- (void)createBackView3 {
    _backView3 = [UIView new];
    _backView3.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView3.layer.cornerRadius = 5;
    _backView3.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView3];
    [_backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView2.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView3 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView3).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView3 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView3);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView3);
            make.top.equalTo(@(61*i));
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
        [arrowImageView sizeToFit];
        [view addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        if (i == 0)     titleLabel.text = @"什么是九零";
        else if (i == 1)     titleLabel.text = @"关于";
        titleLabel.font = PINGFANG_FONT_OF_SIZE(16);
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view);
        }];
        
        if (i==1) {
            UILabel *infoLabel = [UILabel new];
            infoLabel.text =  [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            infoLabel.textColor = [UIColor whiteColor];
            infoLabel.font = PINGFANG_FONT_OF_SIZE(16);
            [view addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowImageView.mas_left).offset(-5);
                make.centerY.equalTo(view);
            }];
        }
    }
}

#pragma mark - Actions

- (void)updateUsername:(UIButton*)sender {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelUpdateUsername)];
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.8;
    [_dimmingView addSubview:alphaView];
    
    CGRect rect = [sender convertRect:sender.frame toView:self.view];
    UIView *updateUsernameBackView = [[UIView alloc] initWithFrame:rect];
    updateUsernameBackView.backgroundColor = [UIColor whiteColor];
    updateUsernameBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:updateUsernameBackView];
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, updateUsernameBackView.width-28-65, updateUsernameBackView.height)];
    _usernameTextField.delegate = self;
    _usernameTextField.text = _usernameLabel.text;
    _usernameTextField.textColor = COMMON_GREEN_COLOR;
    [_usernameTextField setValue:COMMON_GREEN_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _usernameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 60)];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    [updateUsernameBackView addSubview:_usernameTextField];
    
    UIButton *completeButton = [UIButton new];
    completeButton.layer.cornerRadius = 5;
    [completeButton setBackgroundColor:COMMON_GREEN_COLOR];
    completeButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(16);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeUpdateUsername) forControlEvents:UIControlEventTouchUpInside];
    [updateUsernameBackView addSubview:completeButton];
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 32));
        make.centerY.equalTo(updateUsernameBackView);
        make.right.equalTo(updateUsernameBackView).offset(-14);
    }];
}

- (void)cancelUpdateUsername {
    [_dimmingView removeFromSuperview];
}

- (void)completeUpdateUsername {
    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"处理中" animated:YES];
    _userInfo.user_name = _usernameTextField.text;
    [[[SKServiceManager sharedInstance] profileService] updateUserInfoWith:_userInfo withType:1 callback:^(BOOL success, SKResponsePackage *response) {
        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
        if (success) {
            _usernameLabel.text = _usernameTextField.text;
            [_dimmingView removeFromSuperview];
        } else {
            [MBProgressHUD bwm_showTitle:@"修改用户名失败" toView:KEY_WINDOW hideAfter:1.0];
        }
    }];
}


- (void)listFileAtPath:(NSString *)path {
    cacheSize = 0;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        //        NSLog(@"%@", fullPath);
        //        NSLog(@"%lf", [FileService fileSizeAtPath:fullPath]);
        cacheSize += [FileService fileSizeAtPath:fullPath];
        NSLog(@"%.1lf", cacheSize);
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            [self listFileAtPath:fullPath];
        }
    }
}

#pragma mark - Actions

- (void)clearCache {
    [TalkingData trackEvent:@"clearcache"];
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [FileService clearCache:cacheFilePath];
    [self listFileAtPath:cacheFilePath];
    _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
}

- (void)quitButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] loginService] quitLogin];
    SKLoginRootViewController *rootController = [[SKLoginRootViewController alloc] init];
    HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
    [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self completeUpdateUsername];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _usernameTextField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }else
        return YES;
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];
    
    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"处理中" animated:YES];
    NSString *avatarKey = [NSString avatarName];
    
    [[[SKServiceManager sharedInstance] qiniuService] putData:imageData key:avatarKey token:[[SKStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        if (info.statusCode == 200) {
            _userInfo.user_avatar = [NSString qiniuDownloadURLWithFileName:key];
            [[[SKServiceManager sharedInstance] profileService] updateUserInfoWith:_userInfo withType:0 callback:^(BOOL success, SKResponsePackage *response) {
                [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
                if (success) {
                    [_avatarImageView setImage:image];
                } else {
                    [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0];
                }
            }];
        } else {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0];
        }
    } option:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
