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

@property (nonatomic, strong) YLImageView *mBlankImageView;

@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, assign) SKMascotType mascotType;
@end

@implementation SKMascotView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotType = mascotType;
        _mascotNameArray = @[@"lingzai", @"sloth", @"pride", @"wrath", @"gluttony", @"lust", @"envy"];
        [self createUIWithType:mascotType];
    }
    return self;
}

- (void)createUIWithType:(SKMascotType)type {
    self.backgroundColor = COMMON_BG_COLOR;

    _mBlankImageView= [[YLImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH-150, SCREEN_WIDTH, SCREEN_WIDTH)];
    _mBlankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_lingzaipage_%@__blank", _mascotNameArray[_mascotType]]];
    _mBlankImageView.userInteractionEnabled = YES;
    [self addSubview:_mBlankImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMascot:)];
    [_mBlankImageView addGestureRecognizer:tap];
}

- (void)show {
    _mBlankImageView.userInteractionEnabled = YES;
}

- (void)hide {
    _mBlankImageView.userInteractionEnabled = NO;
}

- (void)showDefault {
    _mBlankImageView.userInteractionEnabled = YES;
    _mBlankImageView.image = [YLGIFImage imageNamed:[NSString stringWithFormat:@"%@_1.gif", _mascotNameArray[_mascotType]]];
}

- (void)showRandom {
    _mBlankImageView.userInteractionEnabled = YES;
    _mBlankImageView.image = [YLGIFImage imageNamed:[NSString stringWithFormat:@"%@_%ld.gif", _mascotNameArray[_mascotType], random()%2+2]];
}

- (void)showDefaultImage {
    NSString *mascotName = [NSString stringWithFormat:@"%@_01_00000.jpg", _mascotNameArray[_mascotType]];
    _mBlankImageView.image = [YLGIFImage imageNamed:mascotName];
}

- (void)onClickMascot:(UITapGestureRecognizer*)sender {
    [self showRandom];
}

@end



@interface SKMascotSkillView ()
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL      isHad;

@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIView *diamondBackView;
@property (nonatomic, strong) UILabel *iconCountLabel;
@property (nonatomic, strong) UILabel *diamondCountLabel;
@property (nonatomic, strong) UIImageView *mascotPromptImageView;

@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, strong) NSDictionary *mascotNameDict;
@property (nonatomic, strong) NSArray *mascotSkillIntroArray;
@property (nonatomic, strong) NSArray *mascotIdArray;
@property (nonatomic, strong) NSArray<SKPet*> *familyMascotArray;
@property (nonatomic, strong) SKDefaultMascotDetail *defaultMascotDetail;

//默认零仔技能页
@property (nonatomic, strong) UIButton  *hintS1Button;
@property (nonatomic, strong) UIButton  *hintS2Button;
@property (nonatomic, strong) UIButton  *answerS1Button;
@property (nonatomic, strong) UIButton  *answerS2Button;
@property (nonatomic, strong) UILabel   *label_2icon_season1;
@property (nonatomic, strong) UILabel   *label_100icon_season1;
@property (nonatomic, strong) UILabel   *label_2icon_season2;
@property (nonatomic, strong) UILabel   *label_100icon_season2;

@property (nonatomic, strong) UIImageView *flagView_season1_1;
@property (nonatomic, strong) UIImageView *flagView_season1_2;
@property (nonatomic, strong) UIImageView *flagView_season2_1;
@property (nonatomic, strong) UIImageView *flagView_season2_2;

@property (nonatomic, strong) UIImageView *timeDownBackImageView1;
@property (nonatomic, strong) UIImageView *timeDownBackImageView2;
@property (nonatomic, strong) UIImageView *timeDownBackImageView3;
@property (nonatomic, strong) UIImageView *timeDownBackImageView4;

@property (nonatomic, strong) UILabel     *timeDownBackLabel1;
@property (nonatomic, strong) UILabel     *timeDownBackLabel2;
@property (nonatomic, strong) UILabel     *timeDownBackLabel3;
@property (nonatomic, strong) UILabel     *timeDownBackLabel4;

@property (nonatomic, strong) NSTimer   *timerS1Hint;
@property (nonatomic, strong) NSTimer   *timerS1Answer;
@property (nonatomic, strong) NSTimer   *timerS2Hint;
@property (nonatomic, strong) NSTimer   *timerS2Answer;

@property (nonatomic, assign) NSInteger timeDownS1Hint;
@property (nonatomic, assign) NSInteger timeDownS1Answer;
@property (nonatomic, assign) NSInteger timeDownS2Hint;
@property (nonatomic, assign) NSInteger timeDownS2Answer;

@property (nonatomic, assign) BOOL      hintS1_islock;
@property (nonatomic, assign) BOOL      answerS1_islock;
@property (nonatomic, assign) BOOL      hintS2_islock;
@property (nonatomic, assign) BOOL      answerS2_islock;

//其他零仔技能页
@property (nonatomic, strong) UIImageView *familyMascot_1_ImageView;
@property (nonatomic, strong) UIImageView *familyMascot_2_ImageView;
@property (nonatomic, strong) UIImageView *familyMascot_3_ImageView;
@property (nonatomic, strong) UIImageView *familyMascot_4_ImageView;

@property (nonatomic, strong) UIImageView *familyMascotSilhouette_1_ImageView;
@property (nonatomic, strong) UIImageView *familyMascotSilhouette_2_ImageView;
@property (nonatomic, strong) UIImageView *familyMascotSilhouette_3_ImageView;
@property (nonatomic, strong) UIImageView *familyMascotSilhouette_4_ImageView;

