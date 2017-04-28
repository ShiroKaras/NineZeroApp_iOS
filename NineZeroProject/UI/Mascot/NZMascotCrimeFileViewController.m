//
//  NZMascotCrimeFileViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZMascotCrimeFileViewController.h"
#import "HTUIHeader.h"

#import "NZEvidenceView.h"

@interface NZMascotCrimeFileViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) SKMascot *mascot;
@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *titleImageView2;

@property (nonatomic, strong) NZEvidenceView *propView;
@end

@implementation NZMascotCrimeFileViewController

- (instancetype)initWithMascot:(SKMascot *)mascot {
    self = [super init];
    if (self) {
        _mascot = mascot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_archivespage_title"]];
    [titleView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView).offset(10);
    }];
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    _mScrollView.contentSize = CGSizeMake(_mScrollView.width, _mScrollView.height*2);
    _mScrollView.delegate = self;
    _mScrollView.bounces = NO;
    [self.view addSubview:_mScrollView];
    
    _infoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, self.view.width-32, (self.view.width-32)/288*142)];
    _infoImageView.backgroundColor = COMMON_GREEN_COLOR;
    [_mScrollView addSubview:_infoImageView];
    
    UIImageView *titleImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_archivespage_case"]];
    [_mScrollView addSubview:titleImageView1];
    titleImageView1.top = _infoImageView.bottom +16;
    titleImageView1.left = _infoImageView.left;
    
    _infoLabel = [UILabel new];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.font = PINGFANG_FONT_OF_SIZE(12);
    _infoLabel.numberOfLines = 0;
    [_mScrollView addSubview:_infoLabel];
    _infoLabel.top = titleImageView1.bottom +16;
    _infoLabel.left = 16;
    _infoLabel.width = self.view.width-32;
    
    _titleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_archivespage_evidence"]];
    [_mScrollView addSubview:_titleImageView2];
    [_titleImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoLabel.mas_bottom).offset(16);
        make.left.equalTo(titleImageView1);
    }];
    [self.view layoutIfNeeded];
//    titleImageView2.top = _infoLabel.bottom +16;
//    titleImageView2.left = titleImageView1.left;
    
    [self loadData];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] mascotService] getMascotDetailWithMascotID:_mascot.pet_id callback:^(BOOL success, SKMascot *mascot) {
        _mascot = mascot;
        _infoLabel.text = mascot.pet_desc;
        [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:5.0];
        [_infoLabel sizeToFit];
        
        [self.view layoutIfNeeded];
        
        int width = (self.view.width -16*2 -12*3)/4;
        int top = _titleImageView2.bottom;
        int count=24;
        for (int i=0; i<count; i++) {
            int x = i%4;
            int y = (int)i/4;
            UIButton *propView = [[UIButton alloc] initWithFrame:CGRectMake(16+x*(width+12), top+16+y*(width+12), width, width)];
            propView.backgroundColor = [UIColor clearColor];
            propView.layer.borderWidth = 2;
            propView.layer.borderColor = [UIColor whiteColor].CGColor;
            [propView addTarget:self action:@selector(didClickProp:) forControlEvents:UIControlEventTouchUpInside];
            propView.backgroundColor = COMMON_GREEN_COLOR;
            [_mScrollView addSubview:propView];
        }
        
        _mScrollView.contentSize = CGSizeMake(self.view.width, _titleImageView2.bottom+16+((int)(count/4))*(width+16));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)didClickProp:(UIButton *)sender {
    _propView = [[NZEvidenceView alloc] initWithFrame:self.view.bounds withMascot:self.mascot];
    _propView.userInteractionEnabled = YES;
    [self.view addSubview:_propView];
}

@end
