//
//  InvestmentsViewController.m
//  Rebalancer
//
//  Created by Connor O'Sullivan on 2/25/12.
//  Copyright (c) 2012 Connor Jon O'Sullivan. All rights reserved.
//

//#import "InvestmentsViewController.h"
//
//@implementation InvestmentsViewController
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - View lifecycle
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//	[super viewDidDisappear:animated];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//@end

// BEGIN CODE FROM BSYahooFinance DetailsViewController.m

#import "InvestmentsViewController.h"


@interface InvestmentsViewController()
@property (nonatomic, strong) YFStockDetailsLoader *detailsLoader;
@property (nonatomic, strong) NSArray *detailKeys;
@end

@implementation InvestmentsViewController
@synthesize stockDetails;
@synthesize stockSymbol;
@synthesize detailsLoader;
@synthesize detailKeys;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.detailsLoader = [YFStockDetailsLoader loaderWithDelegate:self];
    [self.detailsLoader loadDetails:self.stockSymbol.symbol];
}

#pragma mark - YFStockDetailsLoader delegate methods

- (void)stockDetailsDidLoad:(YFStockDetailsLoader *)aDetailsLoader
{    
    self.detailKeys = [aDetailsLoader.stockDetails.detailsDictionary allKeys];
    [self.stockDetails reloadData];
}

- (void)stockDetailsDidFail:(YFStockDetailsLoader *)aDetailsLoader
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stock failed to load" 
                                                    message:[aDetailsLoader.error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.detailKeys != nil) {
        return [self.detailKeys count];
    }
    
    return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Individual Investment";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    if (self.detailsLoader.stockDetails == nil && indexPath.row == 2) {
//        cell.textLabel.text = @"Retrieving details, please wait...";
//        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
//        cell.textLabel.textColor = [UIColor lightGrayColor];
//    }
    else if ([self.detailKeys count] > 0) {
        cell.textLabel.textColor = [UIColor blackColor];
        NSString *str = [self.detailsLoader.stockDetails.detailsDictionary objectForKey:[self.detailKeys objectAtIndex:indexPath.row]];
        if (![[NSNull null] isEqual:str]) {
            cell.detailTextLabel.text = str;             
        }
        else {
            cell.detailTextLabel.text = @"N/A";
        }
        cell.textLabel.text = [self.detailKeys objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    }
    else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}



#pragma mark - Memory management
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.detailsLoader cancel];
    
    self.detailKeys = nil;
    self.detailsLoader = nil;
    self.stockSymbol = nil;
    self.stockDetails = nil;
    [super dealloc];
}

@end

