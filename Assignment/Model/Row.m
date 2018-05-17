//
//  Row.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "Row.h"

NSString *const kRowDescriptionField = @"description";
NSString *const kRowImageHref = @"imageHref";
NSString *const kRowTitle = @"title";

@interface Row ()
@end
@implementation Row

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRowDescriptionField] isKindOfClass:[NSNull class]]){
        self.descriptionField = dictionary[kRowDescriptionField];
    }
    if(![dictionary[kRowImageHref] isKindOfClass:[NSNull class]]){
        self.imageHref = dictionary[kRowImageHref];
    }
    if(![dictionary[kRowTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kRowTitle];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.descriptionField != nil){
        dictionary[kRowDescriptionField] = self.descriptionField;
    }
    if(self.imageHref != nil){
        dictionary[kRowImageHref] = self.imageHref;
    }
    if(self.title != nil){
        dictionary[kRowTitle] = self.title;
    }
    return dictionary;
    
}

@end

