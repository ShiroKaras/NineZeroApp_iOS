//
//  HTMascotIntroCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotIntroCell.h"
#import "HTUIHeader.h"

static CGFloat kLineSpace = 10.0;

@interface HTMascotIntroCell ()

@property (nonatomic, strong) HTImageView *gifImageView;
@property (nonatomic, strong) UIImageView *mascotNumberImageView;
@property (nonatomic, strong) UILabel *mascotIntroLabel;


@end

@implementation HTMascotIntroCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        _gifImageView = [[HTImageView alloc] init];
        [self.contentView addSubview:_gifImageView];
        
        _mascotNumberImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_mascotNumberImageView];
        
        _mascotIntroLabel = [[UILabel alloc] init];
        _mascotIntroLabel.font = [UIFont systemFontOfSize:12];
        _mascotIntroLabel.textColor = [UIColor whiteColor];
        _mascotIntroLabel.numberOfLines = 0;
        _mascotIntroLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_mascotIntroLabel];
    }
    return self;
}

- (void)setMascot:(HTMascot *)mascot {
    if (mascot == nil) return;
    if (mascot.mascotID < 1 && mascot.mascotID > 8) return;
    _mascot = mascot;
    if (mascot.mascotID == 8) {
        [_gifImageView setImage:[UIImage imageNamed:@"mascot_page8"]];
    } else {
        NSString *gifName = [NSString stringWithFormat:@"mascot_page%ld_animation", mascot.mascotID];
        [_gifImageView setAnimatedImageWithName:gifName];
    }
    [_mascotNumberImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_mascot_%ld_page_title", mascot.mascotID]]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = kLineSpace;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName : paragraphStyle,};
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:mascot.mascotDescription attributes:attributes];
    _mascotIntroLabel.attributedText = attrString;
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@35);
        make.centerX.equalTo(self);
        make.width.equalTo(@186);
        make.height.equalTo(@124);
    }];
    
    [_mascotNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_gifImageView.mas_bottom).offset(25);
    }];
    
    [_mascotIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mascotNumberImageView.mas_bottom).offset(25);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [self setNeedsUpdateConstraints];
    [super layoutSubviews];
    [_mascotIntroLabel setPreferredMaxLayoutWidth:SCREEN_WIDTH - 114];
}

+ (CGFloat)calculateCellHeightWithMascot:(HTMascot *)mascot {
    // 固定的指标
    CGFloat standardHeight = 35 + 124 + 25 + 25 + 32;
    
    // 图片的高度
    UIImageView *mascotNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_page_title"]];
    standardHeight += mascotNumber.height;
    
    // 文字的高度
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = kLineSpace;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName : paragraphStyle,};
    CGRect rect = [mascot.mascotDescription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 114, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    standardHeight += rect.size.height;
    return standardHeight;
}

@end
