//
//  EditableTableView.m
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import "EditableTableView.h"

@implementation EditableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

- (void)editableCell:(EditableTableViewCell *)cell editableButtonClicked:(EditableTableViewCellButton *)button
{
    [cell restoreState];
    
    if(EDITABLE_BUTTON_TYPE_EDIT == button.type) {
        [self.editableDelegate editableTableView:self didClickEditButtonOfEditableTableViewCell:cell];
    } else if(EDITABLE_BUTTON_TYPE_DELETE == button.type) {
        [self.editableDelegate editableTableView:self didClickDeleteButtonOfEditableTableViewCell:cell];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if(self.isEditing && self.editingCell) {
        [self.editingCell restoreState];
    }
}

@end
