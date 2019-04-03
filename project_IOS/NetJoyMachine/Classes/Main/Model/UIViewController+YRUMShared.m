//
//  UIViewController+YRUMShared.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/27.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "UIViewController+YRUMShared.h"

#import "UIAlertView+WX.h"

@implementation UIViewController (YRUMShared)

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType andShardText:(NSString *)sharedText
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = sharedText;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {

        if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
            }else{
                    UMSocialLogInfo(@"response data is %@",data);
            }
        }
            [self alertWithError:error];

    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType andThumbImg:(UIImage *)thumbImg andShareImg:(UIImage *)sharedImg
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = thumbImg;
    
    [shareObject setShareImage:sharedImg];
    
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
        if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
        
}
     
- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                                @"app_name": @"U-Share",
                                @"suggested_board_name": @"UShareProduce",
                                @"description": @"U-Share: best social bridge"};
}

     
//分享网络图片
     - (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType andThumbImgUrl:(NSString *)thumbUrl andSharedImgUrl:(NSString *)sharedImgUrl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbUrl;
        
    [shareObject setShareImage:sharedImgUrl];
        
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
        
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
        
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
        
#ifdef UM_Swift
        [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
         
//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType andSharedText:(NSString *)sharedText andThumbImgUrl:(NSString *)thumbUrl andSharedImgUrl:(NSString *)sharedImgUrl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
    //设置文本
    messageObject.text = sharedText;
            
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    if (platformType == UMSocialPlatformType_Linkedin) {
        // linkedin仅支持URL图片
        shareObject.thumbImage = thumbUrl;
        [shareObject setShareImage:sharedImgUrl];
    } else {
        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        shareObject.shareImage = [UIImage imageNamed:@"logo"];
    }
            
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
            
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
        if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                            //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                            
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
             
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andThumbURL:(NSString *)thumbUrl andWebpageUrl:(NSString *)pageUrl andSharedTitile:(NSString *)sharedTitle andDescr:(NSString *)descriText
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
    //创建网页内容对象
    NSString* thumbURL =  thumbUrl;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sharedTitle descr:descriText thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = pageUrl;
                
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
                
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
    if (error) {
        UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
        UMSocialShareResponse *resp = data;
        //分享结果消息
        UMSocialLogInfo(@"response message is %@",resp.message);
                                //第三方原始返回的数据
                                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                
        }else{
            UMSocialLogInfo(@"response data is %@",data);
        }
    }
    [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}
     

     
     
@end
