//
//  Row.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Row : NSObject

@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * imageHref;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIImage *icon;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end

