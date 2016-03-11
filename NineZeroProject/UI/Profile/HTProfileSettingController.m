//
//  HTProfileSettingController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileSettingController.h"
#import "HTProfileLocationController.h"
#import "HTFeedbackController.h"
#import "HTAboutController.h"
#import "HTProfileSettingCell.h"
#import "HTUIHeader.h"
#import "UIViewController+ImagePicker.h"
#import "HTLoginRootController.h"

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

@implementation HTProfileSettingController {
    NSArray<NSNumber *> *_cellTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COMMON_BG_COLOR;
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
        return cell;
    } else if (type == HTProfileSettingTypeName) {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell setDetailTitleText:@"修改昵称"];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypeBlank) {
        HTProfileSettingBlankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingBlankCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypePush) {
        HTProfileSettingPushCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingPushCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypeAbout) {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell showAccessoryArrow:NO];
        [cell setDetailTitleText:@"v1.0"];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    } else if (type == HTProfileSettingTypeQuitLogin) {
        HTProfileSettingQuitLoginCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingQuitLoginCell class]) forIndexPath:indexPath];
        return cell;
    } else {
        HTProfileSettingTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileSettingTextCell class]) forIndexPath:indexPath];
        [cell setTitleText:[self titleWithIndexPath:indexPath]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeAvatar) return 78;
    else if (type == HTProfileSettingTypeBlank) return 30;
    else if (type == HTProfileSettingTypeQuitLogin) return 50;
    else return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileSettingType type = [self typeWithIndexPath:indexPath];
    if (type == HTProfileSettingTypeLocation) {
        HTProfileLocationController *locationController = [[HTProfileLocationController alloc] init];
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
        [[[HTServiceManager sharedInstance] loginService] quitLogin];
        HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    HTProfileSettingAvatarCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [cell setImage:image];
//    UIImage *resizeImage = [UIImage imageWithImage:image scaledToSize:_avatarButton.size];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
//    [imageData writeToFile:imagePath atomically:YES];
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

@end
