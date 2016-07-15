//
//  HTAboutController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTAboutController.h"
#import "HTUIHeader.h"

@interface HTAboutController ()
@property (weak, nonatomic) IBOutlet UIImageView *aboutImageView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation HTAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLabel)];
    
    self.aboutLabel.userInteractionEnabled = YES;
    [self.aboutLabel addGestureRecognizer:tap];
    
    self.aboutImageView.userInteractionEnabled = YES;
    [self.aboutImageView addGestureRecognizer:tap];
    
    self.versionLabel.text = [NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLabel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.90app.tv"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
