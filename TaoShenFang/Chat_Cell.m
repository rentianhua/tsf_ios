//
//  Chat_Cell.m
//  Chat_V
//
//  Created by BOBO on 16/12/2.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import "Chat_Cell.h"
#import "OtherHeader.h"
#import <UIImageView+WebCache.h>

#define CELL_MARGIN_TB     10.0
#define CELL_MARGIN_L      56.0 // 距离有头像那边
#define CELL_TAIL_WIDTH    16
#define CELL_CORNER        18
#define CELL_PADDINHG      8

#define IMAGE_WIDTH        40.0 // 头像宽度
#define IMAGE_MARGIN_L     10.0 // 距离边框

#define MAX_WIDES_OF_TEXT  200 // 聊天内容区域



@implementation Chat_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {//视图添加先后的问题.
        [self.contentView addSubview:self.popImageView];
        [self.contentView addSubview:self.popLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}
- (void)setChat_M:(Chat_Model *)chat_M{
    _chat_M = chat_M;
    
    if ([chat_M.from_uid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"]]) {
        chat_M.fromMe=YES;
    } else{
        chat_M.fromMe=NO;
    }
    self.popLabel.text = chat_M.content;//赋值
    if (chat_M.fromMe) {
        // 右边气泡
        self.popLabel.textColor = [UIColor whiteColor];
        self.popImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNER + 10, CELL_CORNER + CELL_TAIL_WIDTH, CELL_CORNER, CELL_CORNER)];//拉伸图片
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[chat_M.inputtime integerValue]];
        
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        self.timeLabel.text=confromTimespStr;
        self.timeLabel.font=[UIFont systemFontOfSize:10];
        self.timeLabel.textColor=DESCCOL;
        
        // 1.文本frame textRectForBounds:limitedToNumberOfLines:
        // 用来改变label里面文字展示窗口的大小，根据文字的多少，来计算窗口的大小
        CGRect rectOfText = [self.popLabel textRectForBounds:CGRectMake(0, 0, MAX_WIDES_OF_TEXT, 999) limitedToNumberOfLines:0];
        CGRect frameOfLabel = CGRectZero;
        frameOfLabel.size = rectOfText.size;
        frameOfLabel.origin.x = self.bounds.size.width - CELL_MARGIN_L - CELL_TAIL_WIDTH - CELL_PADDINHG - rectOfText.size.width;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDINHG+21;
        self.popLabel.frame = frameOfLabel;
        
        // 2.气泡frame
        CGRect frameOfImageView = self.popLabel.frame;
        frameOfImageView.origin.x -= CELL_PADDINHG + 10;
        frameOfImageView.origin.y = CELL_MARGIN_TB+21;
        frameOfImageView.size.width += 2 * CELL_PADDINHG + CELL_TAIL_WIDTH + 5;
        frameOfImageView.size.height += 2 * CELL_PADDINHG + 8;
        self.popImageView.frame = frameOfImageView;
        
        // 3.titileImageView
        CGRect frameOfTitleImage = self.bounds;
        frameOfTitleImage.size = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
        frameOfTitleImage.origin.x = self.bounds.size.width - IMAGE_MARGIN_L - IMAGE_WIDTH;
        frameOfTitleImage.origin.y = CELL_MARGIN_TB+21;
        self.iconImageView.frame = frameOfTitleImage;
        self.iconImageView.layer.masksToBounds=YES;
        self.iconImageView.layer.cornerRadius=IMAGE_WIDTH*0.5;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",NSUSER_DEF(USERINFO)[@"userpic"]]] placeholderImage:[UIImage imageNamed:@"myhome_icon_avatar"]];
        //[UIImage imageNamed:@"me"];
        
        
        CGRect timeFrame=CGRectMake((kMainScreenWidth-120)*0.5, 0, 120, 21);
        self.timeLabel.frame=timeFrame;
        
        // cell bounds
        CGRect bounds = self.bounds;
        bounds.size.height = frameOfImageView.size.height + 2 * CELL_MARGIN_TB + timeFrame.size.height;
        self.bounds = bounds;
        
    } else {
        // 左边气泡
        self.popLabel.textColor = [UIColor darkGrayColor]; //
        self.popImageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNER + 10, CELL_CORNER + CELL_TAIL_WIDTH, CELL_CORNER, CELL_CORNER)]; //
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[chat_M.inputtime integerValue]];
        
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        self.timeLabel.text=confromTimespStr;
        self.timeLabel.font=[UIFont systemFontOfSize:10];
        self.timeLabel.textColor=DESCCOL;

        
        // 1.文本frame
        CGRect rectOfText = [self.popLabel textRectForBounds:CGRectMake(0, 0, MAX_WIDES_OF_TEXT, 999) limitedToNumberOfLines:0];
        CGRect frameOfLabel = CGRectZero;
        frameOfLabel.size = rectOfText.size;
        frameOfLabel.origin.x = CELL_MARGIN_L + CELL_TAIL_WIDTH + CELL_PADDINHG; //
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDINHG+21;
        self.popLabel.frame = frameOfLabel;
        
        // 2.气泡frame
        CGRect frameOfImageView = self.popLabel.frame;
        frameOfImageView.origin.x = CELL_MARGIN_L + 5;
        frameOfImageView.origin.y = CELL_MARGIN_TB+21;
        frameOfImageView.size.width += 2 * CELL_PADDINHG + CELL_TAIL_WIDTH + 5;
        frameOfImageView.size.height += 2 * CELL_PADDINHG + 8;
        self.popImageView.frame = frameOfImageView;
        
        // 3.titileImageView
        CGRect frameOfTitleImage = self.bounds;
        frameOfTitleImage.size = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
        frameOfTitleImage.origin.x = IMAGE_MARGIN_L;
        frameOfTitleImage.origin.y = CELL_MARGIN_TB+21;
        self.iconImageView.frame = frameOfTitleImage;
        self.iconImageView.layer.masksToBounds=YES;
        self.iconImageView.layer.cornerRadius=IMAGE_WIDTH*0.5;
        if ([chat_M.from_uid isEqualToString:@"0"]) {
            self.iconImageView.image=[UIImage imageNamed:@"message_xt"];
        } else{
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",chat_M.userpic]] placeholderImage:[UIImage imageNamed:@"myhome_icon_avatar"]];
        }
        
        CGRect timeFrame=CGRectMake((kMainScreenWidth-120)*0.5, 0, 120, 21);
        self.timeLabel.frame=timeFrame;
        
        CGRect bounds = self.bounds;
        bounds.size.height = frameOfImageView.size.height + 2 * CELL_MARGIN_TB+timeFrame.size.height;
        self.bounds = bounds;
    }
}

#pragma mark - get


- (UIImageView *)popImageView {
    if (!_popImageView) {
        _popImageView = [[UIImageView alloc] init];
    }
    return _popImageView;
}

- (UILabel *)popLabel {
    if (!_popLabel) {
        _popLabel = [[UILabel alloc] init];
        _popLabel.numberOfLines = 0;
    }
    return _popLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel{
    if (_timeLabel==nil) {
        _timeLabel=[[UILabel alloc]init];
    }
    return _timeLabel;
}

@end
