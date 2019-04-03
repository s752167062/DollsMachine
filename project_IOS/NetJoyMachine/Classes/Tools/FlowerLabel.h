//
//  FlowerLabel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/15.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerLabel : UILabel

/**
 *    @brief    Outline Color
 */
@property (nonatomic, retain) IBInspectable UIColor *outlineColor;
/**
 *    @brief    Outline Width
 */
@property (nonatomic, assign) IBInspectable CGFloat outlineWidth;

@end
