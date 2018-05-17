//
//  IconDownloader.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "IconDownloader.h"
#import "AppHelper.h"
#import "Row.h"

@interface IconDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

#pragma mark -
@implementation IconDownloader

- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.row.imageHref]];
    
    if (IS_OS_7_OR_LATER) {
        //Create an session data task to obtain and download the icon
        _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           //In case we want to know the response status code
                                                           //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                           if (error != nil){
                                                               NSLog(@"Error :: %@", error.localizedDescription);
                                                           }
                                                           
                                                           [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                               
                                                               // Set Icon and clear temporary data/image
                                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                                               
                                                               if (image != nil) {
                                                                   if (image.size.width != kIconSize || image.size.height != kIconSize) {
                                                                       self.row.icon = [AppHelper resizeImage:image size:kIconSize];
                                                                   }
                                                                   else {
                                                                       self.row.icon = image;
                                                                   }
                                                               }
                                                               // call our completion handler to tell our client that our icon is ready for display
                                                               if (self.completionHandler != nil)
                                                               {
                                                                   self.completionHandler();
                                                               }
                                                           }];
                                                       }];
        
        [self.sessionTask resume];

    }
    else {
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil) {
                 [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                     
                     // Set Icon and clear temporary data/image
                     UIImage *image = [[UIImage alloc] initWithData:data];
                     
                     if (image != nil) {
                         if (image.size.width != kIconSize || image.size.height != kIconSize) {
                             self.row.icon = [AppHelper resizeImage:image size:kIconSize];
                         }
                         else {
                             self.row.icon = image;
                         }
                     }
                     // call our completion handler to tell our client that our icon is ready for display
                     if (self.completionHandler != nil)
                     {
                         self.completionHandler();
                     }
                 }];
             }
             else if ([data length] == 0 && error == nil) {
                 NSLog(@"Error :: %@", error.localizedDescription);
                 
             }
             else if (error != nil) {
                 NSLog(@"Error :: %@", error.localizedDescription);
             }
         }];
#pragma GCC diagnostic pop
    }
}

- (void)cancelDownload {
    if (IS_OS_7_OR_LATER) {
        [self.sessionTask cancel];
        _sessionTask = nil;
    }
}

@end
