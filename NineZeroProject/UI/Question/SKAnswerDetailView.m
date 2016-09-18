//
//  SKAnswerDetailView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/7/4.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKAnswerDetailView.h"
#import "HTUIHeader.h"
#import "Reachability.h"
#import "JPUSHService.h"
#import "HTAlertView.h"
#import "HTBlankView.h"
#import "HTServiceManager.h"
#import "HTArticleController.h"
#import "UIImage+ImageEffects.h"

@interface SKAnswerDetailView ()<UIScrollViewDelegate>

@property (nonatomic, assign) uint64_t quesitonID;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIButton *cancelButton;           //关闭按钮
@property (nonatomic, strong) UIImageView *headerImageView;     //头图
@property (nonatomic, strong) UILabel *contentView;          //文字内容

@property (nonatomic, strong) UIView *articleBackView;
@property (nonatomic, strong) UIButton *arrowButton;

@property (nonatomic, strong) UIView *HUDView;
@property (nonatomic, strong) UIImageView *HUDImageView;

@property (nonatomic, strong) NSArray *articlesArray;
@end

@implementation SKAnswerDetailView{
    NSInteger articleCount;
    float lastOffsetY;
}

- (instancetype)initWithFrame:(CGRect)frame questionID:(uint64_t)questionID{
    if (self = [super init]) {
        _quesitonID = questionID;
        self.frame = frame;
        [self createUI];
        [self loadDataWithQuestionID:_quesitonID];
    }
    return self;
}

- (void)loadDataWithQuestionID:(uint64_t)questionID {
    [[[HTServiceManager sharedInstance] questionService] getAnswerDetailWithQuestionID:questionID callback:^(BOOL success, HTAnswerDetail *answerDetail) {
        _contentView.text = answerDetail.contentText;
        [_contentView sizeToFit];
        _contentView.centerX = self.centerX;
        _contentView.alpha = 0;
        _backImageView.alpha = 0;
        _headerImageView.alpha = 0;
        _articleBackView.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            _contentView.alpha = 1.0;
            _backImageView.alpha = 1.0;
            _headerImageView.alpha = 1.0;
            _articleBackView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.backgroundImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_backImageView setImage:[image applyLightEffect]];
            [self hideHUD];
        }];
        
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.headerImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in _backScrollView.subviews)
            scrollViewHeight += view.frame.size.height;
        [_backScrollView setContentSize:(CGSizeMake(self.frame.size.width, scrollViewHeight+52.5+56+21))];
        if (answerDetail.articles.count>0) {
            [self createBottomViewWithArticles:answerDetail.articles];
            self.articlesArray = answerDetail.articles;
            DLog(@"ansDetailArticles:%@", answerDetail.articles);
        }
    }];
}

- (void)createUI {
//    [AppDelegateInstance.mainController showBottomButton:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _backImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:_backImageView];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _backScrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.alwaysBounceVertical = YES;
    _backScrollView.delegate = self;
    [self addSubview:_backScrollView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 11+40+5, self.frame.size.width-14, (self.frame.size.width-14)/307*72)];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backScrollView addSubview:_headerImageView];
    
    if (IPHONE5_SCREEN_WIDTH) {
        _contentView = [[UILabel alloc] initWithFrame:CGRectMake(23, _headerImageView.bottom+6, self.width-46, 500)];
    }else {
        _contentView = [[UILabel alloc] initWithFrame:CGRectMake(23, _headerImageView.bottom+21, self.width-46, 500)];
    }
    _contentView.textColor = [UIColor colorWithHex:0xd9d9d9];
    _contentView.font = [UIFont systemFontOfSize:15];
    _contentView.numberOfLines = 0;
    _contentView.textAlignment = NSTextAlignmentCenter;
    [_backScrollView addSubview:_contentView];

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
    [_cancelButton sizeToFit];
    [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self addSubview:_cancelButton];
    
    _HUDView = [[UIView alloc] initWithFrame:self.frame];
    _HUDView.backgroundColor = [UIColor blackColor];
    NSInteger count = 40;
    NSMutableArray *images = [NSMutableArray array];
    CGFloat length = 156;
    _HUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - length / 2, SCREEN_HEIGHT / 2 - length / 2, length, length)];
    for (int i = 0; i != count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_00%02d", i]];
        [images addObject:image];
    }
    _HUDImageView.animationImages = images;
    _HUDImageView.animationDuration = 2.0;
    _HUDImageView.animationRepeatCount = 0;
    [_HUDView addSubview:_HUDImageView];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(11);
        make.right.mas_equalTo(self.mas_right).mas_offset(-11);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self showHUD];
}

- (void)showHUD {
    [AppDelegateInstance.window addSubview:_HUDView];
    _HUDView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _HUDView.alpha = 1;
        [_HUDImageView startAnimating];
    }];
}

