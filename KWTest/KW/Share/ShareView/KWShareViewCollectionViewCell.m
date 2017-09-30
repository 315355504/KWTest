//
//  KWShareViewCollectionViewCell.m
//  Pods
//
//  Created by hey on 2016/12/21.
//
//

#import "KWShareViewCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface KWShareViewCollectionViewCell ()

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UIImageView *iconImageView;

@end

@implementation KWShareViewCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(void)createViews
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _iconImageView = [[UIImageView alloc] init];
    [self addSubview:_iconImageView];
}

-(void)createConstrains
{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(_iconImageView.mas_bottom).offset(15);
    }];
}

-(void)updateWithItem:(ShareViewItem *)item
{
    _titleLabel.text = item.title;
    _iconImageView.image = item.image;
}

@end
