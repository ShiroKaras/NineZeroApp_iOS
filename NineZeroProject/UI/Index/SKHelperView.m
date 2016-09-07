//
//  SKHelperView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKHelperView.h"
#import "HTUIHeader.h"

@interface SKHelperView (){

}
@property (nonatomic, strong) UIImageView   *cardImageView;
@property (nonatomic, strong) UILabel       *textLabel;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, assign) SKHelperType  type;

@end

@implementation SKHelperView

- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperType)type index:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        _index = index;
        _type = type;
        
        UIView *dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.alpha = 0.8;
        [self addSubview:dimmingView];
        
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-276)/2, ROUND_HEIGHT_FLOAT(60), 276, 356)];
        cardView.layer.cornerRadius = 5;
        cardView.backgroundColor = [UIColor colorWithHex:0x1D1D1D];
        [self addSubview:cardView];
        
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 276, 293)];
        [cardView addSubview:_cardImageView];
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 2;
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _textLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
        [cardView addSubview:_textLabel];
        
        if (type == SKHelperTypeHasMascot) {
            UIImageView *mascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_introduce_talk"]];
            [cardView addSubview:mascotImageView];
            
            [mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@105);
                make.height.equalTo(@87);
                make.left.equalTo(cardView.mas_left);
                make.bottom.equalTo(cardView.mas_bottom);
            }];
            
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mascotImageView.mas_right).offset(8);
                make.top.equalTo(_cardImageView.mas_bottom).offset(3);
                make.right.equalTo(_cardImageView.mas_right).offset(-12);
            }];
        } else if(type == SKHelperTypeNoMascot) {
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_cardImageView.mas_left).offset(16);
                make.top.equalTo(_cardImageView.mas_bottom).offset(3);
                make.right.equalTo(_cardImageView.mas_right).offset(-16);
            }];
        }
        
        _nextstepButton = [UIButton new];
        [_nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_next"] forState:UIControlStateNormal];
        [_nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_next_highlight"] forState:UIControlStateHighlighted];
//        [_nextstepButton addTarget:self action:@selector(nextstepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextstepButton];
        
        [_nextstepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
            make.width.equalTo(@42);
            make.centerY.equalTo(cardView.mas_bottom);
            make.right.equalTo(cardView.mas_right).offset(-12);
        }];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image andText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _textLabel.attributedText = attributedString;
    [_textLabel sizeToFit];
}

#pragma mark - Actions

- (void)nextstepButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickNextStepButtonInView:type:index:)]) {
        [self.delegate didClickNextStepButtonInView:self type:_type index:_index];
    }
}

@end



@interface  SKHelperScrollView ()
//<SKHelperViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation SKHelperScrollView

- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperScrollViewType)type {
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:type];
    }
    return self;
}

- (void)createUIWithType:(SKHelperScrollViewType)type {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    if (type == SKHelperScrollViewTypeQuestion) {
        int pageNumber = 4;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNumber, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        for (int i= 0; i<pageNumber; i++) {
            SKHelperView *helpView = [[SKHelperView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperTypeHasMascot index:i];
            [_scrollView addSubview:helpView];
            if (i == pageNumber-1) {
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete"] forState:UIControlStateNormal];
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete_highlight"] forState:UIControlStateHighlighted];
                [helpView.nextstepButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                helpView.nextstepButton.tag = i;
                [helpView.nextstepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

#pragma mark - Actions

- (void)nextStepButtonClick:(UIControl *)sender {
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(sender.tag+1), 0) animated:YES];
}

- (void)completeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end