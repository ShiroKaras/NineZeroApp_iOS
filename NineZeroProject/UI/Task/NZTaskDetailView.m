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

- (instancetype)initWithFrame:(CGRect)frame withModel:(SKStrongholdItem*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageLabel_Pos = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_position"]];
        [self addSubview:imageLabel_Pos];
        [imageLabel_Pos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.top.equalTo(@16);
        }];
        
        UILabel *label_Pos = [UILabel new];
        label_Pos.text = model.target_address;
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
        label_Time.text = model.target_time;
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
        label_Tel.text = model.telephone;
        label_Tel.textColor = [UIColor whiteColor];
        label_Tel.font = PINGFANG_FONT_OF_SIZE(12);
        label_Tel.numberOfLines = 0;
        [self addSubview:label_Tel];
        [label_Tel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageLabel_Tel);
            make.right.equalTo(@(-16));
            make.width.equalTo(ROUND_WIDTH(192));
        }];
        
        [self layoutIfNeeded];
        _viewHeight = label_Tel.bottom;
        
        for (int i=0; i<model.article_details.count; i++) {
            if ([[[model.article_details[i] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]||
                [[[model.article_details[i] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"png"]||
                [[[model.article_details[i] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"gif"]) {
                
                UIImageView *detailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
                detailImageView.layer.masksToBounds = YES;
                detailImageView.contentMode = UIViewContentModeScaleAspectFill;
                [detailImageView sd_setImageWithURL:[NSURL URLWithString:model.article_details[i]] placeholderImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
                [self addSubview:detailImageView];
                [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_viewHeight+16);
                    make.centerX.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(frame.size.width-32, (frame.size.width-32)/288*145));
                }];
                [self layoutIfNeeded];
                _viewHeight = detailImageView.bottom;
                
            } else {
                //间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 13; // 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName: PINGFANG_FONT_OF_SIZE(14),
                                             NSParagraphStyleAttributeName: paragraphStyle,
                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                             };
                
                UILabel *label_detail = [UILabel new];
                label_detail.attributedText = [[NSAttributedString alloc] initWithString:model.article_details[i] attributes:attributes];
                label_detail.textColor = [UIColor whiteColor];
                label_detail.font = PINGFANG_FONT_OF_SIZE(12);
                label_detail.numberOfLines = 0;
                [self addSubview:label_detail];
                [label_detail mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_viewHeight+16);
                    make.left.equalTo(@16);
                    make.right.equalTo(self.mas_right).offset(-16);
                }];
                [self layoutIfNeeded];
                _viewHeight = label_detail.bottom;
            }
        }
        
    }
    return self;
}

@end
