//
//  YRLoginUserModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/1.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

@interface YRLoginUserModel : YRBaseDataModel

//@property (nonatomic, strong) NSString *birthday;
//
//@property (nonatomic, strong) NSString *note;
//
//@property (nonatomic, strong) NSString *gender;
//
//@property (nonatomic, strong) NSString *address;
//
//@property (nonatomic, strong) NSString *smallIconUrl;
//
//@property (nonatomic, strong) NSString *locale1;
//
//@property (nonatomic, strong) NSString *locale2;
//
//@property (nonatomic, strong) NSString *locale3;
//
//@property (nonatomic, strong) NSString *phone;
//
//@property (nonatomic, strong) NSString *nickname;
//
//@property (nonatomic, strong) NSString *iconUrl;
//
//@property (nonatomic, assign) NSInteger age;
//
//@property (nonatomic, strong) NSString *ID;
//
//@property (nonatomic, strong) NSString *email;

@property (nonatomic, copy) NSString *uid;

//名字
@property (nonatomic, copy) NSString *name;

//性别
@property (nonatomic, copy) NSString *gender;

//头像
@property (nonatomic, copy) NSString *iconurl;



@end
