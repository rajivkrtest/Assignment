//
//  AppHelper.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

//Function to show the Alert on controller
//controller: Pass the current view controller to display alert
//title: Show the alert title
//message: Show the alert message
+(void)showAlert:(UIViewController*)controller title:(NSString*)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    [controller presentViewController:alert animated:YES completion:nil];
}

//Function to check the empty string
+(BOOL)isEmpty:(NSString*)string {
    if(string == (id) [NSNull null] ||
       [string length] == 0 ||
       [string isEqualToString:@""] ||
       [string isEqualToString:@"(null)"] ||
       [string isEqualToString:@"<null>"]) {
        return TRUE;
    }
    return FALSE;
}

//Function to resize the image
//image: Source Image
//size: Width of the image
+(UIImage*)resizeImage:(UIImage*)image size:(CGFloat)size {
    CGSize itemSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
