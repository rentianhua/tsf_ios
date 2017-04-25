//
//  SuccessNotesViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "SuccessNotesViewController.h"
#import "OtherHeader.h"
#import "SuccessNotesCell.h"
@interface SuccessNotesViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SuccessNotesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    [tableview registerClass:[SuccessNotesCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuccessNotesCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


@end
