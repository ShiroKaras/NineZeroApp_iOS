//
//  HTMascotDisplayController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotDisplayController.h"
#import "HTUIHeader.h"

@interface HTMascotDisplayController ()

@property (nonatomic, strong) UIImageView *onlyOneMascotImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation HTMascotDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMake(14, 14, 14);
    
    self.onlyOneMascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_animation_1"]];
    [self.view addSubview:self.onlyOneMascotImageView];
    
    self.tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_default_msg_bg"]];
    [self.view addSubview:self.tipImageView];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0xd9d9d9];
    self.tipLabel.text = @"快帮我寻找更多的零仔吧!";
    [self.tipImageView addSubview:self.tipLabel];
    
    [self buildConstraints];
}

- (void)buildConstraints {
    [self.onlyOneMascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@175);
        make.width.equalTo(@157);
        make.height.equalTo(@157);
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.onlyOneMascotImageView.mas_bottom).equalTo(@11);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipImageView);
        make.centerY.equalTo(self.tipImageView).offset(4);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
