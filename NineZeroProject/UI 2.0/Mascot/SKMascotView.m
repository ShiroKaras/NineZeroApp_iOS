//
//  SKMascotView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKMascotView.h"
#import "HTUIHeader.h"

@interface SKMascotView ()
@property (nonatomic, strong) UIButton *fightButton;        //战斗按钮
@property (nonatomic, strong) UIButton *mascotdexButton;    //图鉴按钮
@property (nonatomic, strong) UIButton *skillButton;        //技能按钮
@property (nonatomic, strong) UIButton *infoButton;         //信息按钮

@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, assign) SKMascotType mascotType;
@end

@implementation SKMascotView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotType = mascotType;
        _mascotNameArray = @[@"lingzai", @"envy", @"gluttony", @"greed", @"pride", @"sloth", @"wrath", @"lust"];
        [self createUIWithType:mascotType];
    }
    return self;
}

- (void)createUIWithType:(SKMascotType)type {
    UIImageView *mBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mBackImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:mBackImageView];
}

@end



@interface SKMascotSkillView ()

@property (nonatomic, strong) UILabel *iconCountLabel;
@property (nonatomic, strong) UILabel *diamondCountLabel;

@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIView *diamondBackView;

@end

@implementation SKMascotSkillView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotNameArray = @[@"lingzai", @"envy", @"gluttony", @"greed", @"pride", @"sloth", @"wrath", @"lust"];
        [self createUIWithType:mascotType];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) {
        
    }];
}

- (void)createUIWithType:(SKMascotType)mascotType {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.9;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    if (mascotType == SKMascotTypeDefault) {
        [self defaultSkillView];
    } else {
        [self sinSkillViewWithType:mascotType];
    }
}

- (void)createResourceInfoUI {
    //右上角
    _iconBackView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-83.5, 14, 83.5, 30)];
    _iconBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self addSubview:_iconBackView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_iconBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _iconBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _iconBackView.layer.mask = maskLayer;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_gold"]];
    [iconImageView sizeToFit];
    [_iconBackView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconBackView.mas_centerY);
        make.right.equalTo(_iconBackView.mas_right).offset(-8);
    }];
    
    _iconCountLabel = [[UILabel alloc] init];
    _iconCountLabel.font = MOON_FONT_OF_SIZE(18);
    _iconCountLabel.textColor = [UIColor whiteColor];
    _iconCountLabel.text = [SKStorageManager sharedInstance].profileInfo.user_gold;
    [_iconCountLabel sizeToFit];
    [_iconBackView addSubview:_iconCountLabel];
    [_iconCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconBackView);
        make.right.equalTo(iconImageView.mas_left).offset(-6);
    }];
    
    _diamondBackView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-83.5, 14+30+6, 83.5, 30)];
    _diamondBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self addSubview:_diamondBackView];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_diamondBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _diamondBackView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _diamondBackView.layer.mask = maskLayer2;
    
    UIImageView *diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_diamonds"]];
    [diamondImageView sizeToFit];
    [_diamondBackView addSubview:diamondImageView];
    [diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_diamondBackView.mas_centerY);
        make.right.equalTo(_diamondBackView.mas_right).offset(-8);
    }];
    
    _diamondCountLabel = [[UILabel alloc] init];
    _diamondCountLabel.font = MOON_FONT_OF_SIZE(18);
    _diamondCountLabel.textColor = [UIColor whiteColor];
    _diamondCountLabel.text = [SKStorageManager sharedInstance].profileInfo.user_gemstone;
    [_diamondCountLabel sizeToFit];
    [_diamondBackView addSubview:_diamondCountLabel];
    [_diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_diamondBackView);
        make.right.equalTo(diamondImageView.mas_left).offset(-6);
    }];
}

