//
//  SKMascotFightViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/1/4.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKMascotFightViewController.h"
#import "HTUIHeader.h"

#import "SKMascotFightManager.h"

@interface SKMascotFightViewController () <SKMascotFightManagerDelegate>
@property (nonatomic, strong) SKMascotFightManager *fightManager;
@end

@implementation SKMascotFightViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fightManager = [[SKMascotFightManager alloc] initWithSize:self.view.size];
    self.fightManager.delegate = self;
    
    [self.fightManager startFight];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SKMascotFightManagerDelegate

- (void)setupMascotFightViewWithCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer {
    [self.view.layer addSublayer:cameraLayer];
}

@end