@property (nonatomic, strong) UILabel   *familyMascot_1_Label;
@property (nonatomic, strong) UILabel   *familyMascot_2_Label;
@property (nonatomic, strong) UILabel   *familyMascot_3_Label;
@property (nonatomic, strong) UILabel   *familyMascot_4_Label;
@property (nonatomic, strong) UIButton  *exchangeButton;
@end

@implementation SKMascotSkillView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType isHad:(BOOL)isHad{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHad = isHad;
        self.type = mascotType;
        _mascotNameArray = @[@"lingzai", @"sloth", @"pride", @"wrath", @"gluttony", @"lust", @"envy"];
        _mascotNameDict = @{
                             @"lingzai"     :   @"零仔·〇",
                             @"envy"        :   @"Envy·A",
                             @"gluttony"    :   @"Gluttony·T",
                             @"pride"       :   @"Pride·W",
                             @"sloth"       :   @"Sloth·S",
                             @"wrath"       :   @"Wrath·C",
                             @"lust"        :   @"Lust·B"
                             };
        _mascotSkillIntroArray = @[@"",
                                   @"对零仔Sloth·S来说，这个世界上没有什么难题是魔法不能解决的，当你看到他用魔法向你甩来两个答案道具的时候，他已经睡着了",
                                   @"想要像零仔Pride·W一样时刻闪耀在聚光灯下其实很简单，只要请求他给你的你的头像加一个blingbing的魔法边框就好啦（效果持续3天）",
                                   @"零仔Wrath·C用他的炸弹手表替换当前限时关卡倒计时，如果你在48小时内闯关成功，将会获得双倍金币和宝石奖励，否则你将会被炸上天",
                                   @"如果没有美食，这个世界还会好么？如果你碰巧捡到了零仔Gluttony·T的魔法礼券，你就可以和他一起遛进高级餐厅大饱口福",
                                   @"零仔Lust·B是荷尔蒙的寻觅师，如果你收到了他的魔法礼券，跟着礼券的提示你将会找到他并得到精神上的欢愉",
                                   @"零仔Envy·A使用魔法帮你增加40点经验值，当别人向你投来羡慕嫉妒恨的眼神时，请务必装作毫不在意的说一句\"Who TM Cares\""
                                   ];
        
        _mascotIdArray = @[@"1", @"2", @"3", @"4", @"7", @"6", @"5"];
        [self addObserver:self forKeyPath:@"hintS1_islock" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"answerS1_islock" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"hintS2_islock" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"answerS2_islock" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [self createUIWithType:mascotType];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [TalkingData trackPageBegin:@"lingskill"];
    
    //更新金币宝石数量
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) { }];
    [HTProgressHUD dismiss];
    if (self.type == SKMascotTypeDefault) {
        [[[SKServiceManager sharedInstance] mascotService] getDefaultMascotDetailCallback:^(BOOL success, SKDefaultMascotDetail *defaultMascot) {
            self.defaultMascotDetail = defaultMascot;
            _iconCountLabel.text = self.defaultMascotDetail.user_total_gold;
            _diamondCountLabel.text = self.defaultMascotDetail.user_gemstone;
            _label_2icon_season1.text = self.defaultMascotDetail.first_season.clue_used_gold;
            _label_100icon_season1.text = self.defaultMascotDetail.first_season.answer_used_gold;
            _label_2icon_season2.text = self.defaultMascotDetail.second_season.clue_used_gemstone;
            _label_100icon_season2.text = self.defaultMascotDetail.second_season.answer_used_gemstone;
            if (self.defaultMascotDetail.first_season.clue_cooling_time) {
                self.hintS1_islock = YES;
            }
            if (self.defaultMascotDetail.first_season.answer_cooling_time) {
                self.answerS1_islock = YES;
            }
            if (self.defaultMascotDetail.second_season.clue_cooling_time) {
                self.hintS2_islock = YES;
            }
            if (self.defaultMascotDetail.second_season.answer_cooling_time) {
                self.answerS2_islock = YES;
            }
        }];
    }
    else {
        //道具数量
        [[[SKServiceManager sharedInstance] mascotService] getMascotDetailWithMascotID:_mascotIdArray[_type] callback:^(BOOL success, NSArray<SKPet *> *mascotArray) {
            self.familyMascotArray = mascotArray;
            [self updateButtons];
        }];
    }
}

