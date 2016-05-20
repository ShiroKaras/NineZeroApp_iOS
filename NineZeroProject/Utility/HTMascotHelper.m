//
//  HTMascotHelper.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotHelper.h"
#import "CommonUI.h"
#import "HTUIHeader.h"

@implementation HTMascotHelper

+ (UIColor *)colorWithMascotIndex:(NSInteger)index {
    if (index < 1 || index > 8) return [UIColor whiteColor];
    NSArray *colors = @[[UIColor colorWithHex:0xed203b],
                        COMMON_GREEN_COLOR,
                        COMMON_PINK_COLOR,
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
        mascot.mascotName = @"零仔〇";
        mascot.mascotDescription = @"从世界尽头归来，也从新世界开始，〇来自传说中的529D星球。〇纯洁如一张白纸，却孤独如一片深海。虽然这个世界与自己残存的记忆中的星球有太多类似的地方，但是它还是需要找到529D星球的一些线索，它希望知道自己的来处，希望了解关于529D星球的一切真相。";
        NSInteger articleCount = 9;
        NSMutableArray<HTArticle *> *articles = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j != articleCount; j++) {
            HTArticle *article = [[HTArticle alloc] init];
            article.mascotID = i + 1;
            article.hasRead = NO;
            article.articleURL = @"www.baidu.com";
            article.articleTitle = @"这里是文章标题";
            [articles addObject:article];
        }
        mascot.article_list = articles;
        mascot.articles = 8;
        [mascots addObject:mascot];
    }
    return mascots;
}

+ (HTMascot *)defaultMascots {
    HTMascot *mascot = [[HTMascot alloc] init];
    mascot.mascotID = 1;
    mascot.mascotName = @"零仔〇";
    mascot.mascotDescription = @"从世界尽头归来，也从新世界开始，〇来自传说中的529D星球。〇纯洁如一张白纸，却孤独如一片深海。虽然这个世界与自己残存的记忆中的星球有太多类似的地方，但是它还是需要找到529D星球的一些线索，它希望知道自己的来处，希望了解关于529D星球的一切真相。";
    NSInteger articleCount = 0;
    NSMutableArray<HTArticle *> *articles = [NSMutableArray arrayWithCapacity:10];
    for (int j = 0; j != articleCount; j++) {
        HTArticle *article = [[HTArticle alloc] init];
        article.mascotID = 1;
        article.hasRead = NO;
        article.articleURL = @"www.baidu.com";
        article.articleTitle = @"这里是文章标题";
        [articles addObject:article];
    }
    mascot.article_list = articles;
    mascot.articles = articleCount;
    return mascot;
}

@end
