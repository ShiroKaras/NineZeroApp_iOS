//
//  HTArticleController.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTArticle;
@interface HTArticleController : UIViewController

- (instancetype)initWithArticle:(HTArticle *)article;

@property (nonatomic, strong) HTArticle *article;

@end
