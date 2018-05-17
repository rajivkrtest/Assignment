//
//  Parser.m
//  Assignment
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "Parser.h"
#import "FactsResponse.h"

@implementation Parser

+ (id)shared
{
    static Parser *parser = nil;
    @synchronized(self) {
        if (parser == nil)
            parser = [[self alloc] init];
    }
    return parser;
}

-(void)parse:(NSData*)data completion:(void (^)(NSString *title, NSArray* rows, BOOL isError))completionHandler {
    //Need to convert data into string because WS data is in NSASCIIStringEncoding format
    //and NSJSONSerialization will expect NSUTF8StringEncoding format
    NSString *cr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSASCIIStringEncoding];
    // This converts the string to an NSData object
    NSData *dataUTF8 = [cr dataUsingEncoding:NSUTF8StringEncoding];
    // convert to an object
    NSError * jsonError;
    NSDictionary * jsonObject = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:dataUTF8
                                                                                options:NSJSONReadingAllowFragments
                                                                                  error: &jsonError];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (jsonObject != nil) {
            FactsResponse *factsResponse = [[FactsResponse alloc] initWithDictionary:jsonObject];
            completionHandler(factsResponse.title, factsResponse.rows, FALSE);
        }
        else {
            if (completionHandler != nil){
                completionHandler(nil, nil, TRUE);
            }
        }
    });
}
@end