- (void)updateButtons {
    _familyMascot_1_ImageView.hidden = NO;
    _familyMascot_2_ImageView.hidden = NO;
    _familyMascot_3_ImageView.hidden = NO;
    _familyMascot_4_ImageView.hidden = NO;
    
    if(self.familyMascotArray[0].pet_num>0) {
        _familyMascot_1_ImageView.alpha = 1;
        _familyMascot_1_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@", self.familyMascotArray[0].pet_name]];
    } else {
        _familyMascot_1_ImageView.alpha = 0.4;
        _familyMascot_1_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@_gray", self.familyMascotArray[0].pet_name]];
    }
    if(self.familyMascotArray[1].pet_num>0) {
        _familyMascot_2_ImageView.alpha = 1;
        _familyMascot_2_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@", self.familyMascotArray[1].pet_name]];
    } else {
        _familyMascot_2_ImageView.alpha = 0.4;
        _familyMascot_2_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@_gray", self.familyMascotArray[1].pet_name]];
    }
    if(self.familyMascotArray[2].pet_num>0) {
        _familyMascot_3_ImageView.alpha = 1;
        _familyMascot_3_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@", self.familyMascotArray[2].pet_name]];
    } else {
        _familyMascot_3_ImageView.alpha = 0.4;
        _familyMascot_3_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@_gray", self.familyMascotArray[2].pet_name]];
    }
    if(self.familyMascotArray[3].pet_num>0) {
        _familyMascot_4_ImageView.alpha = 1;
        _familyMascot_4_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@", self.familyMascotArray[3].pet_name]];
    } else {
        _familyMascot_4_ImageView.alpha = 0.4;
        _familyMascot_4_ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%@_gray", self.familyMascotArray[3].pet_name]];
    }
    
    _familyMascot_1_Label.text = [NSString stringWithFormat:@"%ld",(long)self.familyMascotArray[0].pet_num];
    _familyMascot_2_Label.text = [NSString stringWithFormat:@"%ld",(long)self.familyMascotArray[1].pet_num];
    _familyMascot_3_Label.text = [NSString stringWithFormat:@"%ld",(long)self.familyMascotArray[2].pet_num];
    _familyMascot_4_Label.text = [NSString stringWithFormat:@"%ld",(long)self.familyMascotArray[3].pet_num];
    if (self.familyMascotArray[0].pet_num>0&&
        self.familyMascotArray[1].pet_num>0&&
        self.familyMascotArray[2].pet_num>0&&
        self.familyMascotArray[3].pet_num &&
        self.isHad) {
        [_exchangeButton addTarget:self action:@selector(exchangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed", _mascotNameArray[_type]]] forState:UIControlStateNormal];
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed_highlight", _mascotNameArray[_type]]] forState:UIControlStateHighlighted];
    } else {
        _exchangeButton.adjustsImageWhenHighlighted = NO;
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound", _mascotNameArray[_type]]] forState:UIControlStateNormal];
    }
}

- (void)createUIWithType:(SKMascotType)mascotType {
    UIView *alphaView = [UIView new];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];

    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _hintS1Button = [UIButton new];
    [_hintS1Button addTarget:self action:@selector(hintS1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
    [_hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:_hintS1Button];
    [_hintS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(70));
        make.height.equalTo(ROUND_HEIGHT(95));
        make.top.equalTo(ROUND_HEIGHT(143));
        make.left.equalTo(ROUND_WIDTH(59));
    }];
    
    _answerS1Button = [UIButton new];
    [_answerS1Button addTarget:self action:@selector(answerS1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
    [_answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:_answerS1Button];
    [_answerS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_hintS1Button);
        make.centerY.equalTo(_hintS1Button.mas_centerY);
        make.left.equalTo(_hintS1Button.mas_right).offset(ROUND_WIDTH_FLOAT(62));
    }];
    
    _label_2icon_season1 = [UILabel new];
    _label_2icon_season1.text = @"2";
    _label_2icon_season1.textColor = [UIColor whiteColor];
    _label_2icon_season1.font = MOON_FONT_OF_SIZE(18);
    [_label_2icon_season1 sizeToFit];
    [self addSubview:_label_2icon_season1];
    [_label_2icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hintS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(_hintS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon];
    [imageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_2icon_season1);
        make.right.equalTo(_label_2icon_season1.mas_left).offset(-4);
    }];
    
    _label_100icon_season1 = [UILabel new];
    _label_100icon_season1.text = @"100";
    _label_100icon_season1.textColor = [UIColor whiteColor];
    _label_100icon_season1.font = MOON_FONT_OF_SIZE(18);
    [_label_100icon_season1 sizeToFit];
    [self addSubview:_label_100icon_season1];
    [_label_100icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_answerS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(_answerS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon_2];
    [imageView_icon_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_100icon_season1);
        make.right.equalTo(_label_100icon_season1.mas_left).offset(-4);
    }];
    
    _flagView_season1_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:_flagView_season1_1];
    [_flagView_season1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(44));
        make.height.equalTo(ROUND_WIDTH(19));
        make.left.equalTo(_hintS1Button.mas_left).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_hintS1Button.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _flagView_season1_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:_flagView_season1_2];
    [_flagView_season1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_flagView_season1_1);
        make.left.equalTo(_answerS1Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_answerS1Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_lingzaiskillpage_timer"]];
    _timeDownBackImageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_timeDownBackImageView1];
    [_timeDownBackImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(56), ROUND_HEIGHT_FLOAT(25)));
        make.left.equalTo(_hintS1Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_hintS1Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackLabel1 = [UILabel new];
    _timeDownBackLabel1.text = @"09:59";
    _timeDownBackLabel1.textColor = [UIColor whiteColor];
    _timeDownBackLabel1.font = MOON_FONT_OF_SIZE(12);
    [_timeDownBackImageView1 addSubview:_timeDownBackLabel1];
    [_timeDownBackLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeDownBackImageView1);
        make.bottom.equalTo(_timeDownBackImageView1).offset(-2);
    }];
    
    _timeDownBackImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_lingzaiskillpage_timer"]];
    _timeDownBackImageView2.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_timeDownBackImageView2];
    [_timeDownBackImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeDownBackImageView1);
        make.left.equalTo(_answerS1Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_answerS1Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackLabel2 = [UILabel new];
    _timeDownBackLabel2.text = @"59:59";
    _timeDownBackLabel2.textColor = [UIColor whiteColor];
    _timeDownBackLabel2.font = MOON_FONT_OF_SIZE(12);
    [_timeDownBackImageView2 addSubview:_timeDownBackLabel2];
    [_timeDownBackLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeDownBackImageView2);
        make.bottom.equalTo(_timeDownBackImageView2).offset(-2);
    }];
    
    //第二季
    
    _hintS2Button = [UIButton new];
    [_hintS2Button addTarget:self action:@selector(hintS2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateNormal];
    [_hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateHighlighted];
    [self addSubview:_hintS2Button];
    [_hintS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_hintS1Button);
        make.top.equalTo(imageView_icon.mas_bottom).offset(46);
        make.centerX.equalTo(_hintS1Button.mas_centerX);
    }];
    
    _answerS2Button = [UIButton new];
    [_answerS2Button addTarget:self action:@selector(answerS2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateNormal];
    [_answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateHighlighted];
    [self addSubview:_answerS2Button];
    [_answerS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_hintS1Button);
        make.centerX.equalTo(_answerS1Button);
        make.centerY.equalTo(_hintS2Button);
    }];
    
    _label_2icon_season2 = [UILabel new];
    _label_2icon_season2.text = @"1";
    _label_2icon_season2.textColor = [UIColor whiteColor];
    _label_2icon_season2.font = MOON_FONT_OF_SIZE(18);
    [_label_2icon_season2 sizeToFit];
    [self addSubview:_label_2icon_season2];
    [_label_2icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hintS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(_hintS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond];
    [imageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_2icon_season2);
        make.right.equalTo(_label_2icon_season2.mas_left).offset(-4);
    }];
    
    _label_100icon_season2 = [UILabel new];
    _label_100icon_season2.text = @"5";
    _label_100icon_season2.textColor = [UIColor whiteColor];
    _label_100icon_season2.font = MOON_FONT_OF_SIZE(18);
    [_label_100icon_season2 sizeToFit];
    [self addSubview:_label_100icon_season2];
    [_label_100icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_answerS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(_answerS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond_2];
    [imageView_diamond_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label_100icon_season2);
        make.right.equalTo(_label_100icon_season2.mas_left).offset(-4);
    }];
    
    _flagView_season2_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:_flagView_season2_1];
    [_flagView_season2_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_flagView_season1_1);
        make.left.equalTo(_hintS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_hintS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _flagView_season2_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:_flagView_season2_2];
    [_flagView_season2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_flagView_season1_1);
        make.left.equalTo(_answerS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_answerS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_lingzaiskillpage_timer"]];
    _timeDownBackImageView3.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_timeDownBackImageView3];
    [_timeDownBackImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeDownBackImageView1);
        make.left.equalTo(_hintS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_hintS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackLabel3 = [UILabel new];
    _timeDownBackLabel3.text = @"09:59";
    _timeDownBackLabel3.textColor = [UIColor whiteColor];
    _timeDownBackLabel3.font = MOON_FONT_OF_SIZE(12);
    [_timeDownBackImageView3 addSubview:_timeDownBackLabel3];
    [_timeDownBackLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeDownBackImageView3);
        make.bottom.equalTo(_timeDownBackImageView3).offset(-2);
    }];
    
    _timeDownBackImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_lingzaiskillpage_timer"]];
    _timeDownBackImageView4.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_timeDownBackImageView4];
    [_timeDownBackImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeDownBackImageView1);
        make.left.equalTo(_answerS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(_answerS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeDownBackLabel4 = [UILabel new];
    _timeDownBackLabel4.text = @"59:59";
    _timeDownBackLabel4.textColor = [UIColor whiteColor];
    _timeDownBackLabel4.font = MOON_FONT_OF_SIZE(12);
    [_timeDownBackImageView4 addSubview:_timeDownBackLabel4];
    [_timeDownBackLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeDownBackImageView4);
        make.bottom.equalTo(_timeDownBackImageView4).offset(-2);
    }];
    
    self.hintS1_islock = NO;
    self.answerS1_islock = NO;
    self.hintS2_islock = NO;
    self.answerS2_islock = NO;
}

