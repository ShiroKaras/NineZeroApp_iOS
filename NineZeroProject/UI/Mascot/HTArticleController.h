//
//  HTArticleController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTArticle;
@interface HTArticleController : UIViewController

- (instancetype)initWithArticle:(HTArticle *)article;

@property (nonatomic, strong) HTArticle *article;

@end
