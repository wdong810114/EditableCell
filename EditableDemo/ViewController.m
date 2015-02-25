//
//  ViewController.m
//  EditableDemo
//
//  Created by 王冬冬 on 15-1-15.
//  Copyright (c) 2015年 Spark. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *_messageArray;
    NSMutableArray *_typeArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"可编辑列表";

    _messageArray = [[NSMutableArray alloc] initWithObjects:@"第一条朋友消息", @"第二条朋友消息", @"第三条朋友消息", @"第一条公众消息", @"第二条公众消息", @"第四条朋友消息", @"第三条公众消息", nil];
    _typeArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"1", @"1", @"0", @"1", nil];

    EditableTableView *editableTableView = [[EditableTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    _editableTableView = editableTableView;
    editableTableView.delegate = self;
    editableTableView.dataSource = self;
    editableTableView.editableDelegate = self;
    [self.view addSubview:editableTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EditableTableViewIdentifier = @"EditableTableViewIdentifier";
    
    EditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EditableTableViewIdentifier];
    if(cell == nil) {
        cell = [[EditableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EditableTableViewIdentifier];
    }

    cell.belongedTableView = _editableTableView;
    cell.message = [_messageArray objectAtIndex:indexPath.row];
    cell.type = ([[_typeArray objectAtIndex:indexPath.row] integerValue] == 0) ? EDITABLE_CELL_TYPE_FRIEND : EDITABLE_CELL_TYPE_PUBLIC;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselectRowAtIndexPath:) withObject:indexPath afterDelay:0.1];
    
// 测试用
//    ViewController *viewController = [[ViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.editableTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EditableTableViewDelegate Methods
- (void)editableTableView:(EditableTableView *)editableTableView didClickEditButtonOfEditableTableViewCell:(EditableTableViewCell *)editableTableViewCell
{
    NSLog(@"你编辑了%@", editableTableViewCell.message);
}

- (void)editableTableView:(EditableTableView *)editableTableView didClickDeleteButtonOfEditableTableViewCell:(EditableTableViewCell *)editableTableViewCell
{
    NSLog(@"你删除了%@", editableTableViewCell.message);
    
    NSIndexPath *cellIndexPath = [editableTableView indexPathForCell:editableTableViewCell];
    
    [_messageArray removeObjectAtIndex:cellIndexPath.row];
    [_typeArray removeObjectAtIndex:cellIndexPath.row];
    
    [_editableTableView beginUpdates];
    [_editableTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [_editableTableView endUpdates];
}

@end
