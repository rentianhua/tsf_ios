//
//  PersonalController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/16.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "PersonalController.h"
#import "OtherHeader.h"
#import "PersonalCell.h"
#import "PersonalOtherCell.h"
#import "UIButton+WebCache.h"
#import "ZYWHttpEngine.h"
#import "UserModel.h"
#import "UserInfoModel.h"
#import <MJExtension.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "YJProgressHUD.h"
#import "UpLoadIDCardCell.h"
#import "DescripVC.h"
#import "ChangePswVC.h"

#import "ApplyPhoneVC.h"
#import "TSFMultiPickerView.h"//主营区域
#import "TSFOtherPickView.h"//职业类型

#import "TSFModifyDataVC.h"//修改姓名
#import "TSFUploadImgVC.h"
#import "TSFPicsModel.h"

#define NAVBTNW 20

@interface PersonalController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>


@property (nonatomic,strong)ChangePswVC * changePSWVC;//修改密码

@property (nonatomic,assign)BOOL uploadHeadImage;
@property (nonatomic,assign)BOOL upLoadIDCard;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UserModel * model;

@property (nonatomic,strong)NSArray * quyuArray;
@property (nonatomic,strong)NSArray * zhiyeArray;
@property (nonatomic,strong)NSArray * congyeArray;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation PersonalController

- (ChangePswVC *)changePSWVC{
    if (_changePSWVC==nil) {
        _changePSWVC=[[ChangePswVC alloc]init];
    }
    return _changePSWVC;
}

- (NSArray *)congyeArray{
    if (_congyeArray==nil) {
        _congyeArray=@[@"1-2年",@"2-5年",@"5年以上"];
    }
    return _congyeArray;
}
- (NSArray *)quyuArray{
    if (_quyuArray==nil) {
        _quyuArray=@[@"罗湖区",@"福田区",@"南山区",@"盐田区",@"宝安区",@"龙岗新区",@"龙华新区",@"光明新区",@"坪山新区",@"大鹏新区",@"东莞",@"惠州"];
    }
    return _quyuArray;
}
- (NSArray *)zhiyeArray{
    if (_zhiyeArray==nil) {
        _zhiyeArray=@[@"个人",@"公司"];
    }
    return _zhiyeArray;
}
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

- (void)setUserid:(NSString *)userid{
    _userid=userid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
  
        NSString * urlStr=[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR];
        NSDictionary * params=@{@"userid":_userid};
    
    __weak typeof(self)weakSelf=self;
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:urlStr params:params success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                weakSelf.model=model;
                [weakSelf.tableView reloadData];
            }

        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
        
  
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"个人中心";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    [self initWithTableView];
}

