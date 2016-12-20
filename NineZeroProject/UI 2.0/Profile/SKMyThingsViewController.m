//
//  SKMyThingsViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMyThingsViewController.h"
#import "HTUIHeader.h"

@interface SKThingsCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView   *thing_image;
@property (nonatomic, strong) UILabel       *thing_title;
@end

@implementation SKThingsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_SEPARATOR_COLOR;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
        footView.backgroundColor = [UIColor colorWithHex:0x242424];
        [self.contentView addSubview:footView];
        
        _thing_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-30)];
        [self.contentView addSubview:_thing_image];
        
        _thing_title = [UILabel new];
        _thing_title.text = @"蓝宝石瓶子";
        _thing_title.textColor = [UIColor whiteColor];
        _thing_title.font = PINGFANG_FONT_OF_SIZE(10);
        _thing_title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_thing_title];
        [_thing_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
        }];
     }
    return self;
}

@end

@interface SKMyThingsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSArray<SKPiece*> *pieceArray;
@end

@implementation SKMyThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getPieces:^(BOOL success, NSArray<SKPiece *> *pieces) {
        self.pieceArray = pieces;
        [self.collectionView reloadData];
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"已收集的玩意儿";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SKThingsCell class] forCellWithReuseIdentifier:NSStringFromClass([SKThingsCell class])];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKThingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SKThingsCell class]) forIndexPath:indexPath];
    cell.thing_title.text = self.pieceArray[indexPath.row].piece_name;
    [cell.thing_image sd_setImageWithURL:[NSURL URLWithString:self.pieceArray[indexPath.row].piece_cover_pic]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - 40)/3;
    return CGSizeMake(width, width/92*102+30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pieceArray.count;
}

@end
