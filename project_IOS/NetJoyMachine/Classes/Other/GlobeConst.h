//
//  GlobeConst.h
//  MyBSBuDeJie
//
//  Created by admin on 16/3/18.
//  Copyright © 2016年 MJ. All rights reserved.
//

#pragma mark 字体大小

//大标题
#define MJBigTitleFont  FontSize(12,14,15) // 28px

#define MJBigTitleFontSize Size(12,14,15)

#define MJBlodTitleFont  BlodFontSize(12,14,15) //



//中标题
#define MJMiddleTitleFont  FontSize(11,13,14) // 28px

#define MJMiddleTitleFontSize Size(11,13,14)

#define MJBlodMiddleTitleFont  BlodFontSize(11,13,14) //


//小标题
#define MJSmallTitleFont  FontSize(10,11,12) //

#define MJSmallTitleFontSize Size(10,11,12)

#define MJBlodSmallTitleFont  BlodFontSize(10,11,12) //


//大正文
#define MJBigBobyFont  FontSize(11,13,14) //

#define MJBigBobyFontSize Size(11,13,14)

#define MJBlodBigBobyFont  BlodFontSize(11,13,14) //



//中正文
#define MJMiddleBobyFont  FontSize(10,12,13) //

#define MJMiddleBobyFontSize Size(10,12,13)

#define MJBlodMiddleBobyFont  BlodFontSize(10,12,13) //

//正文小字体
#define MJSmallBobyFont  FontSize(9,11,12) // 28px

#define MJSmallBobyFontSize Size(9,11,12)

#define MJBlodSmallBobyFont  BlodFontSize(9,11,12) //

//附属小字体
#define MJOtherSmallFont  FontSize(9,10,11) // 28px

#define MJOtherSmallFontSize Size(9,10,11)

#define MJBlodOtherSmallFont  BlodFontSize(9,10,11) //


#define Size(five,six,sixP) [NSString MJ_getCurrentFontSizeWith5S:five With6S:six With6P:sixP]

#define FontSize(five,six,sixP) [UIFont systemFontOfSize:Size(five,six,sixP)]

#define BlodFontSize(five,six,sixP) [UIFont fontWithName:@"Helvetica-Bold" size:Size(five,six,sixP)]

//字体颜色
#define MJHexStrColor(HexStr,alphaValue) [UIColor colorWithHexString:HexStr alpha:alphaValue]

#define MJWhiteColor MJHexStrColor(@"ffffff",1.0)

#define MJBlackColor MJHexStrColor(@"333333",1.0)

#define MJGrayColor MJHexStrColor(@"666666",1.0)

#define MJLittleGrayColor MJHexStrColor(@"999999",1.0)

#define MJEBGrayColor MJHexStrColor(@"EBEBEB",1.0)

#define MJMinGrayColor MJHexStrColor(@"F7F7F7",1.0)

#define MJLittleRedColor MJHexStrColor(@"F9303B",1.0)

#define MJMainRedColor MJHexStrColor(@"ed7575",1.0)

#define MJMainGrayColor MJHexStrColor(@"E6E6E6",1.0)

#define MJBlueColor MJHexStrColor(@"5AD5D8",1.0)


#pragma mark- (键盘的高度)
//ChatKeyBoard背景颜色
#define kChatKeyBoardColor              [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f]

//键盘上面的工具条
#define kChatToolBarHeight              49

//表情模块高度
#define kFacePanelHeight                216
#define kFacePanelBottomToolBarHeight   40
#define kUIPageControllerHeight         25

//拍照、发视频等更多功能模块的面板的高度
#define kMorePanelHeight                216
#define kMoreItemH                      80
#define kMoreItemIconSize               60


//整个聊天工具的高度
#define kChatKeyBoardHeight     kChatToolBarHeight + kFacePanelHeight


/** UITabBar的高度 */
#define  MJTabBarH    (iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  MJ_TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)

/** 视图安全区域 */
#define MJ_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define  MJSafeAreButtomH    (iPhoneX ? 34.f : 0.0f)


/** 状态栏的高度 */
#define  MJTitlesViewH   (iPhoneX ? 44.f : 20.f)

