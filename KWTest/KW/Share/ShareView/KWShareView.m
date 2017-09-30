//
//  KWShareView.m
//  Pods
//
//  Created by hey on 2016/12/21.
//
//

#import "KWShareView.h"
#import <Masonry/Masonry.h>
#import "KWShareViewCollectionViewCell.h"
#import "KWAppSkinColor.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ShareViewHeight 260

static NSString *const cellId = @"cellId";

@interface KWShareView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray<ShareViewItem *> *shareViewDataSource;
}
//背景视图
@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) UIButton *cancelButton;

@end

@implementation KWShareView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(void)createViews
{
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor darkGrayColor];
    _backView.alpha = 0;
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissShareView)]];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC.view addSubview:_backView];
    
    self.backgroundColor = [UIColor colorWithRed:242 green:244 blue:247 alpha:1.0];
    [rootVC.view addSubview:self];
    
    UICollectionViewFlowLayout * _customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_customLayout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [KWAppSkinColor sharedInstance].viewBackgroundColor;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[KWShareViewCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    [self sendSubviewToBack:_cancelButton];

}

-(void)createConstrains
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootVC.view);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView);
        make.right.equalTo(_backView);
        make.top.mas_equalTo(_backView.mas_bottom);
        make.height.equalTo(@(ShareViewHeight));
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(_cancelButton.mas_top);
    }];
    
    //展示动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView);
            make.right.equalTo(_backView);
            make.bottom.equalTo(_backView);
            make.height.equalTo(@(ShareViewHeight));
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            _backView.alpha = 0.5;
            [rootVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    });
    
}

-(void)showKWShareViewWith:(NSArray *)dataArray
{
    shareViewDataSource = dataArray;
    [_collectionView reloadData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return shareViewDataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KWShareViewCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell updateWithItem:[shareViewDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = ScreenWidth/ 4;
    return (CGSize){cellWidth,80};
//    float edge = (shareViewDataSource.count+1)*10;  //间距总和
//    float cellWidth = (ScreenWidth-edge)/shareViewDataSource.count;
//    return (CGSize){cellWidth,cellWidth};
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_KWShareViewDelegate && [_KWShareViewDelegate respondsToSelector:@selector(shareViewDidSelectItemWith:withTitle:)]) {
        ShareViewItem *item = [shareViewDataSource objectAtIndex:indexPath.row];
        [_KWShareViewDelegate shareViewDidSelectItemWith:indexPath withTitle:item.title];
        [self dismissShareView];
    }
}

-(void)cancelButtonClick
{
    [self dismissShareView];
}

-(void)dismissShareView
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView);
        make.right.equalTo(_backView);
        make.top.mas_equalTo(_backView.mas_bottom);
        make.height.equalTo(@(ShareViewHeight));
    }];

    [UIView animateWithDuration:0.2 animations:^{
        _backView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [_collectionView removeFromSuperview];
        [self removeFromSuperview];
        _collectionView = nil;
        _backView = nil;
    }];
    
   
}
@end
