//
//  HTCommonViewController.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/24.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCommonViewController : UIViewController <UITextFieldDelegate> {
@protected
    UITextField *_firstTextField;
    UITextField *_secondTextField;
    UIButton *_nextButton;
    UIButton *_verifyButton;
}

- (BOOL)isNextButtonValid;
- (void)didClickVerifyButton;

@end

@interface HTCommonViewController (SubClass)

// 验证码倒计时
- (BOOL)needScheduleVerifyTimer;
// 下一步操作应该进行
- (void)nextButtonNeedToBeClicked;
// 申请验证码
- (void)needGetVerificationCode;

@end
