//
//  SKSwipeViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKSwipeViewController.h"
#import "HTUIHeader.h"

@interface SKSwipeViewController ()
@property (nonatomic, strong) UIImageView *scanningGridLine;
@end

@implementation SKSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
    [self.glView setOrientation:self.interfaceOrientation];
    
    _scanningGridLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_gridlines"]];
    [_scanningGridLine sizeToFit];
    _scanningGridLine.top = 0;
    _scanningGridLine.right = 0;
    [self.view addSubview:_scanningGridLine];
    
    [UIView animateWithDuration:1.0 animations:^{
        _scanningGridLine.left = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        _scanningGridLine.right = 0;
        _scanningGridLine.alpha = 0.4;
        [UIView animateWithDuration:1.0 animations:^{
            _scanningGridLine.left = SCREEN_WIDTH;
        } completion:^(BOOL finished) {
            [_scanningGridLine removeFromSuperview];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glView start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glView stop];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.glView resize:self.view.bounds orientation:self.interfaceOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.glView setOrientation:toInterfaceOrientation];
}


@end
