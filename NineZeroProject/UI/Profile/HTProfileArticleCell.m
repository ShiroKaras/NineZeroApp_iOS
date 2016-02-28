//
//  HTProfileArticleCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileArticleCell.h"
#import "HTModel.h"

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
    
}

@end
