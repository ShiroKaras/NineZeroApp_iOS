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
        
        UILabel *taskLevelLabel = [UILabel new];
        taskLevelLabel.text = @"任务难度";
        taskLevelLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
        taskLevelLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [taskLevelLabel sizeToFit];
        [self.contentView addSubview:taskLevelLabel];
        [taskLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taskTitleImageView.mas_bottom).offset(9);
            make.left.equalTo(_taskTitleImageView);
        }];
        
        UIView *underLine = [UIView new];
        underLine.backgroundColor = [UIColor colorWithHex:0x303030];
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

@end
