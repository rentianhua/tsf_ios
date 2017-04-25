//
//  TSFSuccessRecordVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/17.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSuccessRecordVC.h"
#import <UIImageView+WebCache.h>
#import "OtherHeader.h"
#import "HouseModel.h"
#import "IDModel.h"
#import "TSFHandSuccessCell.h"
#import "HandRoomDetailVC.h"
#import "RentRoomDetailVC.h"
#define NAVBTNW 20

@interface TSFSuccessRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)UIView * Head;
@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation TSFSuccessRecordVC
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView * )tabelView{
    if (_tabelView==nil) {
        _tabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tabelView.delegate=self;
        _tabelView.dataSource=self;
        [_tabelView registerNib:[UINib nibWithNibName:@"TSFHandSuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tabelView.tableHeaderView=self.Head;
        
        _tabelView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tabelView;
}

- (void)setSuccessArray:(NSArray *)successArray{
    _successArray=successArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"同小区成交";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.successArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFHandSuccessCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HouseModel * model=self.successArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
 
    if(self.isRentHouse)
        cell.label2.text=[NSString stringWithFormat:@"%@(第%@层)%@",model.ceng,model.zongceng,model.chaoxiang];
    else
        cell.label2.text=[NSString stringWithFormat:@"%@(第%@层)%@",model.ceng,model.curceng,model.chaoxiang];
    
    cell.label2.textColor=DESCCOL;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    if(self.isRentHouse)
    {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.updatetime longLongValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.label3.text=[NSString stringWithFormat:@"成交日期:%@",confromTimespStr];
    }
    else
    {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.updatetime longLongValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.label3.text=[NSString stringWithFormat:@"签约日期:%@",confromTimespStr];
    }
    cell.label3.textColor=DESCCOL;
    
    if(self.isRentHouse)
    {
        if (model.zujin.length==0 ) {
            cell.label4.text=@"价格待定";
            cell.label4.textColor=ORGCOL;
            cell.label4.font=[UIFont boldSystemFontOfSize:16];
        }  else{
            if (model.mianji.length==0 || [model.mianji isEqualToString:@"0"]) {
                cell.label4.text=[NSString stringWithFormat:@"%@元",model.zujin];
                cell.label4.textColor=ORGCOL;
                cell.label4.font=[UIFont boldSystemFontOfSize:16];
                
            } else{
                NSString * price=[NSString stringWithFormat:@"%.f平米",[model.mianji floatValue]];
                NSString * zongjia=[NSString stringWithFormat:@"%@元/月",model.zujin];
                NSString * string=[NSString stringWithFormat:@"%@ %@",zongjia,price];
                
                NSRange range1=[string rangeOfString:price];
                NSRange range2=[string rangeOfString:zongjia];
                
                NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
                [attrStr addAttribute:NSForegroundColorAttributeName value:TITLECOL range:range1];
                [attrStr addAttribute:NSForegroundColorAttributeName value:ORGCOL range:range2];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range2];
                
                [cell.label4 setAttributedText:attrStr];
            }
        }
    }
    else
    {
        if (model.zongjia.length==0 ) {
            cell.label4.text=@"价格待定";
            cell.label4.textColor=ORGCOL;
            cell.label4.font=[UIFont boldSystemFontOfSize:16];
        }  else{
            if (model.jianzhumianji.length==0 || [model.jianzhumianji isEqualToString:@"0"]) {
                cell.label4.text=[NSString stringWithFormat:@"%@万",model.zongjia];
                cell.label4.textColor=ORGCOL;
                cell.label4.font=[UIFont boldSystemFontOfSize:16];
                
            } else{
                NSString * price=[NSString stringWithFormat:@"%.f元/平米",10000*[model.zongjia floatValue]/[model.jianzhumianji floatValue]];
                NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
                NSString * string=[NSString stringWithFormat:@"%@ %@",zongjia,price];
                
                NSRange range1=[string rangeOfString:price];
                NSRange range2=[string rangeOfString:zongjia];
                
                NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
                [attrStr addAttribute:NSForegroundColorAttributeName value:TITLECOL range:range1];
                [attrStr addAttribute:NSForegroundColorAttributeName value:ORGCOL range:range2];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range2];
                
                [cell.label4 setAttributedText:attrStr];
            }
        }
    }

    cell.hidenLine=YES;
   
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel * model=self.successArray[indexPath.row];
    
    if(self.isRentHouse)
    {
        RentRoomDetailVC * VC=[[RentRoomDetailVC alloc]init];
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.ID=model.ID;
        idmodel.catid=model.catid;
        VC.model=idmodel;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        IDModel * idModel=[[IDModel alloc]init];
        idModel.ID=model.ID;
        idModel.typeID=model.typeID;
        idModel.catid=model.catid;
        idModel.jjr_id=model.jjr_id;
        
        HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
