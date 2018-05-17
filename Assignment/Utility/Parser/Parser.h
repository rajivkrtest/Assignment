//
//  Parser.h
//  Assignment
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+ (id)shared;

-(void)parse:(NSData*)data completion:(void (^)(NSString *title, NSArray* rows, BOOL isError))completionHandler;

@end
