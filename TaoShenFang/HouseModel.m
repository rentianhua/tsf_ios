//
//  HouseModel.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HouseModel.h"
#import "TSFPicsModel.h"
#import "TSFSeeHouseModel.h"
#import "TSFDTModel.h"

@implementation HouseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             @"typeID":@"typeid",
             @"descrip":@"description"
             };
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"pics":@"TSFPicsModel",
             @"loupantupian":@"TSFPicsModel",
             @"weizhitu":@"TSFPicsModel",
             @"yangbantu":@"TSFPicsModel",
             @"shijingtu":@"TSFPicsModel",
             @"xiaoqutu":@"TSFPicsModel",
             @"daikan":@"TSFSeeHouseModel",
             @"tongqu":@"HouseModel",
             @"yhq":@"YSFYhqModel",
             @"loupandongtai":@"TSFDTModel",
             @"fubiao":@"TSFTradesModel"
             };
}


- (NSString *)title{
    if (_title==nil) {
        _title=@"";
    }
    return _title;
}

- (NSString *)style{
    if (_style==nil) {
        _style=@"";
    }
    return _style;
}

- (NSString *)zongjia{
    if (_zongjia==nil) {
        _zongjia=@"";
    }
    return _zongjia;
}

- (NSString *)shi{
    if (_shi==nil) {
        _shi=@"";
    }
    return _shi;
}

- (NSString *)ting{
    if (_ting==nil) {
        _ting=@"";
    }
    return _ting;
}

- (NSString *)wei{
    if (_wei==nil) {
        _wei=@"";
    }
    return _wei;
}

- (NSString *)chu{
    if (_chu==nil) {
        _chu=@"";
    }
    return _chu;
}

- (NSString *)yangtai{
    if (_yangtai==nil) {
        _yangtai=@"";
    }
    return _yangtai;
}
- (NSString *)huxing{
    if (_huxing==nil) {
        _huxing=@"";
    }
    return _huxing;
}

- (NSString *)ceng{
    if (_ceng==nil) {
        _ceng=@"";
    }
    return _ceng;
}

- (NSString *)zongceng{
    if (_zongceng==nil) {
        _zongceng=@"";
    }
    return _zongceng;
}

- (NSString *)louceng{
    if (_louceng==nil) {
        _louceng=@"";
    }
    return _louceng;
}
- (NSString *)zhuangxiu{
    if (_zhuangxiu==nil) {
        _zhuangxiu=@"";
    }
    return _zhuangxiu;
}

- (NSString *)chaoxiang{
    if (_chaoxiang==nil) {
        _chaoxiang=@"";
    }
    return _chaoxiang;
}
- (NSString *)jiegou{
    if (_jiegou==nil) {
        _jiegou=@"";
    }
    return _jiegou;
}
- (NSString *)dianti{
    if (_dianti==nil) {
        _dianti=@"";
    }
    return _dianti;
}

- (NSString *)fukuanfangshi{
    if (_fukuanfangshi==nil) {
        _fukuanfangshi=@"";
    }
    return _fukuanfangshi;
}

- (NSString *)huxingintro{
    if (_huxingintro==nil) {
        _huxingintro=@"";
    }
    return _huxingintro;
}

- (NSString *)liangdian{
    if (_liangdian==nil) {
        _liangdian=@"";
    }
    return _liangdian;
}

- (NSString *)biaoqian{
    if (_biaoqian==nil) {
        _biaoqian=@"";
    }
    return _biaoqian;
}

- (NSString *)province{
    if (_province==nil) {
        _province=@"";
    }
    return _province;
}

- (NSString *)city{
    if (_city==nil) {
        _city=@"";
    }
    return _city;
}

- (NSString *)area{
    if (_area==nil) {
        _area=@"";
    }
    return _area;
}

- (NSString *)provincename{
    if (_provincename==nil) {
        _provincename=@"";
    }
    return _provincename;
}
- (NSString *)cityname{
    if (_cityname==nil) {
        _cityname=@"";
    }
    return _cityname;
}
- (NSString *)areaname{
    if (_areaname==nil) {
        _areaname=@"";
    }
    return _areaname;
}

- (NSString *)isxuequ{
    if (_isxuequ==nil) {
        _isxuequ=@"";
    }
    return _isxuequ;
}

- (NSString *)ditiexian{
    if (_ditiexian==nil) {
        _ditiexian=@"";
    }
    return _ditiexian;
}