- (void)defaultSkillView {
    //第一季
    [self createResourceInfoUI];
    
    UIButton *hintS1Button = [UIButton new];
    [hintS1Button addTarget:self action:@selector(hintS1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
    [hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:hintS1Button];
    [hintS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(70));
        make.height.equalTo(ROUND_HEIGHT(95));
        make.top.equalTo(ROUND_HEIGHT(143));
        make.left.equalTo(ROUND_WIDTH(59));
    }];
    
    UIButton *answerS1Button = [UIButton new];
    [answerS1Button addTarget:self action:@selector(answerS1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
    [answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:answerS1Button];
    [answerS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.centerY.equalTo(hintS1Button.mas_centerY);
        make.left.equalTo(hintS1Button.mas_right).offset(ROUND_WIDTH_FLOAT(62));
    }];
    
    UILabel *label_2icon_season1 = [UILabel new];
    label_2icon_season1.text = @"2";
    label_2icon_season1.textColor = [UIColor whiteColor];
    label_2icon_season1.font = MOON_FONT_OF_SIZE(18);
    [label_2icon_season1 sizeToFit];
    [self addSubview:label_2icon_season1];
    [label_2icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(hintS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon];
    [imageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_2icon_season1);
        make.right.equalTo(label_2icon_season1.mas_left).offset(-4);
    }];
    
    UILabel *label_200icon_season1 = [UILabel new];
    label_200icon_season1.text = @"200";
    label_200icon_season1.textColor = [UIColor whiteColor];
    label_200icon_season1.font = MOON_FONT_OF_SIZE(18);
    [label_200icon_season1 sizeToFit];
    [self addSubview:label_200icon_season1];
    [label_200icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(answerS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon_2];
    [imageView_icon_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_200icon_season1);
        make.right.equalTo(label_200icon_season1.mas_left).offset(-4);
    }];
    
    UIImageView *flagView_season1_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:flagView_season1_1];
    [flagView_season1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(44));
        make.height.equalTo(ROUND_WIDTH(19));
        make.left.equalTo(hintS1Button.mas_left).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(hintS1Button.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    UIImageView *flagView_season1_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:flagView_season1_2];
    [flagView_season1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(answerS1Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(answerS1Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    //第二季
    
    UIButton *hintS2Button = [UIButton new];
    [hintS2Button addTarget:self action:@selector(hintS2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
    [hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:hintS2Button];
    [hintS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.top.equalTo(imageView_icon.mas_bottom).offset(46);
        make.centerX.equalTo(hintS1Button.mas_centerX);
    }];
    
    UIButton *answerS2Button = [UIButton new];
    [answerS2Button addTarget:self action:@selector(answerS2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
    [answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:answerS2Button];
    [answerS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.centerX.equalTo(answerS1Button);
        make.centerY.equalTo(hintS2Button);
    }];
    
    UILabel *label_2icon_season2 = [UILabel new];
    label_2icon_season2.text = @"2";
    label_2icon_season2.textColor = [UIColor whiteColor];
    label_2icon_season2.font = MOON_FONT_OF_SIZE(18);
    [label_2icon_season2 sizeToFit];
    [self addSubview:label_2icon_season2];
    [label_2icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(hintS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond];
    [imageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_2icon_season2);
        make.right.equalTo(label_2icon_season2.mas_left).offset(-4);
    }];
    
    UILabel *label_200icon_season2 = [UILabel new];
    label_200icon_season2.text = @"200";
    label_200icon_season2.textColor = [UIColor whiteColor];
    label_200icon_season2.font = MOON_FONT_OF_SIZE(18);
    [label_200icon_season2 sizeToFit];
    [self addSubview:label_200icon_season2];
    [label_200icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(answerS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond_2];
    [imageView_diamond_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_200icon_season2);
        make.right.equalTo(label_200icon_season2.mas_left).offset(-4);
    }];
    
    UIImageView *flagView_season2_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:flagView_season2_1];
    [flagView_season2_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(hintS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(hintS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    UIImageView *flagView_season2_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:flagView_season2_2];
    [flagView_season2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(answerS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(answerS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
}

- (void)sinSkillViewWithType:(SKMascotType)mascotType {
    UIImageView *compoundImageView = [UIImageView new];
    [self addSubview:compoundImageView];
    [compoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(276));
        make.height.equalTo(ROUND_WIDTH(276));
        make.centerX.equalTo(self);
        make.top.equalTo(ROUND_HEIGHT(69));
    }];
    
    UIButton *exchangeButton = [UIButton new];
    [self addSubview:exchangeButton];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(136));
        make.height.equalTo(ROUND_WIDTH(136));
        make.center.equalTo(compoundImageView);
    }];
    
    UIImageView *summonImageView = [UIImageView new];
    [self addSubview:summonImageView];
    [summonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(106));
        make.height.equalTo(ROUND_HEIGHT(58));
        make.top.equalTo(compoundImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(28));
        make.centerX.equalTo(compoundImageView);
    }];
    
    UILabel *introduceLabel = [UILabel new];
    introduceLabel.text = @"零仔Sloth·S实在是太懒了，所以他总是会使用魔法变出一个答案道具，快速过关，因为他要抓紧去睡觉啦";
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    introduceLabel.numberOfLines = 0;
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(280));
        make.height.equalTo(ROUND_HEIGHT(75));
        make.top.equalTo(summonImageView.mas_bottom).offset(20);
        make.centerX.equalTo(summonImageView.mas_centerX);
    }];
    
    compoundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@compound", _mascotNameArray[mascotType]]];
    [exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed", _mascotNameArray[mascotType]]] forState:UIControlStateNormal];
    [exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed_highlight", _mascotNameArray[mascotType]]] forState:UIControlStateHighlighted];
    summonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@", _mascotNameArray[mascotType]]];
}

- (void)closeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

//第一季 线索
- (void)hintS1ButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"1" propType:@"1" callback:^(BOOL success, NSString *responseString) {
        [[self viewController] showTipsWithText:responseString];
    }];
}

