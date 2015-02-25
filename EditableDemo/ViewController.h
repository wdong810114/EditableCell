//
//  ViewController.h
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditableTableView.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EditableTableViewDelegate>

@property (strong, nonatomic) EditableTableView *editableTableView;

@end