- (void)hideHUD {
    [_HUDView removeFromSuperview];
}

- (void)createBottomViewWithArticles:(NSArray *)articles {
    //底部文章关联
    _articleBackView = [UIView new];
    _articleBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:_articleBackView];
    
    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [_articleBackView addSubview:dimView];
    
    UIImageView *articleDimmingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_answer_page_article_title_bg"]];
    [_articleBackView addSubview:articleDimmingView];
    
    _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowButton setImage:[UIImage imageNamed:@"btn_answer_page_collapse"] forState:UIControlStateNormal];
    [_arrowButton sizeToFit];
    [_arrowButton addTarget:self action:@selector(didClickArrowButton) forControlEvents:UIControlEventTouchUpInside];
    [_articleBackView addSubview:_arrowButton];
    
    [articleDimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_articleBackView);
        make.left.mas_equalTo(_articleBackView);
        make.right.mas_equalTo(_articleBackView);
        make.height.mas_equalTo(52.5);
    }];
    
    [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(articleDimmingView.mas_bottom);
        make.left.mas_equalTo(_articleBackView);
        make.right.mas_equalTo(_articleBackView);
        make.bottom.mas_equalTo(_articleBackView);
    }];
    
    [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(articleDimmingView);
        make.centerY.mas_equalTo(articleDimmingView);
    }];
    
    articleCount = [articles count];
    
    for (int i=0; i<articleCount; i++) {
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        view.userInteractionEnabled = YES;
        [view sd_setImageWithURL:[NSURL URLWithString:articles[i][@"article_pic_2"]]];
        [_articleBackView addSubview:view];
        
        UIImageView *dimmingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_answer_page_article_title_bg"]];
        dimmingView.userInteractionEnabled = YES;
        [view addSubview:dimmingView];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = articles[i][@"article_title"];
        [view addSubview:titleLabel];
        
        UIButton *tap = [UIButton buttonWithType:UIButtonTypeCustom];
        tap.tag = 1000 + i;
        [tap addTarget:self action:@selector(didClickArticle:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:tap];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_articleBackView).mas_offset(23);
            make.right.mas_equalTo(_articleBackView).mas_offset(-23);
            make.height.mas_equalTo(108);
            make.bottom.mas_equalTo(_articleBackView).mas_offset(-15-123*i);
        }];
        
        [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view);
            make.right.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
            make.height.mas_equalTo(52.5);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).mas_offset(10);
            make.right.mas_equalTo(view).mas_offset(-10);
            make.bottom.mas_equalTo(view).mas_offset(-13);
        }];
        
        [tap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(view);
            make.center.mas_equalTo(view);
        }];
    }
    
    [_articleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(52.5+1+(108+15)*articleCount);
    }];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging && !scrollView.decelerating) {
        if (scrollView.contentOffset.y - lastOffsetY > 25) {
            DLog(@"ScrollUp now: %lf %lf", lastOffsetY, scrollView.contentOffset.y);
            lastOffsetY = MIN(scrollView.contentOffset.y, scrollView.contentSize.height-SCREEN_HEIGHT);
            [self didClickArrowButton];
        }
        else if (lastOffsetY - scrollView.contentOffset.y > 25){
            DLog(@"ScrollDown now: %lf %lf", lastOffsetY, scrollView.contentOffset.y);
            lastOffsetY = MIN(scrollView.contentOffset.y, scrollView.contentSize.height-SCREEN_HEIGHT);
            [self didClickArrowButtonBack];
        }
    }
}

#pragma mark - Action

- (void)didClickCancelButton {
//    [AppDelegateInstance.mainController showBottomButton:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didClickArrowButton {
    [UIView animateWithDuration:0.3 animations:^{
        _arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
        [_articleBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).mas_offset(-52.5);
            make.width.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(52.5+1+(108+15)*articleCount);
        }];
        [_articleBackView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_arrowButton addTarget:self action:@selector(didClickArrowButtonBack) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)didClickArrowButtonBack {
    [UIView animateWithDuration:0.3 animations:^{
        _arrowButton.transform = CGAffineTransformMakeRotation(0);
        [_articleBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(52.5+1+(108+15)*articleCount);
        }];
        [_articleBackView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_arrowButton addTarget:self action:@selector(didClickArrowButton) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)didClickArticle:(UIButton *)sender {
    NSNumber *articleID = self.articlesArray[sender.tag-1000][@"article_id"];
    [[[HTServiceManager sharedInstance] profileService] getArticle:[articleID integerValue] completion:^(BOOL success, HTArticle *articles) {
        HTArticleController *articleViewController = [[HTArticleController alloc] initWithArticle:articles];
        [[self viewController].navigationController pushViewController:articleViewController animated:YES];
    }];
}

//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
