//
//  ShaixuanView.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-24.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ShaixuanView.h"

@interface ShaixuanView ()

@end

@implementation ShaixuanView
@synthesize dataArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W36" size:18];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.indentationLevel = 4;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"name", nil];
    if ([LTDataShare sharedService].viewFrom == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanFromServiceViewControl" object:dic];
    }else if ([LTDataShare sharedService].viewFrom == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanFromSearchViewControl" object:dic];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