//家族零仔技能
- (void)sinSkillViewWithType:(SKMascotType)mascotType {
    //召唤阵
    UIImageView *compoundImageView = [UIImageView new];
    [self addSubview:compoundImageView];
    [compoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(276));
        make.height.equalTo(ROUND_WIDTH(276));
        make.centerX.equalTo(self);
        make.top.equalTo(ROUND_HEIGHT(69));
    }];
    
    //4个道具剪影
    _familyMascotSilhouette_1_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop1_silhouette", _mascotNameArray[mascotType]]]];
    _familyMascotSilhouette_1_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [compoundImageView addSubview:_familyMascotSilhouette_1_ImageView];
    [_familyMascotSilhouette_1_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerX.equalTo(compoundImageView);
        make.top.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(-7));
    }];
    
    _familyMascotSilhouette_2_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop2_silhouette", _mascotNameArray[mascotType]]]];
    _familyMascotSilhouette_2_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [compoundImageView addSubview:_familyMascotSilhouette_2_ImageView];
    [_familyMascotSilhouette_2_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerY.equalTo(compoundImageView);
        make.left.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(-7));
    }];
    
    _familyMascotSilhouette_3_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop3_silhouette", _mascotNameArray[mascotType]]]];
    _familyMascotSilhouette_3_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [compoundImageView addSubview:_familyMascotSilhouette_3_ImageView];
    [_familyMascotSilhouette_3_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerX.equalTo(compoundImageView);
        make.bottom.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(7));
    }];
    
    _familyMascotSilhouette_4_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop4_silhouette", _mascotNameArray[mascotType]]]];
    _familyMascotSilhouette_4_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [compoundImageView addSubview:_familyMascotSilhouette_4_ImageView];
    [_familyMascotSilhouette_4_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerY.equalTo(compoundImageView);
        make.right.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(7));
    }];
    
    //4个道具
    _familyMascot_1_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop1", _mascotNameArray[mascotType]]]];
    _familyMascot_1_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    _familyMascot_1_ImageView.hidden = YES;
    [compoundImageView addSubview:_familyMascot_1_ImageView];
    [_familyMascot_1_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerX.equalTo(compoundImageView);
        make.top.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(-7));
    }];
    
    _familyMascot_2_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop2", _mascotNameArray[mascotType]]]];
    _familyMascot_2_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    _familyMascot_2_ImageView.hidden = YES;
    [compoundImageView addSubview:_familyMascot_2_ImageView];
    [_familyMascot_2_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerY.equalTo(compoundImageView);
        make.left.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(-7));
    }];
    
    _familyMascot_3_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop3", _mascotNameArray[mascotType]]]];
    _familyMascot_3_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    _familyMascot_3_ImageView.hidden = YES;
    [compoundImageView addSubview:_familyMascot_3_ImageView];
    [_familyMascot_3_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerX.equalTo(compoundImageView);
        make.bottom.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(7));
    }];
    
    _familyMascot_4_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_%@_prop4", _mascotNameArray[mascotType]]]];
    _familyMascot_4_ImageView.contentMode = UIViewContentModeScaleAspectFit;
    _familyMascot_4_ImageView.hidden = YES;
    [compoundImageView addSubview:_familyMascot_4_ImageView];
    [_familyMascot_4_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(85), ROUND_WIDTH_FLOAT(85)));
        make.centerY.equalTo(compoundImageView);
        make.right.equalTo(compoundImageView).offset(ROUND_WIDTH_FLOAT(7));
    }];
    
    //兑换按钮
    _exchangeButton = [UIButton new];
    [self addSubview:_exchangeButton];
    [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 12;// 字体的行间距
    
    NSDictionary *attributes;
    if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
        attributes = @{
                       NSFontAttributeName:PINGFANG_FONT_OF_SIZE(12),
                       NSParagraphStyleAttributeName:paragraphStyle,
                       NSForegroundColorAttributeName:[UIColor whiteColor]
                       };
    } else {
        attributes = @{
                       NSFontAttributeName:PINGFANG_FONT_OF_SIZE(14),
                       NSParagraphStyleAttributeName:paragraphStyle,
                       NSForegroundColorAttributeName:[UIColor whiteColor]
                       };
    }
    UILabel *introduceLabel = [UILabel new];
    if (self.isHad) {
        introduceLabel.attributedText = [[NSAttributedString alloc] initWithString:_mascotSkillIntroArray[mascotType] attributes:attributes];
    } else {
        introduceLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"收集到%@后激活魔法阵", self.mascotNameDict[_mascotNameArray[_type]]] attributes:attributes];
    }
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.numberOfLines = 4;
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(280));
        make.height.equalTo(ROUND_HEIGHT(100));
        make.top.equalTo(summonImageView.mas_bottom).offset(20);
        make.centerX.equalTo(summonImageView.mas_centerX);
    }];
    
    //数字背景圆
    UIView *c1 = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(151), ROUND_HEIGHT_FLOAT(48), ROUND_WIDTH_FLOAT(21), ROUND_WIDTH_FLOAT(21))];
    c1.backgroundColor = [UIColor whiteColor];
    c1.layer.cornerRadius = ROUND_WIDTH_FLOAT(21)/2;
    [compoundImageView addSubview:c1];
    
    UIView *c2 = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(48.5), ROUND_HEIGHT_FLOAT(150.5), ROUND_WIDTH_FLOAT(21), ROUND_WIDTH_FLOAT(21))];
    c2.backgroundColor = [UIColor whiteColor];
    c2.layer.cornerRadius = ROUND_WIDTH_FLOAT(21)/2;
    [compoundImageView addSubview:c2];
    
    UIView *c3 = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(151), ROUND_HEIGHT_FLOAT(253), ROUND_WIDTH_FLOAT(21), ROUND_WIDTH_FLOAT(21))];
    c3.backgroundColor = [UIColor whiteColor];
    c3.layer.cornerRadius = ROUND_WIDTH_FLOAT(21)/2;
    [compoundImageView addSubview:c3];
    
    UIView *c4 = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(253), ROUND_HEIGHT_FLOAT(150.5), ROUND_WIDTH_FLOAT(21), ROUND_WIDTH_FLOAT(21))];
    c4.backgroundColor = [UIColor whiteColor];
    c4.layer.cornerRadius = ROUND_WIDTH_FLOAT(21)/2;
    [compoundImageView addSubview:c4];
    
    //数字
    NSArray *labelColorArray = @[COMMON_RED_COLOR,
                                 [UIColor colorWithHex:0x24DDB2],
                                 [UIColor colorWithHex:0xD40E88],
                                 [UIColor colorWithHex:0xA96128],
                                 [UIColor colorWithHex:0x6774C6],
                                 [UIColor colorWithHex:0xFFBD00],
                                 [UIColor colorWithHex:0xFDD900],
                                 ];
    
    _familyMascot_1_Label = [UILabel new];
    _familyMascot_1_Label.text = @"00";
    _familyMascot_1_Label.textColor = labelColorArray[_type];
    _familyMascot_1_Label.font = MOON_FONT_OF_SIZE(14);
    [c1 addSubview:_familyMascot_1_Label];
    [_familyMascot_1_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(c1);
    }];
    
    _familyMascot_2_Label = [UILabel new];
    _familyMascot_2_Label.text = @"00";
    _familyMascot_2_Label.textColor = labelColorArray[_type];
    _familyMascot_2_Label.font = MOON_FONT_OF_SIZE(14);
    [c2 addSubview:_familyMascot_2_Label];
    [_familyMascot_2_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(c2);
    }];
    
    _familyMascot_3_Label = [UILabel new];
    _familyMascot_3_Label.text = @"00";
    _familyMascot_3_Label.textColor = labelColorArray[_type];
    _familyMascot_3_Label.font = MOON_FONT_OF_SIZE(14);
    [c3 addSubview:_familyMascot_3_Label];
    [_familyMascot_3_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(c3);
    }];
    
    _familyMascot_4_Label = [UILabel new];
    _familyMascot_4_Label.text = @"00";
    _familyMascot_4_Label.textColor = labelColorArray[_type];
    _familyMascot_4_Label.font = MOON_FONT_OF_SIZE(14);
    [c4 addSubview:_familyMascot_4_Label];
    [_familyMascot_4_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(c4);
    }];
    
    compoundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@compound", _mascotNameArray[mascotType]]];
    summonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@", _mascotNameArray[mascotType]]];
    [_exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound", _mascotNameArray[mascotType]]] forState:UIControlStateNormal];
}

