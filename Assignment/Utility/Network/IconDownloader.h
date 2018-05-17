//
//  IconDownloader.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIconSize 75

@class Row;

@interface IconDownloader : NSObject

@property (nonatomic, strong) Row *row;

@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;

- (void)cancelDownload;

@end
