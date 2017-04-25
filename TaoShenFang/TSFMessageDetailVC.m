//
//  TSFMessageDetailVC.m
//  TaoShenFang
//
//  Created by YXM on 16/12/20.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMessageDetailVC.h"

#import <IQKeyboardManager.h>
#import <IQToolBar.h>

#import "IMYWebView.h"
#import "OtherHeader.h"

#import "Chat_Model.h"
#import "Chat_Cell.h"

#import "ZYWHttpEngine.h"
#import <MJExtension.h>

#define  tool_h 54.0


#import "YJProgressHUD.h"
@interface TSFMessageDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    CGRect old_frame;
    IQKeyboardManager *_manager;
}


// 聊天视图
@property(strong,nonatomic)UITableView * chat_Tabv;
// 聊天数据源 (模拟)
@property(strong,nonatomic)NSMutableArray * chat_Arr;
//中间变量
@property(strong,nonatomic)Chat_Cell * temp_cell;
//聊天下面的发送 语音视图 键盘监听用
@property(strong,nonatomic)UIView  * chat_ToolV;
@property(strong,nonatomic)UITextField * chat_Txt;


@property (nonatomic,strong)UIButton * leftNaVBtn;

@property (nonatomic,strong)dispatch_source_t timer1;

@end

@implementation TSFMessageDetailVC
- (UIButton *)leftNaVBtn{
    if (_leftNaVBtn==nil) {
        _leftNaVBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNaVBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNaVBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNaVBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载定时器
    [self loadDataStatus];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用。
    _manager.enable = YES;
    _manager.enableAutoToolbar = NO;
    
    

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNaVBtn];
    self.edgesForExtendedLayout = UIRectEdgeNone;//不会延伸至navigationBar和tabBar
    
    [self.view addSubview:self.chat_Tabv];
    
    if ([_towho isEqualToString:@"0"]) {
        self.chat_Tabv.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
    } else{
       [self setToolV]; 
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self loadData];
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDataStatus{
    
    __weak typeof(self)weakSelf=self;
    dispatch_queue_t queue1=dispatch_queue_create("tsf", DISPATCH_QUEUE_CONCURRENT);
    
    self.timer1= dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue1);
    dispatch_time_t start=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    uint64_t interVal=(uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer1, start, interVal, 0);
    
    
    dispatch_source_set_event_handler(self.timer1, ^{
        
        [weakSelf loadDataTime];
        
    });
    dispatch_resume(self.timer1);
    
}

- (void)loadDataTime{
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"],
                           @"towho":self.towho};
  
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_detail",URLSTR] params:param success:^(id responseObj) {
      
        if (responseObj) {
            weakSelf.chat_Arr=[Chat_Model mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.chat_Tabv reloadData];
            
            [weakSelf scrollToTableViewBottom];
            
        }
    } failure:^(NSError *error) {
      
    }];

}

- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"],
                           @"towho":self.towho};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_detail",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.chat_Arr=[Chat_Model mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.chat_Tabv reloadData];
            
            [weakSelf scrollToTableViewBottom];

        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

//聊天的发送  语音等按钮
-(void)setToolV
{
    UITextField * textF = [[UITextField alloc]initWithFrame:CGRectMake(15, kMainScreenHeight-tool_h-64+5, kMainScreenWidth-30, tool_h-10)];
    textF.placeholder = @"想说什么~";
    textF.delegate = self;
    textF.backgroundColor=[UIColor whiteColor];
    textF.layer.masksToBounds=YES;
    textF.layer.cornerRadius=5;
    textF.returnKeyType=UIReturnKeySend;
    self.chat_Txt = textF;
    [self.view addSubview:textF];
    
}
#pragma mark - del /dat
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chat_Arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString * identify = @"chat_ID";
    Chat_Cell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[Chat_Cell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor=RGB(240, 239, 245, 1.0);
    self.temp_cell = cell;
    cell.chat_M = self.chat_Arr[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chat_Model * chat_Ms = [self.chat_Arr objectAtIndex:indexPath.row];
    self.temp_cell.chat_M = chat_Ms;
    return self.temp_cell.bounds.size.height;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    NSString *newContent = self.chat_Txt.text;
    if (newContent.length < 1) {
        return NO;
    }
     [self.chat_Txt  resignFirstResponder];
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"to_uid":self.towho,
                           @"from_uid":NSUSER_DEF(USERINFO)[@"userid"],
                           @"content":newContent};
    [YJProgressHUD showProgress:@"正在发送" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_add",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            if ([responseObj[@"success"] isEqual:@189]) {
                
                [weakSelf loadData];
                self.chat_Txt.text=@"";
                
            }
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];

    
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.chat_Txt resignFirstResponder];
}

#pragma mark - action

/**
 键盘监听
 
 @param notification __通知
 */
-(void)keyBoardWillShow:(NSNotification*)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat keyboard_H = keyboardFrame.size.height;
    __weak typeof(self)  weakself = self;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
     
    } completion:^(BOOL finished) {
        [weakself scrollToTableViewBottom];
    }];
    
}
-(void)keyBoardWillHide:(NSNotification*)notification
{
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        weakself.chat_Tabv.frame = old_frame;
        weakself.chat_ToolV.frame = CGRectMake(0, kMainScreenHeight - tool_h-64, kMainScreenWidth, tool_h);
    } completion:^(BOOL finished) {
        [weakself scrollToTableViewBottom];
    }];
}
-(void)SendTxtBtnAction:(UIButton *)sender
{
    
    
}
// Scroll to the bottom row 滚动到最后一行
- (void)scrollToTableViewBottom {
    
    if (self.chat_Arr.count==0) {
        return;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.chat_Arr.count - 1 inSection:0];
    [self.chat_Tabv scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
#pragma mark - get

-(UITableView *)chat_Tabv
{
    if (!_chat_Tabv) {
        _chat_Tabv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-tool_h) style:UITableViewStylePlain];
        _chat_Tabv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chat_Tabv.backgroundColor=RGB(240, 239, 245, 1.0);
        old_frame = _chat_Tabv.frame;
        _chat_Tabv.delegate = self;
        _chat_Tabv.dataSource = self;
    }
    return _chat_Tabv;
}

-(NSMutableArray *)chat_Arr
{
    if (!_chat_Arr) {
        _chat_Arr = [NSMutableArray array];
    }
    return _chat_Arr;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _manager.enableAutoToolbar = YES;
    
    dispatch_cancel(self.timer1);
    self.timer1=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