- (void)showPromptWithText:(NSString*)text {
    [[self viewWithTag:300] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 300;
    promptView.size = promptImageView.size;
    promptView.center = self.center;
    promptView.alpha = 0;
    [self addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.frame = CGRectMake(8.5, 11, promptView.width-17, 57);
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

- (void)showSinMascotPromptWithText:(NSString*)text {
    [[self viewWithTag:300] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_skillpage_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 300;
    promptView.size = promptImageView.size;
    promptView.center = self.center;
    promptView.alpha = 0;
    [self addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.width = promptView.width-17;
    promptLabel.left = 8.5;
    promptLabel.bottom = promptView.height - 12;
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

- (void)closeButtonClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(didClickCloseButtonMascotSkillView:)]) { // 如果协议响应了didClickCloseButtonMascotSkillView:方法
        [_delegate didClickCloseButtonMascotSkillView:self]; // 通知执行协议方法
    }
    [_timerS1Hint invalidate];
    _timerS1Hint = nil;
    [_timerS1Answer invalidate];
    _timerS1Answer = nil;
    [_timerS2Hint invalidate];
    _timerS2Hint = nil;
    [_timerS2Answer invalidate];
    _timerS2Answer = nil;
    [self removeObserver:self forKeyPath:@"hintS1_islock"];
    [self removeObserver:self forKeyPath:@"hintS2_islock"];
    [self removeObserver:self forKeyPath:@"answerS1_islock"];
    [self removeObserver:self forKeyPath:@"answerS2_islock"];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [TalkingData trackPageEnd:@"lingskill"];
    }];
}

//第一季 线索
- (void)hintS1ButtonClick:(UIButton *)sender {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"1" propType:@"1" callback:^(BOOL success, NSString *responseString, NSInteger coolTime) {
        [HTProgressHUD dismiss];
        [self showPromptWithText:responseString];
        if (success) {
            NSLog(@"%ld", coolTime);
//            self.defaultMascotDetail.first_season.clue_cooling_time = coolTime;
//            _iconCountLabel.text = [NSString stringWithFormat:@"%ld", [_iconCountLabel.text integerValue]-[self.defaultMascotDetail.first_season.clue_used_gold integerValue]];
//            self.hintS1_islock = YES;
            _timeDownBackLabel1.text = [self timeToString:coolTime];
            [self loadData];
        }
    }];
}

