//
//  ViewController.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ViewController.h"
#import "WebserviceRequest.h"
#import "AppHelper.h"
#import "FactsResponse.h"
#import "TableViewCell.h"
#import "IconDownloader.h"

@interface ViewController ()

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.estimatedRowHeight = 100.0 ;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[left, top, bottom, right]];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setHidesWhenStopped:TRUE];
    [self.tableView addSubview:self.spinner];
    [self.spinner startAnimating];
    [self.spinner setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    NSDictionary *views = @{@"spinner":self.spinner,
                            @"superview":self.tableView
                            };
    //Align center to X
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[spinner]"
                                                                      options: NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];
    //Align center to Y
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[spinner]"
                                                                      options: NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    __weak ViewController *weakSelf = self;
    [[WebserviceRequest shared] callFacts:^(NSString *title, NSArray *rows, NSError *err) {
        [weakSelf.spinner stopAnimating];
        weakSelf.title = title;
        weakSelf.arrayFacts = rows;
        [weakSelf.tableView reloadData];
    } errorHandler:^(NSError *err) {
        [weakSelf.spinner stopAnimating];
        [AppHelper showAlert:weakSelf title:@"Error" message:err.localizedDescription];
    }];

    
}

//Pull to refresh the content of tableView
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [self terminateAllDownloads];
    [refreshControl beginRefreshing];
    
    __weak ViewController *weakSelf = self;
    [[WebserviceRequest shared] callFacts:^(NSString *title, NSArray *rows, NSError *err) {
                            weakSelf.title = title;
                            weakSelf.arrayFacts = nil;
                            weakSelf.arrayFacts = rows;
                            weakSelf.imageDownloadsInProgress = nil;
                            weakSelf.imageDownloadsInProgress = [NSMutableDictionary dictionary];
                            [weakSelf.tableView reloadData];
                            [refreshControl endRefreshing];
                        } errorHandler:^(NSError *err) {
                            [AppHelper showAlert:weakSelf title:@"Error" message:err.localizedDescription];
                            [weakSelf.tableView reloadData];
                            [weakSelf.refreshControl endRefreshing];
                            [weakSelf.tableView layoutIfNeeded];
                        }];
    
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayFacts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableViewCellIdentifier";
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Row *row = [self.arrayFacts objectAtIndex:indexPath.row];
    
    cell.imageHref.image = [UIImage imageNamed:@"noimage"];
    if (!row.icon) {
        [self startIconDownload:row forIndexPath:indexPath];
    }
    else {
        if (row.icon != nil) {
            cell.imageHref.image = row.icon;
        }
    }
    if ([AppHelper isEmpty:row.title] == TRUE) {
        cell.lblTitle.text = @"No Title";
    }
    else {
        cell.lblTitle.text = row.title;
    }
    if ([AppHelper isEmpty:row.descriptionField] == TRUE) {
        cell.lblDescription.text = @"No Description";
    }
    else {
        cell.lblDescription.text = row.descriptionField;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

-(void)dealloc {
    self.tableView = nil;
    self.arrayFacts = nil;
    // terminate all pending download connections
    [self terminateAllDownloads];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table cell image support

- (void)startIconDownload:(Row *)row forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.row = row;
        [iconDownloader setCompletionHandler:^{
            
            TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if (row.icon != nil) {
                // Display the newly loaded image
                cell.imageHref.image = row.icon;
            }
            
            // Remove the IconDownloader from the progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
- (void)loadImagesForOnscreenRows
{
    if (self.arrayFacts.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Row *row = (self.arrayFacts)[indexPath.row];
            
            if (!row.icon) // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:row forIndexPath:indexPath];
            }
        }
    }
}

// This method terminate all pending download connections
- (void)terminateAllDownloads {
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}


@end
