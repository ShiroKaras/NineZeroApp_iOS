//
//  HTMascotHelper.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotHelper.h"
#import "CommonUI.h"
#import "HTUIHeader.h"

@implementation HTMascotHelper

+ (UIColor *)colorWithMascotIndex:(NSInteger)index {
    if (index < 1 || index > 8) return [UIColor whiteColor];
    NSArray *colors = @[[UIColor colorWithHex:0xed203b],
                        [UIColor colorWithHex:0x24ddb2],
                        [UIColor colorWithHex:0xd40e88],
                        [UIColor colorWithHex:0x5f3a1c],
                        [UIColor colorWithHex:0xfdd900],
                        [UIColor colorWithHex:0xffdb00],
                        [UIColor colorWithHex:0x323542],
                        [UIColor colorWithHex:0x770ae2],];
    return colors[index - 1];
}

+ (NSMutableArray<HTMascot *> *)mascotsFake {
    NSMutableArray<HTMascot *> *mascots = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i != 8; i++) {
        HTMascot *mascot = [[HTMascot alloc] init];
        mascot.mascotID = i + 1;
        mascot.mascotName = @"呵呵";
        mascot.mascotDescription = @"这只零仔是懒惰的，特征主要体现在行为上，走哪睡哪，吃东西会睡着，洗澡会睡着，上学的路上会睡着，它可以映射着歌时代的学生们，在压力之下的疲乏于无所作为。";
        NSInteger articleCount = 9;
        NSMutableArray<HTArticle *> *articles = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j != articleCount; j++) {
            HTArticle *article = [[HTArticle alloc] init];
            article.mascotID = i + 1;
            article.hasRead = NO;
            article.articleURL = @"www.baidu.com";
            article.articleTitle = @"这里是文章标题这是是文章";
            [articles addObject:article];
        }
        mascot.articles = articles;
        [mascots addObject:mascot];
    }
    return mascots;
}

@end