/** 导航栏的最大Y */
#define  MJNavMaxY  (iPhoneX ? 88.f : 64.f)

/** 当前日期 */
UIKIT_EXTERN NSString * const Date_NowDate;

/** 键盘的高度 */
UIKIT_EXTERN CGFloat const MJKeyboardH;

/** 通用的上下间距 */
UIKIT_EXTERN CGFloat const MJUPDownMargin;

/** 通用的中间间距 */
UIKIT_EXTERN CGFloat const MJMiddleMargin;

/** 通用的左右间距 */
UIKIT_EXTERN CGFloat const MJRLMargin;

/** 顶部更多cell高度 */
UIKIT_EXTERN CGFloat const MJHeaderMarginHeight;

#pragma mark- (评论内容中间距参数)

/** 评论更多cell高度 */
UIKIT_EXTERN CGFloat const ComplainMargin;

/** 通用的中间间距 */
UIKIT_EXTERN CGFloat const ComplainMiddleMargin;


/** 通用的左右间距 */
UIKIT_EXTERN CGFloat const ComplainRLMargin;


/** 头像的高宽 */
UIKIT_EXTERN CGFloat const ComplainIconWH;


/** 通用的上下间距 */
UIKIT_EXTERN CGFloat const ComplainUPDownMargin;

// 字符串切割字符串
UIKIT_EXTERN NSString const *ImgName_SubStr;

// 字符串切割字符串
UIKIT_EXTERN NSString const *ImgSize_SubStr;

#pragma mark- (评论中LLabel参数)

/** 行数 */
UIKIT_EXTERN NSInteger const CommentNumLines;

/** 行高倍数 */
UIKIT_EXTERN CGFloat const CommentLineHMultiple;

#define CommentstextInsets UIEdgeInsetsMake(0, 0, 0, 0)


#pragma mark-- 遮罩尺寸

//个人信息和收费
#define YRAlert_Relative_Width (MJScreenW * 0.8)

#define YRAlert_Relative_Height (YRAlert_Relative_Width * 1.2)

#define YRAlert_Relative_FontSize FontSize(15,16,18)

//兑换等小的弹框
#define YRAlert_Coin_Small_Width (MJScreenW * 0.8)

#define YRAlert_Coin_Small_Height (YRAlert_Coin_Small_Width * 0.6)

//普通cell的圆角大小
UIKIT_EXTERN CGFloat const MJcommonCornerRadius;

/***********************用户信息偏好保存*******************/
#define UserDefault_AllUserInfoKey @"userDefault_AllUserInfoKey"

// 用户电话
#define UserDefault_UserPhoneKey @"userDefault_UserPhoneKey"

// 用户登录名
#define UserDefault_LoginNameKey @"userDefault_LoginNameKey"

//用户密码
#define UserDefault_UserPwdKey @"UserDefault_UserPwdKey"

//主页segmentBar
#define MainPage_ListBarKey @"MainPage_ListBarKey"

//用户userID
#define UserDefault_UserID @"UserDefault_UserID"

//用户Access_token
#define UserDefault_User_Access_Token @"UserDefault_User_Access_Token"

//token过期时间
#define UserDefault_User_Access_Token_Time @"UserDefault_User_Access_Token_Time"

//通知

/** 界面跳转的通知 */
UIKIT_EXTERN NSString * const MJUploadBtnClickNotification;

/** 主页跑马灯运动通知*/
UIKIT_EXTERN NSString * const YRMainPageAdvChangeNotification;


#pragma mark- (网络请求)
static NSTimeInterval MJ_timeout = 15.0f;
#define UploadTimeout 120.0f // 上传请求的时限


#pragma mark 提示语 & HUD
// HUD显示文字
#define AlertTitle @"温馨提示"
#define Cancel @"取消"
#define Confirm @"确定"
#define Certificated @"认证"
#define Refresh @"刷新"
#define YR_Hint_Refreshing @"稍等,拼命刷新中~"
#define YR_Hint_RefreshSuccess @"稍等,拼命刷新中~"

#pragma mark-- 占位图片名字
UIKIT_EXTERN NSString *GoodsDetail_placeholderImage;



