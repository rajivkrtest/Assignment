//
//  WebserviceRequest.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "WebserviceRequest.h"
#import "Reachability.h"
#import "AppHelper.h"
#import "Parser.h"

#define kEndpointURL @"https://dl.dropboxusercontent.com"

@implementation WebserviceRequest

+ (id)shared
{
    static WebserviceRequest *request = nil;
    @synchronized(self) {
        if (request == nil)
            request = [[self alloc] init];
    }
    return request;
    
}
//Check the network is reachable or not
-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

//Call the list of facts from WS
-(void)callFacts:(void (^)(NSString *title, NSArray* rows, NSError *err))completion errorHandler:(void (^)(NSError *err))error {
    //Check if network is Reachable
    if([self reachable]) {
        //https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json
        NSString *resource = @"/s/2iodh4vg0eortkl/facts.json";
        //Append the resource URL to Endpoint URL
        //It will help to write the generic methods
        //It will help to change the Endpoint URL for different environments (Staging, Testing, Production, etc)
        NSString *stringURL = [kEndpointURL stringByAppendingString:resource];
        NSURL *url = [NSURL URLWithString:stringURL];
        
        if (IS_OS_7_OR_LATER) {
            //NSURLConnection is deprecated - Use NSURLSession (More flexibility for background operations)
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //If data is Nil then throw error
                if (data != nil) {
                    [[Parser shared] parse:data completion:^(NSString *title, NSArray *rows, BOOL isError) {
                        if (isError == TRUE) {
                            NSError *error = [NSError errorWithDomain:kEndpointURL code:404 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No Records Found", NSLocalizedDescriptionKey, nil]];
                            if (completion != nil) {
                                completion(nil, nil, error);
                            }

                        }
                        else {
                            if (completion != nil) {
                                completion(title, rows, nil);
                            }
                        }
                    }];
                }
                else {

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        NSError *error = [NSError errorWithDomain:kEndpointURL code:404 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No Records Found", NSLocalizedDescriptionKey, nil]];
                        if (completion != nil){
                            completion(nil, nil, error);
                        }
                    });
                }
                [session finishTasksAndInvalidate];
            }];
            [task resume];
        }
        else {//Fallback to NSURLConnection
            
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 if ([data length] > 0 && error == nil) {
                     
                     [[Parser shared] parse:data completion:^(NSString *title, NSArray *rows, BOOL isError) {
                         if (isError == TRUE) {
                             NSError *error = [NSError errorWithDomain:kEndpointURL code:404 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No Records Found", NSLocalizedDescriptionKey, nil]];
                             if (completion != nil) {
                                 completion(nil, nil, error);
                             }
                             
                         }
                         else {
                             if (completion != nil) {
                                 completion(title, rows, nil);
                             }
                         }
                     }];
                     
                 }
                 else if ([data length] == 0 && error == nil) {
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         NSError *error = [NSError errorWithDomain:kEndpointURL code:404 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No Records Found", NSLocalizedDescriptionKey, nil]];
                         if (completion != nil){
                             completion(nil, nil, error);
                         }
                     });
                     
                 }
                 else if (error != nil) {
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         completion(nil, nil, error);
                     });
                 }
             }];
#pragma GCC diagnostic pop
        }
    }
    else{
        if (error != nil){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                error([NSError errorWithDomain:kEndpointURL code:404 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"There is no Internet connection.", NSLocalizedDescriptionKey, nil]]);
            });
        }
    }
}


@end
