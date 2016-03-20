//
//  HTProfileArticleCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileArticleCell.h"
#import "HTModel.h"
#import "NSDate+Utility.h"

@interface HTProfileArticleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mascotImageView;
@property (weak, nonatomic) IBOutlet UILabel *mascotNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HTProfileArticleCell {
    HTArticle *_article;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setArticle:(HTArticle *)article {
    _article = article;
    NSInteger mascotID = MIN(1, MAX(8, article.mascotID));
    _titleLabel.text = article.articleTitle;
    _timeLabel.text = [self stringWithDate:[NSDate dateWithTimeIntervalSince1970:[article.publish_time integerValue]]];
    _mascotImageView.image = [self imageWithMascotID:mascotID];
    _mascotNumberLabel.text = [NSString stringWithFormat:@"/ 零仔NO.%ld", mascotID];
}

- (NSString *)stringWithDate:(NSDate *)date {
    if ([date isToday]) {
        return [NSString stringWithFormat:@"%02ld:%02ld", [date hour], [date minute]];
    } else if ([date isYesterday]) {
        return @"昨天";
    } else if ([date isLastYear]) {
        return @"1年前";
    } else if ([date isInPast]) {
        return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", [date year], [date month], [date day]];
    }
    return @"";
}

- (UIImage *)imageWithMascotID:(NSInteger)mascotID {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_profile_archive_mascot%ld", mascotID]];
    if (image == nil) return [UIImage imageNamed:@"img_profile_archive_mascot1"];
    return image;
}

@end
