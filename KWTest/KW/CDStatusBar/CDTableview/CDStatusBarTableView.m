//
//  CDStatusBarTableView.m
//  Pods
//
//  Created by aaaa on 16/8/16.
//
//

#import "CDStatusBarTableView.h"
#import "CDStatusBarTableViewCell.h"
#import "CDStatusBarTableViewTextFieldCellTableViewCell.h"
#import "CDStatusBarTableViewHeaderView.h"

static NSString * const cellID = @"statusBarCell";
static NSString * const cellTextFieldID = @"cellTextFieldID";
static NSString * const headerViewID = @"headerViewID";

@interface CDStatusBarTableView ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;

@end

@implementation CDStatusBarTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self initView];
        [self registerCell];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView = [UIView new];
    self.bounces = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = YES;
}

- (void)registerCell
{
    [self registerClass:[CDStatusBarTableViewCell class] forCellReuseIdentifier:cellID];
    [self registerClass:[CDStatusBarTableViewTextFieldCellTableViewCell class] forCellReuseIdentifier:cellTextFieldID];
    
    [self registerClass:[CDStatusBarTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:headerViewID];
}

- (void)buttonClick:(UIButton *)button
{
    if (_statusBarTableViewDelegate && [_statusBarTableViewDelegate respondsToSelector:@selector(statusBarTableView:addItem:)]) {
        if ([_textField isFirstResponder]) {
            [_textField resignFirstResponder];
        }
        if (_textField.text.length >0) {
            NSString *temp = [_textField.text copy];
            _textField.text = @"";
            [_statusBarTableViewDelegate statusBarTableView:self addItem:temp];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return @"删除";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [_items removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (_statusBarTableViewDelegate && [_statusBarTableViewDelegate respondsToSelector:@selector(statusBarTableView:deleteAtIndex:)]) {
        [_statusBarTableViewDelegate statusBarTableView:self deleteAtIndex:indexPath.row];
    }
}

#pragma mark -UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _items?_items.count:0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CDStatusBarTableViewHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewID];
        NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
        view.textLabel.text = [NSString stringWithFormat:@"版本号:%@(Build%@)",info[@"CFBundleShortVersionString"],info[@"CFBundleVersion"]];
        return view;
    }
    else
    {
        CDStatusBarTableViewHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewID];
        view.textLabel.text = @"自定义地址";
        return view;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    CDStatusBarTableViewHeaderView *headerView = (CDStatusBarTableViewHeaderView *)view;
    headerView.textLabel.textColor = [UIColor whiteColor];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CDStatusBarTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.prompt.text = _items[indexPath.row];
        return cell;
    }
    else
    {
        CDStatusBarTableViewTextFieldCellTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellTextFieldID forIndexPath:indexPath];
        [cell.okButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _textField = cell.textField;
        _textField.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    if (indexPath.section == 0) {
        if (_statusBarTableViewDelegate && [_statusBarTableViewDelegate respondsToSelector:@selector(statusBarTableView:selectAtIndex:)]) {
            [_statusBarTableViewDelegate statusBarTableView:self selectAtIndex:indexPath.row];
        }
    }
}

#pragma  mark -UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
