//
//  EditableTableViewCell.m
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import "EditableTableViewCell.h"

#import "EditableTableView.h"

#define BOUNCE_SPACE    15.0

@implementation EditableTableViewCell
{
    UIView *_buttonsView;
    UIView *_panView;
    UILabel *_messageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _buttonsView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_buttonsView];
        
        _panView = [[UIView alloc] initWithFrame:CGRectZero];
        _panView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_panView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        _messageLabel.textColor = [UIColor blackColor];
        [_panView addSubview:_messageLabel];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handelPan:)];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self;
        [_panView addGestureRecognizer:panGesture];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _panView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _messageLabel.frame = CGRectMake(15.0, (self.contentView.frame.size.height - 16.0) / 2, 200.0, 16.0);
    
    if(EDITABLE_CELL_TYPE_PUBLIC == self.type) {
        _buttonsView.frame = CGRectMake(self.contentView.frame.size.width - DELETE_BUTTON_WIDTH, 0.0, DELETE_BUTTON_WIDTH, self.contentView.frame.size.height);
        
        for(EditableTableViewCellButton *editableButton in _buttonsView.subviews) {
            if(EDITABLE_BUTTON_TYPE_DELETE == editableButton.type) {
                editableButton.frame = CGRectMake(0.0, 0.0, _buttonsView.frame.size.width, _buttonsView.frame.size.height);
            }
        }
    } else if(EDITABLE_CELL_TYPE_FRIEND == self.type) {
        _buttonsView.frame = CGRectMake(self.contentView.frame.size.width - (DELETE_BUTTON_WIDTH + EDIT_BUTTON_WIDTH), 0.0, DELETE_BUTTON_WIDTH + EDIT_BUTTON_WIDTH, self.contentView.frame.size.height);
        
        for(EditableTableViewCellButton *editableButton in _buttonsView.subviews) {
            if(EDITABLE_BUTTON_TYPE_DELETE == editableButton.type) {
                editableButton.frame = CGRectMake(EDIT_BUTTON_WIDTH, 0.0, DELETE_BUTTON_WIDTH, _buttonsView.frame.size.height);
            } else if(EDITABLE_BUTTON_TYPE_EDIT == editableButton.type) {
                editableButton.frame = CGRectMake(0.0, 0.0, EDIT_BUTTON_WIDTH, _buttonsView.frame.size.height);
            }
        }
    }
    
    [self bringSubviewToFront:_panView];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLabel.text = _message;
}

