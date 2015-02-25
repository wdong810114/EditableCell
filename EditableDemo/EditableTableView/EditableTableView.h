//
//  EditableTableView.h
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditableTableViewCell.h"

@class EditableTableView;

@protocol EditableTableViewDelegate <NSObject>

@required
- (void)editableTableView:(EditableTableView *)editableTableView didClickEditButtonOfEditableTableViewCell:(EditableTableViewCell *)editableTableViewCell;
- (void)editableTableView:(EditableTableView *)editableTableView didClickDeleteButtonOfEditableTableViewCell:(EditableTableViewCell *)editableTableViewCell;

@end

@interface EditableTableView : UITableView

@property (weak, nonatomic) id <EditableTableViewDelegate> editableDelegate;
@property (assign, nonatomic) BOOL isEditing;   // 是否正在编辑
@property (strong, nonatomic) EditableTableViewCell *editingCell;   // 正在编辑的单元格

- (void)editableCell:(EditableTableViewCell *)cell editableButtonClicked:(EditableTableViewCellButton *)button;

@end
