//
//  HTMainViewController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMainViewController.h"
#import "HTPreviewQuestionController.h"

@interface HTMainViewController () <HTPreviewQuestionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *mascotButton;
@property (weak, nonatomic) IBOutlet UIButton *meButton;

@end

@implementation HTMainViewController {
    UIViewController *_currentViewController;
    __weak HTPreviewQuestionController *_preViewController;
}

- (instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HTPreviewQuestionController *previewController = [[HTPreviewQuestionController alloc] init];
    _currentViewController = previewController;
    [self changedToViewController:previewController];
}

- (void)changedToViewController:(UIViewController *)viewController {
    if (_currentViewController) {
        [_currentViewController willMoveToParentViewController:nil]; //1
        [_currentViewController.view removeFromSuperview]; //2
        [_currentViewController removeFromParentViewController]; //3
    }
    if ([viewController isKindOfClass:[HTPreviewQuestionController class]]) {
        [(HTPreviewQuestionController *)viewController setDelegate:self];
        _preViewController = (HTPreviewQuestionController *)viewController;
    }
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [self.view sendSubviewToBack:viewController.view];
    _currentViewController = viewController;
}

#pragma mark - Action

- (IBAction)didClickMainButton:(id)sender {
    if([(UIButton *)sender tag] == 1000) {
        if (_preViewController) {
            [_preViewController goToToday];
        }
    }
}

- (IBAction)didClickMascotButton:(id)sender {

}

- (IBAction)didClickMeButton:(id)sender {

}


#pragma mark HTPreviewQuestionController Delegate

- (void)previewController:(HTPreviewQuestionController *)previewController shouldShowGoBackItem:(BOOL)needShow {
    if (needShow) {
        [_mainButton setImage:[UIImage imageNamed:@"tab_back_today"] forState:UIControlStateNormal];
        _mainButton.tag = 1000;
    } else {
        [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        _mainButton.tag = 0;
    }
}

@end
