//
//  SKSwipeViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKSwipeViewController.h"

@interface SKSwipeViewController ()

@end

@implementation SKSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
    [self.glView setOrientation:self.interfaceOrientation];
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
