//
//  FactsResponse.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Row.h"

@interface FactsResponse : NSObject

@property (nonatomic, strong) NSArray * rows;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
