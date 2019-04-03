//
//  UIViewController+YRUMShared.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/27.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface UIViewController (YRUMShared)

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType andShardText:(NSString *)sharedText;

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType andThumbImg:(UIImage *)thumbImg andShareImg:(UIImage *)sharedImg;

//分享网络图片
- (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType andThumbImgUrl:(NSString *)thumbUrl andSharedImgUrl:(NSString *)sharedImgUrl;

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType andSharedText:(NSString *)sharedText andThumbImgUrl:(NSString *)thumbUrl andSharedImgUrl:(NSString *)sharedImgUrl;

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andThumbURL:(NSString *)thumbUrl andWebpageUrl:(NSString *)pageUrl andSharedTitile:(NSString *)sharedTitle andDescr:(NSString *)descriText;


@end
