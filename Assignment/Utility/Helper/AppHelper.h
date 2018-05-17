//
//  AppHelper.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface AppHelper : NSObject

+(void)showAlert:(UIViewController*)controller title:(NSString*)title message:(NSString*)message;

+(BOOL)isEmpty:(NSString*)string;

+(UIImage*)resizeImage:(UIImage*)image size:(CGFloat)size;

@end
