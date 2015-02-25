//
//  EditableTableViewCellButton.h
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditableButtonType) {
    EDITABLE_BUTTON_TYPE_EDIT,      // 编辑
    EDITABLE_BUTTON_TYPE_DELETE     // 删除
};

#define COLOR(R, G, B, A)                   [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define EDIT_BUTTON_NORMAL_COLOR            COLOR(0.0, 255.0, 0.0, 1.0)
#define EDIT_BUTTON_HIGHLIGHTED_COLOR       COLOR(0.0, 255.0, 0.0, 0.7)
#define DELETE_BUTTON_NORMAL_COLOR          COLOR(255.0, 0.0, 0.0, 1.0)
#define DELETE_BUTTON_HIGHLIGHTED_COLOR     COLOR(255.0, 0.0, 0.0, 0.7)

@class EditableTableViewCell;

@interface EditableTableViewCellButton : UIView

@property (strong, nonatomic) EditableTableViewCell *belongedCell;
@property (assign, nonatomic) EditableButtonType type;

@end
