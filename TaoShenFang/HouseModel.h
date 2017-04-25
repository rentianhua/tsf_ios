//
//  HouseModel.h
//  TaoShenFangTest
//
//  Created by YXM on 16/8/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSFTradesModel;
@class TSFHtmlModel;

@interface HouseModel : NSObject
@property (nonatomic,strong)NSNumber *ID;//
@property (nonatomic,strong)NSNumber *catid;
@property (nonatomic,strong)NSNumber *typeID;//
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *style;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,strong)NSNumber *status;
@property (nonatomic,copy)NSString *zongjia;

@property (nonatomic,strong)NSArray *weizhitu;//位置图
@property (nonatomic,strong)NSArray *yangbantu;//样板图
@property (nonatomic,strong)NSArray *shijingtu;//实景图
@property (nonatomic,strong)NSArray *xiaoqutu;//小区图

@property (nonatomic,copy)NSString *shi;
@property (nonatomic,copy)NSString *ting;
@property (nonatomic,copy)NSString *wei;
@property (nonatomic,copy)NSString *chu;
@property (nonatomic,copy)NSString *yangtai;
@property (nonatomic,copy)NSString *huxing;
@property (nonatomic,copy)NSString *ceng;
@property (nonatomic,copy)NSString *zongceng;
@property (nonatomic,copy)NSString *louceng;
@property (nonatomic,copy)NSString *zhuangxiu;
@property (nonatomic,copy)NSString *chaoxiang;
@property (nonatomic,copy)NSString *jiegou;
@property (nonatomic,copy)NSString *dianti;

@property (nonatomic,copy)NSString *fukuanfangshi;
@property (nonatomic,copy)NSString *huxingintro;
@property (nonatomic,copy)NSString *liangdian;
@property (nonatomic,copy)NSString *biaoqian;

@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *area;


@property (nonatomic,copy)NSString *provincename;
@property (nonatomic,copy)NSString *cityname;
@property (nonatomic,copy)NSString *areaname;

@property (nonatomic,copy)NSString *isxuequ;
@property (nonatomic,copy)NSString *ditiexian;
@property (nonatomic,copy)NSString *descrip;
@property (nonatomic,copy)NSString *fangling;
@property (nonatomic,copy)NSString *leixing;
@property (nonatomic,copy)NSString *jingweidu;
@property (nonatomic,copy)NSString *province_name;
@property (nonatomic,copy)NSString *city_name;
@property (nonatomic,copy)NSString *area_name;

@property (nonatomic,copy)NSString *zulin;//租赁方式
@property (nonatomic,copy)NSString *xiaoqu;
@property (nonatomic,copy)NSString *bianhao;
@property (nonatomic,copy)NSString *guapaidate;
//租房
@property (nonatomic,copy)NSString *mianji;//租房
@property (nonatomic,copy)NSString *zujin;//租房
@property (nonatomic,copy)NSString *address;//租房 二手房
@property (nonatomic,copy)NSString *jiaoyiquanshu;//物业类型
//新房列表
@property (nonatomic,copy)NSString *loupandizhi;//新房特有
@property (nonatomic,copy)NSString *zhandimianji;//新房特有

@property (nonatomic,copy)NSString *junjia;//新房特有
@property (nonatomic,copy)NSString *jianzhumianji;//二手房详情 新房详情
@property (nonatomic,copy)NSString *hexinmaidian;//核心卖点
@property (nonatomic,copy)NSString *jiaotong;//交通出行
@property (nonatomic,copy)NSString *contacttel;//联系方式

@property (nonatomic,strong)id pics;//二手房 租房

@property (nonatomic,strong)NSArray * loupantupian;//新房

@property (nonatomic,copy)NSString *fangwuyongtu;//新房

@property (nonatomic,copy)NSString *hezuofangshi;//合作方式
@property (nonatomic,copy)NSString *contactname;//联系人
@property (nonatomic,copy)NSString *wuyetype;//物业类型
@property (nonatomic,copy)NSString *updatetime;//更新时间
@property (nonatomic,copy)NSString *shiyongnianxian;//使用年限
@property (nonatomic,copy)NSString *goudijine;//勾地金额

@property (nonatomic,copy)NSString *kaipandate;
@property (nonatomic,copy)NSString *jiaofangdate;
@property (nonatomic,copy)NSString *inputtime;
@property (nonatomic,copy)NSString *kaifashang;
@property (nonatomic,copy)NSString *jianzhutype;
@property (nonatomic,copy)NSString *jianzhuleixing;
@property (nonatomic,copy)NSString *chanquannianxian;
@property (nonatomic,copy)NSString *guihuahushu;
@property (nonatomic,copy)NSString *guihuachewei;
@property (nonatomic,copy)NSString *rongjilv;
@property (nonatomic,copy)NSString *lvhualv;
@property (nonatomic,copy)NSString *wuyefei;

