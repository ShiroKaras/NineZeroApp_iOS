//
//  NZLabDetialCollectionViewCell.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZLabDetialCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, assign) float cellHeight;

- (void)setComment:(NSString *)comment;
@end