- (NSString *)descrip{
    if (_descrip==nil) {
        _descrip=@"";
    }
    return _descrip;
}
- (NSString *)fangling{
    if (_fangling==nil) {
        _fangling=@"";
    }
    return _fangling;
}
- (NSString *)leixing{
    if (_leixing==nil) {
        _leixing=@"";
    }
    return _leixing;
}

- (NSString * )jingweidu{
    if (_jingweidu==nil) {
        _jingweidu=@"";
    }
    return _jingweidu;
}

- (NSString *)province_name{
    if (_province_name==nil) {
        _province_name=@"";
    }
    return _province_name;
}
- (NSString *)city_name{
    if (_city_name==nil) {
        _city_name=@"";
    }
    return _city_name;
}

- (NSString *)area_name{
    if (_area_name==nil) {
        _area_name=@"";
    }
    return _area_name;
}
- (NSString *)zulin{
    if (_zulin==nil) {
        _zulin=@"";
    }
    return _zulin;
}
- (NSString *)xiaoqu{
    if (_xiaoqu==nil) {
        _xiaoqu=@"";
    }
    return _xiaoqu;
}
- (NSString *)bianhao{
    if (_bianhao==nil) {
        _bianhao=@"";
    }
    return _bianhao;
}
- (NSString *)guapaidate{
    if (_guapaidate==nil) {
        _guapaidate=@"";
    }
    return _guapaidate;
}
- (NSString *)mianji{
    if (_mianji==nil) {
        _mianji=@"";
    }
    return _mianji;
}
- (NSString *)zujin{
    if (_zujin==nil) {
        _zujin=@"";
    }
    return _zujin;
}
- (NSString *)address{
    if (_address==nil) {
        _address=@"";
    }
    return _address;
}
- (NSString *)jiaoyiquanshu{
    if (_jiaoyiquanshu==nil) {
        _jiaoyiquanshu=@"";
    }
    return _jiaoyiquanshu;
}
- (NSString *)loupandizhi{
    if (_loupandizhi==nil) {
        _loupandizhi=@"";
    }
    return _loupandizhi;
}
- (NSString *)zhandimianji{
    if (_zhandimianji==nil) {
        _zhandimianji=@"";
    }
    return _zhandimianji;
}
- (NSString *)junjia{
    if (_junjia==nil) {
        _junjia=@"";
    }
    return _junjia;
}
- (NSString *)jianzhumianji{
    if (_jianzhumianji==nil) {
        _jianzhumianji=@"";
    }
    return _jianzhumianji;
}
- (NSString *)hexinmaidian{
    if (_hexinmaidian==nil) {
        _hexinmaidian=@"";
    }
    return _hexinmaidian;
}
- (NSString *)jiaotong{
    if (_jiaotong==nil) {
        _jiaotong=@"";
    }
    return _jiaotong;
}
- (NSString *)contacttel{
    if (_contacttel==nil) {
        _contacttel=@"";
    }
    return _contacttel;
}
- (NSString *)fangwuyongtu{
    if (_fangwuyongtu==nil) {
        _fangwuyongtu=@"";
    }
    return _fangwuyongtu;
}
- (NSString *)hezuofangshi{
    if (_hezuofangshi==nil) {
        _hezuofangshi=@"";
    }
    return _hezuofangshi;
}

- (NSString *)contactname{
    if (_contactname==nil) {
        _contactname=@"";
    }
    return _contactname;
}
- (NSString *)wuyetype{
    if (_wuyetype==nil) {
        _wuyetype=@"";
    }
    return _wuyetype;
}
- (NSString *)updatetime{
    if (_updatetime==nil) {
        _updatetime=@"";
    }
    return _updatetime;
}
- (NSString *)shiyongnianxian{
    if (_shiyongnianxian==nil) {
        _shiyongnianxian=@"";
    }
    return _shiyongnianxian;
}
- (NSString *)goudijine{
    if (_goudijine==nil) {
        _goudijine=@"";
    }
    return _goudijine;
}
- (NSString *)kaipandate{
    if (_kaipandate==nil) {
        _kaipandate=@"";
    }
    return _kaipandate;
}
- (NSString *)jiaofangdate{
    if (_jiaofangdate==nil) {
        _jiaofangdate=@"";
    }
    return _jiaofangdate;
}
- (NSString *)inputtime{
    if (_inputtime==nil) {
        _inputtime=@"";
    }
    return _inputtime;
}