- (void)initWithTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView registerClass:[PersonalCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[PersonalCell class] forCellReuseIdentifier:@"cell2"];//2区
    [tableView registerNib:[UINib nibWithNibName:@"UpLoadIDCardCell" bundle:nil] forCellReuseIdentifier:@"upload"];
    
    [tableView registerNib:[UINib nibWithNibName:@"PersonalOtherCell" bundle:nil] forCellReuseIdentifier:@"text"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_model==nil) {
        tableView.hidden=YES;
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    } else{
        tableView.hidden=NO;
    }
    if ([_model.modelid isEqualToString:@"35"]) {//普通用户
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 6;
                break;
                
            default:
                return 1;
                break;
        }
        
    } else{//经纪人
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 6;
                break;
            case 2:
                return 6;
                break;
            default:
                return 1;
                break;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_model.modelid isEqualToString:@"35"]) {
        return 3;
    } else{
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.modelid isEqualToString:@"35"]) {
        if (indexPath.section==0 ) {
            return 60;
        } else{
            return 44;
        }
    } else{
        switch (indexPath.section) {
            case 0:{
                return 60;
            }
                
                break;
            case 1:{
                return 44;
            }
                
                break;
            case 2:{
                return 44;
            }
                
                break;
                
            default:{
                return 44;
            }
                break;
        }
    }
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_model.modelid isEqualToString:@"35"]) {//普通用户
        UITableViewCell * cell=[self cellForTableView:tableView indexPath:indexPath];
        return cell;
        
    }else{//经纪人
        switch (indexPath.section) {
            
            case 2:{
                switch (indexPath.row) {
                    case 5:{//上传身份证
                        UpLoadIDCardCell * cell=[tableView dequeueReusableCellWithIdentifier:@"upload" forIndexPath:indexPath];
                        cell.uploadBtn.tag=10001;
                        if (!([_model.info.sfzpic isEqualToString:@""] || _model.info.sfzpic==nil)) {
                            [cell.uploadBtn setTitle:@"身份证已上传" forState:UIControlStateNormal];

                        } else{
                            [cell.uploadBtn setTitle:@"上传身份证" forState:UIControlStateNormal];
                            
                        }
                        [cell.uploadBtn addTarget:self action:@selector(uploadIDCard:) forControlEvents:UIControlEventTouchUpInside];
                        return cell;
                    }
                        break;
                        
                    default:{
                        PersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
                        cell.rightLabel.hidden=NO;
                        cell.headButton.hidden=YES;
                        switch (indexPath.row) {
                            case 0:{
                                cell.leftLabel.text=@"身份证号码";
                                cell.rightLabel.text=_model.info.cardnumber;
                            }
                                
                                break;
                            case 1:{
                                cell.leftLabel.text=@"主营区域";
                                cell.rightLabel.text=_model.info.mainarea;
                            }
                                break;
                            case 2:{
                                 cell.leftLabel.text=@"职业类型";
                                cell.rightLabel.text=_model.info.leixing;
                            }
                                break;
                            case 3:{
                                if ([_model.info.leixing isEqualToString:@"个人"]) {
                                    cell.rightLabel.text=@"无";
                                } else{
                                    cell.leftLabel.text=@"公司名称";
                                    cell.rightLabel.text=_model.info.coname;
                                }
                               
                                
                            }
                                break;
                            default:{
                                cell.leftLabel.text=@"从业时间";
                                if ([_model.info.worktime isEqualToString:@"6"]) {
                                     cell.rightLabel.text=@"5年以上";
                                } else{
                                    cell.rightLabel.text=[NSString stringWithFormat:@"%@年",_model.info.worktime];
                                }

                            }
                                break;
                        }
                        return cell;
                    }
                        break;
                }
            }
                
                break;
                
            default:{
                PersonalCell * cell=(PersonalCell *)[self cellForTableView:tableView indexPath:indexPath];
                return cell;
            }
                break;
        }
    }
}
//*******************************普通用户cell********************************
- (UITableViewCell *)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {//头像
       PersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.headButton.tag=1000;
        cell.leftLabel.text=@"头像";
        cell.headButton.hidden=NO;
        cell.rightLabel.text=@"";
        [cell.headButton sd_setImageWithURL:[NSURL URLWithString:_model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"myhome_icon_avatar"]];
        [cell.headButton addTarget:self action:@selector(headPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    } else if (indexPath.section==1){
        
        if (indexPath.row==0 || indexPath.row==1) {//手机号码、会员类型
            PersonalOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
            cell.rightLabel.hidden=NO;
            cell.rightLabel.textColor=DESCCOL;
            if (indexPath.row==0) {
                cell.leftLabel.text=@"手机号码";
                cell.rightLabel.text=_model.username;
            } else {
                cell.leftLabel.text=@"会员类型";
                if ([_model.modelid isEqualToString:@"35"]) {
                    cell.rightLabel.text=@"普通用户";
            } else{
                    cell.rightLabel.text=@"经纪人";
             }

            }
            return cell;
        } else{
            PersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 4:{
                    cell.leftLabel.text=@"分机号";
                    cell.rightButton.hidden=NO;
                    cell.rightLabel.hidden=NO;
                    if ([_model.zhuanjie isEqualToNumber:@1]) {
                        NSString * fenji=[_model.vtel stringByReplacingOccurrencesOfString:@"转" withString:@"-"];
                        cell.rightLabel.text=fenji;
                    } else{
                        cell.rightLabel.text=@"申请分机号";
                    }
                  
                }
                    
                    break;
                case 2:{
                    cell.leftLabel.text=@"真实姓名";
                    cell.rightButton.hidden=NO;
                    cell.rightLabel.hidden=NO;
                    cell.rightLabel.text=_model.info.realname;
                }
                    break;
                case 3:{
                    cell.leftLabel.text=@"性别";
                    cell.rightLabel.hidden=NO;
                    if ([_model.sex isEqualToString:@"0"]) {
                        cell.rightLabel.text=@"未知";
                    } else if ([_model.sex isEqualToString:@"1"]){
                        cell.rightLabel.text=@"男";
                    } else{
                        cell.rightLabel.text=@"女";
                    }
                }
                    break;
               
                case 5:
                {
                    cell.leftLabel.text=@"个人介绍";
                    cell.rightButton.hidden=NO;
                    cell.rightLabel.hidden=NO;
                    cell.rightLabel.text=_model.about;
                    
                }
                    break;
                    
                default:
                    break;
            }
            return cell;
        }
    }
    
    else{
        PersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.leftLabel.text=@"修改密码";
        cell.rightLabel.text=@"";
        cell.headButton.hidden=YES;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (NSUSER_DEF(USERINFO)==nil ) {
        [YJProgressHUD showMessage:@"请重新登录" inView:self.view];
        return;
    }
    
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 4:{//修改分机号
                ApplyPhoneVC * vc=[[ApplyPhoneVC alloc]init];
                vc.model=_model;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{//真实姓名
                
                TSFModifyDataVC * VC=[[TSFModifyDataVC alloc]init];
                VC.modifyType=ModifyRealVCType;
                VC.model=_model;
                VC.navigationItem.title=@"修改真实姓名";
                [self.navigationController pushViewController:VC animated:YES];
            
            }
                break;
            case 3:{//修改性别
                [self showActionSheet];
            }
                
                break;
            case 5:{//个人介绍
                DescripVC * vc=[[DescripVC alloc]init];
                vc.navigationItem.title=@"个人介绍";
                vc.model=_model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section==2){
        
        if ([_model.modelid isEqualToString:@"35"]) {
            //修改密码
            [self.navigationController pushViewController:self.changePSWVC animated:YES];
        }
        
        if (![_model.modelid isEqualToString:@"35"] ) {
            switch (indexPath.row) {
                case 0:{//修改身份证号码
                    TSFModifyDataVC * VC=[[TSFModifyDataVC alloc]init];
                    VC.model=_model;
                    VC.modifyType=ModifyIDVCType;
                    VC.navigationItem.title=@"修改身份证号码";
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    break;
                case 1:{//修改主营区域
                    
                    TSFMultiPickerView * pick=[[TSFMultiPickerView alloc]initWithFrame:self.view.frame selectTitle:@"请选择区域" array:self.quyuArray];
                    
                    pick.areaType=AreaTypeY;
                    pick.hasseleArray=[_model.info.mainarea componentsSeparatedByString:@","];
                    [pick showView:^(NSArray *selectArray) {
                      
                        NSString * str=nil;
                        if (selectArray==nil) {
                            return ;
                        } else{
                            str=[selectArray componentsJoinedByString:@","];
                        }
                        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
                        NSDictionary * param=@{@"userid":_model.userid,
                                               @"mainarea":str};
    
                        [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
                            if (responseObj) {
                                _model.info.mainarea=str;
                                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            }
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];
                }
                    
                    break;
                case 2:{//修改职业类型
                   
                    NSIndexPath * indexPath2=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                    TSFOtherPickView * otherPick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"选择职业类型" array:self.zhiyeArray];
                    [otherPick showView:^(NSString *str) {
                        
                        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
                        NSDictionary * param=@{@"userid":_model.userid,
                                               @"leixing":str};
                        [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
                            if (responseObj) {
                                _model.info.leixing=str;
                                [self.tableView reloadRowsAtIndexPaths:@[indexPath,indexPath2] withRowAnimation:UITableViewRowAnimationFade];
                            }
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];
                    
                }
                    break;
                case 3:{//修改公司名称
                    if ([_model.info.leixing isEqualToString:@"个人"]) {
                        [YJProgressHUD showMessage:@"请选择职业类型为公司类型" inView:self.view];
                        return;
                    }
                    TSFModifyDataVC * VC=[[TSFModifyDataVC alloc]init];
                    VC.model=_model;
                    VC.modifyType=ModifyCYVCType;
                    VC.navigationItem.title=@"修改公司名称";
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    break;
                case 4:{//修改从业年限
                    TSFOtherPickView * otherPick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"选择从业年限" array:self.congyeArray];
                    [otherPick showView:^(NSString *str) {
                        
                        NSString * nianxian=nil;
                        if ([str isEqualToString:@"1-2年"]) {
                            nianxian=@"1-2";
                        } else if ([str isEqualToString:@"2-5年"]){
                            nianxian=@"2-5";
                        } else{
                            nianxian=@"6";
                        }
                        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
                        NSDictionary * param=@{@"userid":_model.userid,
                                               @"worktime":nianxian};

                        [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
                            if (responseObj) {
                                _model.info.worktime=nianxian;
                                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            }
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];
 
                }
                    break;
                default:
                    break;
            }
 
        }
}
    else if (indexPath.section==3){
        //修改密码
        [self.navigationController pushViewController:self.changePSWVC animated:YES];
    }
}


- (void)showActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self changeSex:@1];
    }];
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self changeSex:@2];
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:otherAction1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeSex :(NSNumber *)sex{
    
 
    
    NSNumber * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSDictionary * param=@{
                           @"userid":userid,
                           @"sex":sex
                           };
    //g=api&m=user&a=api_doprofile
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR] params:param success:^(id responseObj) {
        if (responseObj) {
            NSString * sexStr=[sex stringValue];
            _model.sex=sexStr;
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}
//点击头像按钮
- (void)headPhotoClick:(UIButton *)button
{
    _uploadHeadImage=YES;
    _upLoadIDCard=NO;
    [self showActionSheetForUploadImage];
}

- (void)showActionSheetForUploadImage{//上传图片的弹框
    if (IOS8) {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * photo=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openCamera];
        }];
        UIAlertAction * album=[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openAlbum];
        }];
        [alertController addAction:photo];
        [alertController addAction:album];
        [alertController addAction:cancle];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else{//iOS7及以下版本
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相机中选择", nil];
        [sheet showInView:self.view];
        
    }
 
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //拍照0 相册1 取消2
    if (buttonIndex==0) {
        [self openCamera];
    } else if (buttonIndex==1){
        [self openAlbum];
    }
}

- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//判断是否支持相机
       UIImagePickerController * imagePickerController=[[UIImagePickerController alloc]init];
        imagePickerController.delegate=self;
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing=YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    
    
}

- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){

                         }];
    }
}


#pragma mark-----UIImagePickerControllerDelegate---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];


}

#pragma mark------------VPImageCropperDelegate----
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        NSString  *urlStr;
        NSNumber * userid;
        NSString * pic;

        NSData *imageData = UIImageJPEGRepresentation(editedImage, 1);
        if (_uploadHeadImage) {
            urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_uploadavatar",URLSTR];
            userid=NSUSER_DEF(USERINFO)[@"userid"];
            pic=@"__avatar1";
            [self requestForUploadImg:urlStr userid:userid pic:pic imageData:imageData];
            
        } else {
            urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
            userid=NSUSER_DEF(USERINFO)[@"userid"];
            pic=@"sfzpic";
            [self uploadIDCardImage:imageData];
        }
        
        
    }];
}

- (void)requestForUploadImg:(NSString *)urlstr userid:(NSNumber *)userid pic:(NSString *)pic imageData:(NSData *)imageData{
    // TO DO
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"image/jpeg",
                                                         @"text/html",
                                                         @"image/png",
                                                         nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary * params=@{@"userid":userid};
    [manager POST:urlstr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:pic
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            
            if (_uploadHeadImage) {//如果是上传头像
                NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                _model.userpic=dict[@"avatarUrls"];
                
                NSUSER_DEF_NORSET(_model.userpic, USERPIC);
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {//如果是上传身份证
           
            
        }
    }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)uploadIDCardImage:(NSData *)imageData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"image/jpeg",
                                                         @"text/html",
                                                         @"image/png",
                                                         nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSNumber * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSDictionary * params=@{@"userid":userid,
                            @"catid":@"52",
                            @"thumb_width":@"300",
                            @"thumb_height":@"200",
                            @"watermark_enable":@"0",
                            @"module":@"text"};
    [manager POST:[NSString stringWithFormat:@"%@g=api&m=user&a=uploadimg",URLSTR] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        
        [formData appendPartWithFileData:imageData
                                    name:@"pic"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
            NSDictionary * param=@{
                                   @"userid":userid,
                                   @"sfzpic":dict[@"url"]
                                   };
            [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObjOther) {
                if (responseObjOther) {
                    if ([responseObjOther[@"success"] isEqualToNumber:@54]) {
                        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:5 inSection:2];
                        UpLoadIDCardCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
                        [cell.uploadBtn setTitle:@"身份证已上传" forState:UIControlStateNormal];
                        cell.uploadBtn.enabled=NO;
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)uploadIDCard:(UIButton *)button{
    
    if (!([_model.info.sfzpic isEqualToString:@""] || _model.info.sfzpic==nil)) {
        [YJProgressHUD showMessage:@"身份证已上传" inView:self.view];
     
     } else{
         _uploadHeadImage=NO;
         _upLoadIDCard=YES;
         //[self showActionSheetForUploadImage];
         
         TSFUploadImgVC * VC=[[TSFUploadImgVC alloc]init];
         VC.isPersonIDCardUpload = YES;
         VC.picsBlock=^(NSMutableArray * pics){
             NSNumber * userid=NSUSER_DEF(USERINFO)[@"userid"];
             NSMutableString *idsUrls = [NSMutableString string];
             for(NSDictionary *p in pics)
             {
                 if(idsUrls.length<=0)
                 {
                     [idsUrls appendString:p[@"url"]];
                 }
                 else
                 {
                     [idsUrls appendFormat:@",%@", p[@"url"]];
                 }
             }
             if(idsUrls.length>0 && userid)
             {
                 NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR];
                 NSDictionary * param=@{
                                        @"userid":userid,
                                        @"sfzpic":idsUrls
                                        };
                 [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObjOther) {
                     if (responseObjOther) {
                         if ([responseObjOther[@"success"] isEqualToNumber:@54]) {
                             NSIndexPath * indexPath=[NSIndexPath indexPathForRow:5 inSection:2];
                             UpLoadIDCardCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
                             [cell.uploadBtn setTitle:@"身份证已上传" forState:UIControlStateNormal];
                             cell.uploadBtn.enabled=NO;
                         }
                     }
                 } failure:^(NSError *error) {
                     
                 }];
             }
         };
         [self.navigationController pushViewController:VC animated:YES];
     }
}

@end
