//
//  FactsResponse.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "FactsResponse.h"
NSString *const kFactsResponseRows = @"rows";
NSString *const kFactsResponseTitle = @"title";

@interface FactsResponse ()
@end

@implementation FactsResponse
/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(dictionary[kFactsResponseRows] != nil && [dictionary[kFactsResponseRows] isKindOfClass:[NSArray class]]){
        NSArray * rowsDictionaries = dictionary[kFactsResponseRows];
        NSMutableArray * rowsItems = [NSMutableArray array];
        for(NSDictionary * rowsDictionary in rowsDictionaries){
            Row * rowsItem = [[Row alloc] initWithDictionary:rowsDictionary];
            [rowsItems addObject:rowsItem];
        }
        self.rows = rowsItems;
    }
    if(![dictionary[kFactsResponseTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kFactsResponseTitle];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.rows != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(Row * rowsElement in self.rows){
            [dictionaryElements addObject:[rowsElement toDictionary]];
        }
        dictionary[kFactsResponseRows] = dictionaryElements;
    }
    if(self.title != nil){
        dictionary[kFactsResponseTitle] = self.title;
    }
    return dictionary;
    
}
@end