- (NSString *)kaifashang{
    if (_kaifashang==nil) {
        _kaifashang=@"";
    }
    return _kaifashang;
}

- (NSString *)jianzhutype{
    if (_jianzhutype==nil) {
        _jianzhutype=@"";
    }
    return _jianzhutype;
}
- (NSString *)chanquannianxian{
    if (_chanquannianxian==nil) {
        _chanquannianxian=@"";
    }
    return _chanquannianxian;
}
-(NSString *)guihuahushu{
    if (_guihuahushu==nil) {
        _guihuahushu=@"";
    }
    return _guihuahushu;
}
- (NSString *)guihuachewei{
    if (_guihuachewei==nil) {
        _guihuachewei=@"";
    }
    return _guihuachewei;
}
- (NSString *)rongjilv{
    if (_rongjilv==nil) {
        _rongjilv=@"";
    }
    return _rongjilv;
}
- (NSString *)lvhualv{
    if (_lvhualv==nil) {
        _lvhualv=@"";
    }
    return _lvhualv;
}
- (NSString *)wuyefei{
    if (_wuyefei==nil) {
        _wuyefei=@"";
    }
    return _wuyefei;
}
- (NSString *)loupandongtai{
    if (_loupandongtai==nil) {
        _loupandongtai=@"";
    }
    return _loupandongtai;
}
- (NSString *)username{
    if (_username==nil) {
        _username=@"";
    }
    return _username;
}
- (NSString *)zhulihuxing{
    if (_zhulihuxing==nil) {
        _zhulihuxing=@"";
    }
    return _zhulihuxing;
}
- (NSString *)xiaoquname{
    if (_xiaoquname==nil) {
        _xiaoquname=@"";
    }
    return _xiaoquname;
}
- (NSString *)mianjiarea{
    if (_mianjiarea==nil) {
        _mianjiarea=@"";
    }
    return _mianjiarea;
}
- (NSString *)wuyeleixing{
    if (_wuyeleixing==nil) {
        _wuyeleixing=@"";
    }
    return _wuyeleixing;
}
- (NSString *)loudong{
    if (_loudong==nil) {
        _loudong=@"";
    }
    return _loudong;
}
- (NSString *)menpai{
    if (_menpai==nil) {
        _menpai=@"";
    }
    return _menpai;
}
- (NSString *)shuxing{
    if (_shuxing==nil) {
        _shuxing=@"";
    }
    return _shuxing;
}
- (NSString *)diyaxinxi{
    if (_diyaxinxi==nil) {
        _diyaxinxi=@"";
    }
    return _diyaxinxi;
}
- (NSString *)jianzhujiegou{
    if (_jianzhujiegou==nil) {
        _jianzhujiegou=@"";
    }
    return _jianzhujiegou;
}
- (NSString *)tihubili{
    if (_tihubili==nil) {
        _tihubili=@"";
    }
    return _tihubili;
}
- (NSString *)chanquansuoshu{
    if (_chanquansuoshu==nil) {
        _chanquansuoshu=@"";
    }
    return _chanquansuoshu;
}
- (NSString *)isweiyi{
    if (_isweiyi==nil) {
        _isweiyi=@"";
    }
    return _isweiyi;
}
- (NSString *)taoneimianji{
    if (_taoneimianji==nil) {
        _taoneimianji=@"";
    }
    return _taoneimianji;
}
- (NSString *)touzifenxi{
    if (_touzifenxi==nil) {
        _touzifenxi=@"";
    }
    return _touzifenxi;
}
- (NSString *)xiaoquintro{
    if (_xiaoquintro==nil) {
        _xiaoquintro=@"";
    }
    return _xiaoquintro;
}
- (NSString *)shuifeijiexi{
    if (_shuifeijiexi==nil) {
        _shuifeijiexi=@"";
    }
    return _shuifeijiexi;
}
- (NSString *)zxdesc{
    if (_zxdesc==nil) {
        _zxdesc=@"";
    }
    return _zxdesc;
}
- (NSString *)shenghuopeitao{
    if (_shenghuopeitao==nil) {
        _shenghuopeitao=@"";
    }
    return _shenghuopeitao;
}
- (NSString *)xuexiaomingcheng{
    if (_xuexiaomingcheng==nil) {
        _xuexiaomingcheng=@"";
    }
    return _xuexiaomingcheng;
}
- (NSString *)xiaoquyoushi{
    if (_xiaoquyoushi==nil) {
        _xiaoquyoushi=@"";
    }
    return _xiaoquyoushi;
}
- (NSString *)quanshudiya{
    if (_quanshudiya==nil) {
        _quanshudiya=@"";
    }
    return _quanshudiya;
}
- (NSString *)yezhushuo{
    if (_yezhushuo==nil) {
        _yezhushuo=@"";
    }
    return _yezhushuo;
}
- (NSString *)desc{
    if (_desc==nil) {
        _desc=@"";
    }
    return _desc;
}
- (NSString *)curceng{
    if (_curceng==nil) {
        _curceng=@"";
    }
    return _curceng;
}
- (NSString *)czreason{
    if (_czreason==nil) {
        _czreason=@"";
    }
    return _czreason;
}
- (NSString *)fukuan{
    if (_fukuan==nil) {
        _fukuan=@"";
    }
    return _fukuan;
}
- (NSString *)fangwupeitao{
    if (_fangwupeitao==nil) {
        _fangwupeitao=@"";
    }
    return _fangwupeitao;
}
- (NSString *)chuzutype{
    if (_chuzutype==nil) {
        _chuzutype=@"";
    }
    return _chuzutype;
}
- (NSString *)paytype{
    if (_paytype==nil) {
        _paytype=@"";
    }
    return _paytype;
}
- (NSString *)shiarea{
    if (_shiarea==nil) {
        _shiarea=@"";
    }
    return _shiarea;
}
- (NSString *)chenghu{
    if (_chenghu==nil) {
        _chenghu=@"";
    }
    return _chenghu;
}
- (NSString *)pub_type{
    if (_pub_type==nil) {
        _pub_type=@"";
    }
    return _pub_type;
}
- (NSString *)hidetel{
    if (_hidetel==nil) {
        _hidetel=@"";
    }
    return _hidetel;
}
- (NSString *)zujinrange{
    if (_zujinrange==nil) {
        _zujinrange=@"";
    }
    return _zujinrange;
}
- (NSString *)zongjiarange{
    if (_zongjiarange==nil) {
        _zongjiarange=@"";
    }
    return _zongjiarange;
}
- (NSString *)contract{
    if (_contract==nil) {
        _contract=@"";
    }
    return _contract;
}
- (NSString *)idcard{
    if (_idcard==nil) {
        _idcard=@"";
    }
    return _idcard;
}
- (NSString *)shangcijiaoyi{
    if (_shangcijiaoyi==nil) {
        _shangcijiaoyi=@"";
    }
    return _shangcijiaoyi;
}
- (NSString *)zaishou{
    if (_zaishou==nil) {
        _zaishou=@"";
    }
    return _zaishou;
}
- (NSString *)yhq_buyer_count{
    if (_yhq_buyer_count==nil) {
        _yhq_buyer_count=@"";
    }
    return _yhq_buyer_count;
}
- (NSString *)hasyhq{
    if (_hasyhq==nil) {
        _hasyhq=@"";
    }
    return _hasyhq;
}
- (NSString *)shuidianranqi{
    if (_shuidianranqi==nil) {
        _shuidianranqi=@"";
    }
    return _shuidianranqi;
}
- (NSString *)wuyegongsi{
    if (_wuyegongsi==nil) {
        _wuyegongsi=@"";
    }
    return _wuyegongsi;
}
- (NSString *)dafen_zbpt{
    if (_dafen_zbpt==nil) {
        _dafen_zbpt=@"";
    }
    return _dafen_zbpt;
}
- (NSString *)dafen_jt{
    if (_dafen_jt==nil) {
        _dafen_jt=@"";
    }
    return _dafen_jt;
}
- (NSString *)dafen_hj{
    if (_dafen_hj==nil) {
        _dafen_hj=@"";
    }
    return _dafen_hj;
}
- (NSString *)dianping{
    if (_dianping==nil) {
        _dianping=@"";
    }
    return _dianping;
}
- (NSString *)huxingjieshao{
    if (_huxingjieshao==nil) {
        _huxingjieshao=@"";
    }
    return _huxingjieshao;
}
- (NSString *)xiaoqutype{
    if (_xiaoqutype==nil) {
        _xiaoqutype=@"";
    }
    return _xiaoqutype;
}

- (NSNumber *)catid{
    if (_catid==nil) {
        _catid=@-1;
    }
    return _catid;
}
- (NSNumber *)ID{
    if (_ID==nil) {
        _ID=@-1;
    }
    return _ID;
}
@end
