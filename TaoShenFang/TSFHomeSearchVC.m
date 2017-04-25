//
//  TSFHomeSearchVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFHomeSearchVC.h"

#import "OtherHeader.h"
#import "TSFBtn.h"


#import "HandRoomViewController.h"//二手房
#import "NewHouseListController.h"//新房
#import "RentRoomViewController.h"//租房

//深  厚  龙

@interface TSFHomeSearchVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)TSFBtn * leftBtn;
@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UITextField * textField;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * titleArr;


@end

@implementation TSFHomeSearchVC

- (NSArray *)titleArr{
    if (_titleArr==nil) {
        _titleArr=@[@"二手房",@"新房",@"租房"];
    }
    return _titleArr;
}
- (void)loadView{
    [super loadView];
    
    self.navigationController.navigationBarHidden=NO;

}

- (void)initSubViews{
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftView];

    _topView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-70, 30)];
    _topView.backgroundColor=SeparationLineColor;
    _topView.layer.masksToBounds=YES;
    _topView.layer.cornerRadius=3;
    
    _leftBtn=[[TSFBtn alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [_leftBtn setTitle:@"二手房" forState:UIControlStateNormal];
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_leftBtn setImage:[UIImage imageNamed:@"arrow_down_01"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:TITLECOL forState:UIControlStateNormal];
    
    [_leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_leftBtn];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(70, 0, kMainScreenWidth-140, 30)];
    _textField.font=[UIFont systemFontOfSize:12];
    _textField.placeholder=@"请输入关键字";
    _textField.delegate=self;
    _textField.returnKeyType=UIReturnKeySearch;
    [_topView addSubview:_textField];
    [_textField becomeFirstResponder];
    
    self.navigationItem.titleView=_topView;
    
    
    _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:DESCCOL forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 10, 100, 120) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.hidden=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSubViews];
    
    self.leftSelect=leftBtnSelectedHand;
    
}

- (void)leftAction:(UIButton *)leftBtn{
    
    _leftBtn.selected=!_leftBtn.selected;
    if (_leftBtn.selected==YES) {
        
        _tableView.hidden=NO;
        
    } else{
        _tableView.hidden=YES;
    }

}

- (void)cancelAction:(UIButton *)cancelBtn{
    
    [_textField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=self.titleArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            self.leftSelect=leftBtnSelectedHand;
            break;
        case 1:
            self.leftSelect=leftBtnSelectedNew;
            break;
            
        default:
            self.leftSelect=leftBtnSelectedRent;
            break;
    }
    
    tableView.hidden=YES;
    _leftBtn.selected=NO;
    
    [_leftBtn setTitle:self.titleArr[indexPath.row] forState:UIControlStateNormal];
    
}

#pragma mark----UITextFieldDelegate-------

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    /*HandRoomViewController
     NewHouseListController
     RentRoomViewController*/
    if (self.leftSelect==leftBtnSelectedHand) {//二手房
        HandRoomViewController * VC=[[HandRoomViewController alloc]init];
        VC.kwds=textField.text;
        [self.navigationController pushViewController:VC animated:YES];
        
        
        
    } else if (self.leftSelect==leftBtnSelectedNew){//新房
        NewHouseListController * VC=[[NewHouseListController alloc]init];
        VC.kwds=textField.text;
        [self.navigationController pushViewController:VC animated:YES];
        
    } else if (self.leftSelect==leftBtnSelectedRent){//租房
        RentRoomViewController * VC=[[RentRoomViewController alloc]init];
        VC.kwds=textField.text;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
