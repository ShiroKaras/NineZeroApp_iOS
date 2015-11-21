//
//  UIViewController+ImagePicker.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/22.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImagePicker)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)presentSystemCameraController;
- (void)presentSystemPhotoLibraryController;

@end
