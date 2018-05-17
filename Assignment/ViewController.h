//
//  ViewController.h
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *arrayFacts;

@end