//第一季 答案
- (void)answerS1ButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"1" propType:@"2" callback:^(BOOL success, NSString *responseString) {
        [[self viewController] showTipsWithText:responseString];
    }];
}

//第二季 线索
- (void)hintS2ButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"2" propType:@"1" callback:^(BOOL success, NSString *responseString) {
        [[self viewController] showTipsWithText:responseString];
    }];
}

//第二季 答案
- (void)answerS2ButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"2" propType:@"2" callback:^(BOOL success, NSString *responseString) {
        [[self viewController] showTipsWithText:responseString];
    }];
}

//获取view对应的控制器
- (UIViewController*)viewController {
    for (UIView* nextVC = [self superview]; nextVC; nextVC = nextVC.superview) {
        UIResponder* nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end




@interface SKMascotInfoView ()
@property (nonatomic, strong) NSDictionary *mascotTitleDict;
@property (nonatomic, strong) NSDictionary *mascotContentDict;
@property (nonatomic, strong) NSArray *mascotNameArray;
@end

@implementation SKMascotInfoView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotNameArray = @[@"lingzai", @"envy", @"gluttony", @"greed", @"pride", @"sloth", @"wrath", @"lust"];
        _mascotTitleDict = @{
                             @"lingzai"     :   @"零仔\nLingZai·O",
                             @"envy"        :   @"嫉妒\nEnvy·E",
                             @"gluttony"    :   @"饕餮\nGluttony·G",
                             @"greed"       :   @"贪婪\nGreed·R",
                             @"pride"       :   @"嫉妒\nPride·P",
                             @"sloth"       :   @"懒惰\nSloth·S",
                             @"wrath"       :   @"愤怒\nWrath·W",
                             @"lust"        :   @"色欲\nLust·L"
                             };
        _mascotContentDict = @{
                               @"lingzai"     :   @"零仔\nLingZai·O零仔\nLingZai·O",
                               @"envy"        :   @"嫉妒\nEnvy·E嫉妒\nEnvy·E",
                               @"gluttony"    :   @"饕餮\nGluttony·G饕餮\nGluttony·G",
                               @"greed"       :   @"贪婪\nGreed·R贪婪\nGreed·R",
                               @"pride"       :   @"嫉妒\nPride·P嫉妒\nPride·P",
                               @"sloth"       :   @"懒惰\nSloth·S懒惰\nSloth·S",
                               @"wrath"       :   @"愤怒\nWrath·W愤怒\nWrath·W",
                               @"lust"        :   @"色欲\nLust·L色欲\nLust·L"
                               };
        
        [self createUIWithType:mascotType];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    
}

- (void)createUIWithType:(SKMascotType)type {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.9;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = _mascotTitleDict[_mascotNameArray[type]];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = PINGFANG_FONT_OF_SIZE(24);
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@66);
        make.centerX.equalTo(self);
    }];
    
    
    //间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:PINGFANG_FONT_OF_SIZE(14),
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(@16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    textView.attributedText = [[NSAttributedString alloc] initWithString:_mascotContentDict[_mascotNameArray[type]] attributes:attributes];
}

- (void)closeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end


