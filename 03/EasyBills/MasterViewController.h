//
//  MasterViewController.h
//  EasyBills
//
//  Created by ren min on 13-3-30.
//  Copyright (c) 2013年 ren min. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
