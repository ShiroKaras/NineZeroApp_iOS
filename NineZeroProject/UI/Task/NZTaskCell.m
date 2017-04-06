//
//  NZTaskCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskCell.h"
#import "HTUIHeader.h"

@interface NZTaskCell ()
@property (nonatomic, strong) UIImageView   *taskImageView;
@property (nonatomic, strong) UIImageView   *taskTitleImageView;
@property (nonatomic, strong) UILabel       *distanceLabel;

@property (nonatomic, strong) UIImageView   *deleteImageView;
@end

@implementation NZTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _taskImageView = [UIImageView new];
        _taskImageView.image = [UIImage imageNamed:@"img_monday_music_cover_default"];
        _taskImageView.contentMode = UIViewContentModeScaleAspectFill;
        _taskImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_taskImageView];
        [_taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo((self.width-32)/288*145);
        }];
        
        _taskTitleImageView = [UIImageView new];
        _taskTitleImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_taskTitleImageView];
        [_taskTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskImageView.mas_bottom).offset(16);
            make.left.equalTo(_taskImageView);
            make.right.equalTo(_taskImageView);
            make.height.equalTo(@16);
        }];
        
        //Level
        UILabel *taskLevelLabel = [UILabel new];
        taskLevelLabel.text = @"任务难度";
        taskLevelLabel.textColor = COMMON_TEXT_2_COLOR;
        taskLevelLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [taskLevelLabel sizeToFit];
        [self.contentView addSubview:taskLevelLabel];
        [taskLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskTitleImageView.mas_bottom).offset(9);
            make.left.equalTo(_taskTitleImageView);
        }];
        
        for (int i=0; i<5; i++) {
            UIImageView *levelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_level"]];
            [self.contentView addSubview:levelImageView];
            [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
                make.centerY.equalTo(taskLevelLabel.mas_centerY);
                make.left.equalTo(taskLevelLabel.mas_right).offset(4+25*i);
            }];
        }
        
        //Distance
        _distanceLabel = [UILabel new];
        _distanceLabel.text = @"0m";
        _distanceLabel.textColor = taskLevelLabel.textColor;
        _distanceLabel.font = PINGFANG_FONT_OF_SIZE(10);
        [_distanceLabel sizeToFit];
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(taskLevelLabel);
            make.right.equalTo(_taskImageView);
        }];
        
        //Underline
        UIView *underLine = [UIView new];
        underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
        [self.contentView addSubview:underLine];
        [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.width.equalTo(_taskImageView);
            make.centerX.equalTo(_taskImageView);
            make.top.equalTo(taskLevelLabel.mas_bottom).offset(9);
        }];
        
        [self layoutIfNeeded];
        self.cellHeight = underLine.bottom;
    }
    
    return self;
}

// 改变滑动删除按钮样式
- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            UIButton *confirmView=(UIButton *)[subView.subviews firstObject];
            // 改背景颜色
            confirmView.backgroundColor = COMMON_BG_COLOR;
            [confirmView setImage:[UIImage imageNamed:@"btn_taskbook_delete"] forState:UIControlStateNormal];
            [confirmView setImage:[UIImage imageNamed:@"btn_taskbook_delete_highlight"] forState:UIControlStateHighlighted];
            confirmView.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 14);

            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    [sub removeFromSuperview];
                }
            }
            break;
        }
    }
}

@end