//第一季 答案
- (void)answerS1ButtonClick:(UIButton *)sender {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"1" propType:@"2" callback:^(BOOL success, NSString *responseString, NSInteger coolTime) {
        [HTProgressHUD dismiss];
        [self showPromptWithText:responseString];
        if (success) {
//            self.defaultMascotDetail.first_season.answer_cooling_time = coolTime;
//            _iconCountLabel.text = [NSString stringWithFormat:@"%ld", [_iconCountLabel.text integerValue]-[self.defaultMascotDetail.first_season.answer_used_gold integerValue]];
//            self.answerS1_islock = YES;
            _timeDownBackLabel2.text = [self timeToString:coolTime];
            [self loadData];
        }
    }];
}

//第二季 线索
- (void)hintS2ButtonClick:(UIButton *)sender {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"2" propType:@"1" callback:^(BOOL success, NSString *responseString, NSInteger coolTime) {
        [HTProgressHUD dismiss];
        [self showPromptWithText:responseString];
        if (success) {
//            self.defaultMascotDetail.second_season.clue_cooling_time = coolTime;
//            _diamondCountLabel.text = [NSString stringWithFormat:@"%ld", [_diamondCountLabel.text integerValue]-[self.defaultMascotDetail.second_season.clue_used_gemstone integerValue]];
//            self.hintS2_islock = YES;
            _timeDownBackLabel3.text = [self timeToString:coolTime];
            [self loadData];
        }
    }];
}

