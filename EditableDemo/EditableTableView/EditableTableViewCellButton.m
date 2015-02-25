//
//  EditableTableViewCellButton.m
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import "EditableTableViewCellButton.h"

#import "EditableTableViewCell.h"

@implementation EditableTableViewCellButton
{
    UILabel *_titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0.0, (self.frame.size.height - 16.0) / 2, self.frame.size.width, 16.0);
}

- (void)setType:(EditableButtonType)type
{
    _type = type;
    
    if(EDITABLE_BUTTON_TYPE_EDIT == _type) {
        self.backgroundColor = EDIT_BUTTON_NORMAL_COLOR;
        _titleLabel.text = @"编辑";
    } else if(EDITABLE_BUTTON_TYPE_DELETE == _type) {
        self.backgroundColor = DELETE_BUTTON_NORMAL_COLOR;
        _titleLabel.text = @"删除";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(EDITABLE_BUTTON_TYPE_EDIT == _type) {
        self.backgroundColor = EDIT_BUTTON_HIGHLIGHTED_COLOR;
    } else if(EDITABLE_BUTTON_TYPE_DELETE == _type) {
        self.backgroundColor = DELETE_BUTTON_HIGHLIGHTED_COLOR;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(EDITABLE_BUTTON_TYPE_EDIT == _type) {
        self.backgroundColor = EDIT_BUTTON_NORMAL_COLOR;
    } else if(EDITABLE_BUTTON_TYPE_DELETE == _type) {
        self.backgroundColor = DELETE_BUTTON_NORMAL_COLOR;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(EDITABLE_BUTTON_TYPE_EDIT == _type) {
        self.backgroundColor = EDIT_BUTTON_NORMAL_COLOR;
    } else if(EDITABLE_BUTTON_TYPE_DELETE == _type) {
        self.backgroundColor = DELETE_BUTTON_NORMAL_COLOR;
    }
    
    [self.belongedCell editableButtonClicked:self];
}

@end
