//
//  EditableTableViewCell.h
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditableTableViewCellButton.h"

#define EDIT_BUTTON_WIDTH       80.0
#define DELETE_BUTTON_WIDTH     80.0

typedef NS_ENUM(NSInteger, EditableCellType) {
    EDITABLE_CELL_TYPE_PUBLIC,      // 公众
    EDITABLE_CELL_TYPE_FRIEND       // 好友
};

@class EditableTableView;

@interface EditableTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (copy, nonatomic) NSString *message;

@property (strong, nonatomic) EditableTableView *belongedTableView;
@property (assign, nonatomic) EditableCellType type;

- (void)restoreState;

- (void)editableButtonClicked:(EditableTableViewCellButton *)button;

@end
