//
//  HTArticleController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTArticleController;
@protocol HTArticleControllerDelegate <NSObject>
@optional
- (void)didClickLickButtonInArticleController:(HTArticleController *)controller;
@end

@class HTArticle;
@interface HTArticleController : UIViewController

- (instancetype)initWithArticle:(HTArticle *)article;

@property (nonatomic, strong) HTArticle *article;
@property (nonatomic, weak) id<HTArticleControllerDelegate> delegate;

@end