@property (nonatomic,copy)NSString *loupandongtai;
@property (nonatomic,copy)NSArray *dongtai;

@property (nonatomic,strong)NSNumber *jjr_id;//是否是经纪人发布
@property (nonatomic,copy)NSString *username;//被预约者

@property (nonatomic,copy)NSString *zhulihuxing;

@property (nonatomic,copy)NSString *xiaoquname;
@property (nonatomic,copy)NSString *mianjiarea;
@property (nonatomic,copy)NSString *wuyeleixing;

@property (nonatomic,copy)NSString *loudong;
@property (nonatomic,copy)NSString *menpai;

@property (nonatomic,copy)NSString *shuxing;
@property (nonatomic,copy)NSString *diyaxinxi;
@property (nonatomic,copy)NSString *jianzhujiegou;
@property (nonatomic,copy)NSString *tihubili;
@property (nonatomic,copy)NSString *chanquansuoshu;
@property (nonatomic,copy)NSString *isweiyi;
@property (nonatomic,copy)NSString *taoneimianji;
@property (nonatomic,copy)NSString *touzifenxi;
@property (nonatomic,copy)NSString *xiaoquintro;
@property (nonatomic,copy)NSString *shuifeijiexi;
@property (nonatomic,copy)NSString *zxdesc;
@property (nonatomic,copy)NSString *shenghuopeitao;
@property (nonatomic,copy)NSString *xuexiaomingcheng;
@property (nonatomic,copy)NSString *xiaoquyoushi;
@property (nonatomic,copy)NSString *quanshudiya;
@property (nonatomic,copy)NSString *yezhushuo;
@property (nonatomic,copy)NSString *desc;

@property (nonatomic,copy)NSString *curceng;
//发布
@property (nonatomic,copy)NSString *modelid;
@property (nonatomic,copy)NSString *userid;

@property (nonatomic,copy)NSString *czreason;

@property (nonatomic,copy)NSString *fukuan;
@property (nonatomic,copy)NSString *fangwupeitao;

//上传的图片  发布房源
@property (nonatomic,strong)NSArray * uploadImgs;

@property (nonatomic,copy)NSString *chuzutype;
@property (nonatomic,copy)NSString *paytype;

@property (nonatomic,copy)NSString *shiarea;

@property (nonatomic,copy)NSString *chenghu;
@property (nonatomic,copy)NSString *pub_type;
@property (nonatomic,copy)NSString *hidetel;

@property (nonatomic,copy)NSString *zujinrange;

@property (nonatomic,copy)NSString *zongjiarange;

@property (nonatomic,copy)NSString *contract;//合同上传
@property (nonatomic,copy)NSString *idcard;//身份证上传

@property (nonatomic,strong)NSNumber *lock;//是否锁定

@property (nonatomic,copy)NSString *shangcijiaoyi;

@property (nonatomic,strong)NSArray *daikan;

@property (nonatomic,strong)NSArray *tongqu;

@property (nonatomic,copy)NSString *zaishou;

@property (nonatomic,strong)NSArray *yhq;
@property (nonatomic,copy)NSString *yhq_buyer_count;
@property (nonatomic,copy)NSString *hasyhq;


@property (nonatomic,copy)NSString *shuidianranqi;
@property (nonatomic,copy)NSString *wuyegongsi;

@property (nonatomic,copy)NSString *dafen_zbpt;
@property (nonatomic,copy)NSString *dafen_jt;
@property (nonatomic,copy)NSString *dafen_hj;
@property (nonatomic,copy)NSString *dianping;

@property (nonatomic,strong)TSFHtmlModel *html;


@property (nonatomic,strong)TSFTradesModel *fubiao;

@property (nonatomic,copy)NSString *tudishuxing;
@property (nonatomic,copy)NSString *hasgd;

@property (nonatomic,copy)NSString *apply_state;

@property (nonatomic,copy)NSString *zonghe;

@property (nonatomic,copy)NSString *vtel;

@property (nonatomic,copy)NSString *danyuan;

@property (nonatomic,copy)NSString * zaizu;

@property (nonatomic,copy)NSString * huxingjieshao;

@property (nonatomic,copy)NSString *xiaoqutype;
@end
