//
//  CDStatusBarTableViewCell.m
//  Pods
//
//  Created by aaaa on 16/8/16.
//
//

#import "CDStatusBarTableViewCell.h"

@implementation CDStatusBarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 3.0f;
        label.layer.borderWidth = 1.0f;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _prompt = label;
        [self.contentView addSubview:_prompt];
    }
    return self;
}

- (void)layoutSubviews
{
    _prompt.frame = CGRectMake(15, 7, self.frame.size.width - 30, self.frame.size.height - 14);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    UIColor *backgroundColor = self.superview.superview.backgroundColor;
    if (highlighted) {
        backgroundColor = [backgroundColor colorWithAlphaComponent:1.0];
        self.contentView.backgroundColor = backgroundColor;
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}
@end
