//
//  NZTaskDetailView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/29.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskDetailView.h"
#import "HTUIHeader.h"

@implementation NZTaskDetailView

- (instancetype)initWithFrame:(CGRect)frame withModel:(NSDictionary*)modal
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        titleImageView.layer.masksToBounds = YES;
        titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
            make.right.equalTo(@(-16));
            make.height.mas_equalTo((frame.size.width-32)/288*145);
        }];
        
        UIImageView *imageLabel_Pos = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_position"]];
        [self addSubview:imageLabel_Pos];
        [imageLabel_Pos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImageView);
            make.top.equalTo(titleImageView.mas_bottom).offset(16);
        }];
        
        UILabel *label_Pos = [UILabel new];
        label_Pos.text = @"久神火锅（北京市朝阳区三里屯脏街同利大厦三层久神烧烤）";
        label_Pos.textColor = [UIColor whiteColor];
        label_Pos.font = PINGFANG_FONT_OF_SIZE(12);
        label_Pos.numberOfLines = 0;
        [self addSubview:label_Pos];
        [label_Pos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageLabel_Pos);
            make.right.equalTo(@(-16));
            make.width.equalTo(ROUND_WIDTH(192));
        }];
        
        UIImageView *imageLabel_Time = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_time"]];
        [self addSubview:imageLabel_Time];
        [imageLabel_Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageLabel_Pos);
            make.top.equalTo(label_Pos.mas_bottom).offset(12);
        }];
        
        UILabel *label_Time = [UILabel new];
        label_Time.text = @"11:00 - 22:00";
        label_Time.textColor = [UIColor whiteColor];
        label_Time.font = PINGFANG_FONT_OF_SIZE(12);
        label_Time.numberOfLines = 0;
        [self addSubview:label_Time];
        [label_Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageLabel_Time);
            make.right.equalTo(@(-16));
            make.width.equalTo(ROUND_WIDTH(192));
        }];
        
        UIImageView *imageLabel_Tel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_tel"]];
        [self addSubview:imageLabel_Tel];
        [imageLabel_Tel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageLabel_Time);
            make.top.equalTo(imageLabel_Time.mas_bottom).offset(12);
        }];
        
        UILabel *label_Tel = [UILabel new];
        label_Tel.text = @"010-654321";
        label_Tel.textColor = [UIColor whiteColor];
        label_Tel.font = PINGFANG_FONT_OF_SIZE(12);
        label_Tel.numberOfLines = 0;
        [self addSubview:label_Tel];
        [label_Tel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageLabel_Tel);
            make.right.equalTo(@(-16));
            make.width.equalTo(ROUND_WIDTH(192));
        }];
        
        UIImageView *detailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        titleImageView.layer.masksToBounds = YES;
        titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:detailImageView];
        [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label_Tel.mas_bottom).offset(16);
            make.centerX.equalTo(self);
            make.size.equalTo(titleImageView);
        }];
        
        UILabel *label_detail = [UILabel new];
        label_detail.text = @"详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息-详细信息";
        label_detail.textColor = [UIColor whiteColor];
        label_detail.font = PINGFANG_FONT_OF_SIZE(12);
        label_detail.numberOfLines = 0;
        [self addSubview:label_detail];
        [label_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailImageView.mas_bottom).offset(16);
            make.left.equalTo(detailImageView);
            make.right.equalTo(detailImageView);
        }];
        
        [self layoutIfNeeded];
        _viewHeight = label_detail.bottom;
    }
    return self;
}

@end
