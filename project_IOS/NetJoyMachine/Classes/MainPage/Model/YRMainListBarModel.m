//
//  YRMainListBarModel.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/4.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMainListBarModel.h"
#import <MJExtension.h>

@implementation YRMainListBarModel

@end

@implementation YRAdvBarModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isEqual:[NSNull null]])
    {
        return @"";
    }
    else{
        return oldValue;
    };
}

@end



