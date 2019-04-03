//
//  YRMainListBarModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/4.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

//选项卡内容
@interface YRMainListBarModel : YRBaseDataModel

@property (nonatomic, strong) NSString *ID;

//bar名称
@property (nonatomic, strong) NSString *name;

//是否需要广告轮播图
@property (nonatomic, strong) NSString *status;

//当前对应的列表请求数据的类型
@property (nonatomic, strong) NSString *type;

@end

//广告Bar
@interface YRAdvBarModel : YRBaseDataModel

//图片url
@property (nonatomic, strong) NSString *picUrl;

@property (nonatomic, strong) NSString *ID;

//跳转的url
@property (nonatomic, strong) NSString *redirectUrl;

//广告图描述
@property (nonatomic, strong) NSString *desc;


@end

