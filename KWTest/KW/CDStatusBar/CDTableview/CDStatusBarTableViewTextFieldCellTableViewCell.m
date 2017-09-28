//
//  CDStatusBarTableViewTextFieldCellTableViewCell.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/12/2.
//
//

#import "CDStatusBarTableViewTextFieldCellTableViewCell.h"

@implementation CDStatusBarTableViewTextFieldCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = [UIColor blackColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_textField];
        [self.contentView addSubview:_okButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _okButton.frame = CGRectMake(self.frame.size.width - 55, 7, 40, self.frame.size.height - 14);
    _textField.frame = CGRectMake(15, 7, self.frame.size.width - 80, self.frame.size.height - 14);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