//第二季 答案
- (void)answerS2ButtonClick:(UIButton *)sender {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] propService] purchasePropWithPurchaseType:@"2" propType:@"2" callback:^(BOOL success, NSString *responseString, NSInteger coolTime) {
        [HTProgressHUD dismiss];
        [self showPromptWithText:responseString];
        if (success) {
//            self.defaultMascotDetail.second_season.answer_cooling_time = coolTime;
//            _diamondCountLabel.text = [NSString stringWithFormat:@"%ld", [_diamondCountLabel.text integerValue]-[self.defaultMascotDetail.second_season.answer_used_gemstone integerValue]];
//            self.answerS2_islock = YES;
            _timeDownBackLabel4.text = [self timeToString:coolTime];
            [self loadData];
        }
    }];
}

- (NSString *)timeToString:(NSInteger)time {
    time_t minute = time/ 60;
    time_t second = time - minute * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}

//倒计时
- (void)timeS1Hint {
    self.defaultMascotDetail.first_season.clue_cooling_time--;
    time_t delta = self.defaultMascotDetail.first_season.clue_cooling_time;
    time_t minute = delta / 60;
    time_t second = delta - minute * 60;
    if (delta > 0) {
        _timeDownBackLabel1.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    } else {
        // 过去时间
        self.hintS1_islock = NO;
    }
}

- (void)timeS1Answer {
    self.defaultMascotDetail.first_season.answer_cooling_time--;
    time_t delta = self.defaultMascotDetail.first_season.answer_cooling_time;
    time_t minute = delta / 60;
    time_t second = delta - minute * 60;
    if (delta > 0) {
        _timeDownBackLabel2.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    } else {
        // 过去时间
        self.answerS2_islock = NO;
    }
}

- (void)timeS2Hint {
    self.defaultMascotDetail.second_season.clue_cooling_time--;
    time_t delta = self.defaultMascotDetail.second_season.clue_cooling_time;
    time_t minute = delta / 60;
    time_t second = delta - minute * 60;
    if (delta > 0) {
        _timeDownBackLabel3.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    } else {
        // 过去时间
        self.hintS2_islock = NO;
    }
}

