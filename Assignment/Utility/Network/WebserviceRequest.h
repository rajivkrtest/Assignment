//
//  WebserviceRequest.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebserviceRequest : NSObject

+ (id)shared;

-(void)callFacts:(void (^)(NSString *title, NSArray* rows, NSError *err))completion errorHandler:(void (^)(NSError *err))error;

@end