- (void)setType:(EditableCellType)type
{
    _type = type;
    
    EditableTableViewCellButton *deleteButton = [[EditableTableViewCellButton alloc] initWithFrame:CGRectZero];
    deleteButton.type = EDITABLE_BUTTON_TYPE_DELETE;
    deleteButton.belongedCell = self;
    [_buttonsView addSubview:deleteButton];
    
    if(EDITABLE_CELL_TYPE_FRIEND == _type) {
        EditableTableViewCellButton *editButton = [[EditableTableViewCellButton alloc] initWithFrame:CGRectZero];
        editButton.type = EDITABLE_BUTTON_TYPE_EDIT;
        editButton.belongedCell = self;
        [_buttonsView addSubview:editButton];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(self.belongedTableView.isEditing) {
        _panView.backgroundColor = [UIColor whiteColor];
    } else {
        if(selected) {
            _panView.backgroundColor = [UIColor lightGrayColor];
        } else {
            _panView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if(self.belongedTableView.isEditing) {
        _panView.backgroundColor = [UIColor whiteColor];
    } else {
        if(highlighted) {
            _panView.backgroundColor = [UIColor lightGrayColor];
        } else {
            _panView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)handelPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIGestureRecognizerState recognizerState = gestureRecognizer.state;
    
    if(UIGestureRecognizerStateBegan == recognizerState) {

    } else if(UIGestureRecognizerStateChanged == recognizerState) {
        CGFloat maxCenterX, minCenterX;
        
        if(self.belongedTableView.isEditing) {
            minCenterX = _panView.frame.size.width / 2 - _buttonsView.frame.size.width;
            maxCenterX = _panView.frame.size.width / 2 + BOUNCE_SPACE;
        } else {
            minCenterX = _panView.frame.size.width / 2 - _buttonsView.frame.size.width - BOUNCE_SPACE;
            maxCenterX = _panView.frame.size.width / 2;
        }
        
        CGPoint pt = [gestureRecognizer translationInView:_panView];
        CGPoint center = _panView.center;
        center.x += pt.x;
        center.x = center.x < minCenterX ? minCenterX : center.x;
        center.x = center.x > maxCenterX ? maxCenterX : center.x;
        _panView.center = center;
        
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:_panView];
    } else if(UIGestureRecognizerStateEnded == recognizerState) {
        CGFloat offsetX;
        
        if(self.belongedTableView.isEditing) {
            offsetX = _panView.center.x - (_panView.frame.size.width / 2 - _buttonsView.frame.size.width);
            
            if(offsetX > 30.0) {
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     CGPoint center = _panView.center;
                                     center.x = _panView.frame.size.width / 2 + BOUNCE_SPACE;
                                     _panView.center = center;
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2
                                                      animations:^{
                                                          CGPoint center = _panView.center;
                                                          center.x = _panView.frame.size.width / 2;
                                                          _panView.center = center;
                                                      } completion:^(BOOL finished) {
                                                          self.belongedTableView.isEditing = NO;
                                                          self.belongedTableView.editingCell = nil;
                                                          
                                                          self.belongedTableView.scrollEnabled = YES;
                                                      }];
                                 }];
            } else {
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     CGPoint center = _panView.center;
                                     center.x = _panView.frame.size.width / 2 - _buttonsView.frame.size.width - BOUNCE_SPACE;
                                     _panView.center = center;
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2
                                                      animations:^{
                                                          CGPoint center = _panView.center;
                                                          center.x = _panView.frame.size.width / 2 - _buttonsView.frame.size.width;
                                                          _panView.center = center;
                                                      } completion:^(BOOL finished) {
                                                      }];
                                 }];
            }
        } else {
            offsetX = _panView.frame.size.width / 2 - _panView.center.x;
            
            if(offsetX > 30.0) {
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     CGPoint center = _panView.center;
                                     center.x = _panView.frame.size.width / 2 - _buttonsView.frame.size.width - BOUNCE_SPACE;
                                     _panView.center = center;
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2
                                                      animations:^{
                                                          CGPoint center = _panView.center;
                                                          center.x = _panView.frame.size.width / 2 - _buttonsView.frame.size.width;
                                                          _panView.center = center;
                                                      } completion:^(BOOL finished) {
                                                          self.belongedTableView.isEditing = YES;
                                                          self.belongedTableView.editingCell = self;
                                                          
                                                          self.belongedTableView.scrollEnabled = NO;
                                                      }];
                                 }];
            } else {
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     CGPoint center = _panView.center;
                                     center.x = _panView.frame.size.width / 2 + BOUNCE_SPACE;
                                     _panView.center = center;
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2
                                                      animations:^{
                                                          CGPoint center = _panView.center;
                                                          center.x = _panView.frame.size.width / 2;
                                                          _panView.center = center;
                                                      } completion:^(BOOL finished) {
                                                      }];
                                 }];
            }
        }
    } else if(UIGestureRecognizerStateCancelled == recognizerState ||
              UIGestureRecognizerStateFailed == recognizerState) {
        NSLog(@"UIGestureRecognizerStateCancelled or UIGestureRecognizerStateFailed");
    } else {
    }
}

- (void)restoreState
{
    if(self.belongedTableView.isEditing && self.belongedTableView.editingCell == self) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGPoint center = _panView.center;
                             center.x = _panView.frame.size.width / 2 + BOUNCE_SPACE;
                             _panView.center = center;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  CGPoint center = _panView.center;
                                                  center.x = _panView.frame.size.width / 2;
                                                  _panView.center = center;
                                              } completion:^(BOOL finished) {
                                                  self.belongedTableView.isEditing = NO;
                                                  self.belongedTableView.editingCell = nil;
                                                  
                                                  self.belongedTableView.scrollEnabled = YES;
                                              }];
                         }];
    }
}

- (void)editableButtonClicked:(EditableTableViewCellButton *)button
{
    [self.belongedTableView editableCell:self editableButtonClicked:button];
}

#pragma mark - UIGestureRecognizerDelegate Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if(self.belongedTableView.isEditing && self.belongedTableView.editingCell) {
            [self.belongedTableView.editingCell restoreState];
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:_panView];
        if(fabs(translation.y) > fabs(translation.x)) {
            return NO;
        }
    }
    
    return YES;
}

@end