- (void)timeS2Answer {
    self.defaultMascotDetail.second_season.answer_cooling_time--;
    time_t delta = self.defaultMascotDetail.second_season.answer_cooling_time;
    time_t minute = delta / 60;
    time_t second = delta  - minute * 60;
    if (delta > 0) {
        _timeDownBackLabel4.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    } else {
        // 过去时间
        self.answerS2_islock = NO;
    }
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

//使用技能
- (void)exchangeButtonClick:(UIButton*)sender {
    [[[SKServiceManager sharedInstance] mascotService] useMascotSkillWithMascotID:_mascotIdArray[_type] callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            [self showSinMascotPromptWithText:@"魔法已生效"];
            self.familyMascotArray[0].pet_num--;
            self.familyMascotArray[1].pet_num--;
            self.familyMascotArray[2].pet_num--;
            self.familyMascotArray[3].pet_num--;
            
            [self updateButtons];
        } else if (response.result == -7009){
            [self showSinMascotPromptWithText:@"已有生效的魔法"];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hintS1_islock"]) {
        if (self.hintS1_islock) {
            [_hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_cd"] forState:UIControlStateNormal];
            _hintS1Button.userInteractionEnabled = NO;
            _flagView_season1_1.hidden = YES;
            _timeDownBackImageView1.hidden = NO;
            [_timerS1Hint invalidate];
            _timerS1Hint = nil;
            _timerS1Hint = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeS1Hint) userInfo:nil repeats:YES];
        } else {
            [_hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
            _hintS1Button.userInteractionEnabled = YES;
            _flagView_season1_1.hidden = NO;
            _timeDownBackImageView1.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"answerS1_islock"]) {
        if (self.answerS1_islock) {
            [_answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_cd"] forState:UIControlStateNormal];
            _answerS1Button.userInteractionEnabled = NO;
            _flagView_season1_2.hidden = YES;
            _timeDownBackImageView2.hidden = NO;
            [_timerS1Answer invalidate];
            _timerS1Answer = nil;
            _timerS1Answer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeS1Answer) userInfo:nil repeats:YES];
        } else {
            [_answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
            _answerS1Button.userInteractionEnabled = YES;
            _flagView_season1_2.hidden = NO;
            _timeDownBackImageView2.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"hintS2_islock"]) {
        if (self.hintS2_islock) {
            [_hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_cd2"] forState:UIControlStateNormal];
            _hintS2Button.userInteractionEnabled = NO;
            _flagView_season2_1.hidden = YES;
            _timeDownBackImageView3.hidden = NO;
            [_timerS2Hint invalidate];
            _timerS2Hint = nil;
            _timerS2Hint = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeS2Hint) userInfo:nil repeats:YES];
        } else {
            [_hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateNormal];
            _hintS2Button.userInteractionEnabled = YES;
            _flagView_season2_1.hidden = NO;
            _timeDownBackImageView3.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"answerS2_islock"]) {
        if (self.answerS2_islock) {
            [_answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_cd2"] forState:UIControlStateNormal];
            _answerS2Button.userInteractionEnabled = NO;
            _flagView_season2_2.hidden = YES;
            _timeDownBackImageView4.hidden = NO;
            [_timerS2Answer invalidate];
            _timerS2Answer = nil;
            _timerS2Answer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeS2Answer) userInfo:nil repeats:YES];
        } else {
            [_answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateNormal];
            _answerS2Button.userInteractionEnabled = YES;
            _flagView_season2_2.hidden = NO;
            _timeDownBackImageView4.hidden = YES;
        }
    }
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
        _mascotNameArray = @[@"lingzai", @"sloth", @"pride", @"wrath", @"gluttony", @"lust", @"envy"];
        _mascotTitleDict = @{
                             @"lingzai"     :   @"img_info_lingzai",
                             @"envy"        :   @"img_info_envy",
                             @"gluttony"    :   @"img_info_gluttony",
                             @"pride"       :   @"img_info_pride",
                             @"sloth"       :   @"img_info_sloth",
                             @"wrath"       :   @"img_info_wrath",
                             @"lust"        :   @"img_info_lust"
                             };
        _mascotContentDict = @{
                               @"lingzai"     :   @"从世界尽头归来\n也从新世界开始\n〇来自传说中的529D星球\n〇纯洁如一张白纸\n却孤独如一片深海\n虽然这个世界\n与自己残存的记忆中的星球\n有太多类似的地方\n但是\n它还是需要找到\n529D星球的一些线索\n它希望知道\n自己的来处\n希望了解\n关于529D星球的一切真相",
                               @"sloth"        :   @"一个嗜睡狂魔\n只要有休息的机会\n它绝对会瞬间倒下睡觉\n但是它有一个克星\n没错\n就是那只小鸟\n虽然Sloth·S不可避免的进入梦乡\n但是小鸟却每次都在提醒Sloth·S\n向什么方向出发\n最让Sloth·S接受不了的是\n那只小鸟\n会逮住所有的机会叫醒它\n然而似乎\n并没有什么卵用",
                               @"pride"    :   @"从出生开始\n就没见过自己的脚趾头\n脑袋一直高昂着\n别想让它主动联系你\n它可有偶像包袱\n别跟它说话\n它好像也没搭理过谁\n似乎只有一身的雍容华贵\n才可以表达它的品味\n为了保证随时聚焦在闪光灯下\nPride·W要保持最佳状态\n不可以让任何人\n看到它不好的一面",
                               @"wrath"       :   @"炸弹做手表也是没谁了\n而它只是在倒计时自己\n还有多久会气炸\nWrath·C气场强大\n光是靠近你\n不用背景音乐\n你就能感受到周围阵阵杀气\n它是一个偏执狂\n可以把一件事情坚持做到底\n认定的事情\n谁也不可以改变\n别惹它\n不是开玩笑的",
                               @"gluttony"       :   @"如果没有美食\n这个世界还会好么？\nGluttony·T最喜欢说的一句话是\n“我还能再吃一口”\n再吃一口\n不是因为它想吃掉所有食物\n而是为了尝遍天下所有美食\n为了食物\n可以不惜一切代价\n为了争夺到手的肥肉\n不惜把自己的手吃掉",
                               @"lust"       :   @"一切撩人神技\n都有特别的技巧\n从约炮短信的聊天气泡出生\n它喜欢广交朋友\n和任何人\n都很容易产生情趣话题\n它天生拥有强大的读心术\n与你对视几秒\n就能知道你心中\n隐藏什么奇怪想法\n它是荷尔蒙的寻觅师\n知道精神深处何处安放",
                               @"envy"        :   @"找准角度\n10分钟完成自拍！\n3个小时修图\n要瘦！要白！要大气！要国际范！\n刚秀完自拍\n当然要po出\n本宝宝现在去的上流餐厅\n看到了明星要合影\n发朋友圈说\n“老朋友相见，我就喜欢这么平淡的生活”\n你觉得Envy·A是玻璃心？\n你就是在嫉妒它\n它要把你拉黑！"
                               };
        
        [self createUIWithType:mascotType];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [TalkingData trackPageBegin:@"lingdescription"];
}

- (void)createUIWithType:(SKMascotType)type {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = COMMON_BG_COLOR;
    dimmingView.alpha = 0.9;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:scrollView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_mascotTitleDict[_mascotNameArray[type]]]];
    [scrollView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(150));
        make.height.equalTo(ROUND_WIDTH(56.5));
        make.centerX.equalTo(scrollView);
        make.top.equalTo(@64);
    }];
    
    //间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 13;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:PINGFANG_FONT_OF_SIZE(14),
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    
    UILabel *textView = [UILabel new];
    textView.attributedText = [[NSAttributedString alloc] initWithString:_mascotContentDict[_mascotNameArray[type]] attributes:attributes];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.backgroundColor = [UIColor clearColor];
    textView.numberOfLines = 0;
    [textView sizeToFit];
//    textView.editable = NO;
    [scrollView addSubview:textView];
//    [textView setContentOffset:CGPointZero animated:NO];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImageView.mas_bottom).offset(27);
        make.centerX.equalTo(scrollView);
    }];
    
    scrollView.contentSize = CGSizeMake(self.width, 64+ROUND_HEIGHT_FLOAT(56.5)+27+textView.height+16);
    if (64+ROUND_HEIGHT_FLOAT(56.5)+27+textView.height+16>SCREEN_HEIGHT) {
        UIImageView *dimmingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_success_shading_down"]];
        dimmingImageView.width = SCREEN_WIDTH;
        dimmingImageView.bottom = self.bottom;
        [self addSubview:dimmingImageView];
    }
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
}

- (void)closeButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [TalkingData trackPageEnd:@"lingdescription"];
    }];
}

@end


