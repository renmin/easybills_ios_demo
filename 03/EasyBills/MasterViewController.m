//
//  MasterViewController.m
//  EasyBills
//
//  Created by ren min on 13-3-30.
//  Copyright (c) 2013年 ren min. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#define kBillMoney @"Money"
#define kBillDate @"Date"
#define kBillCategory @"Category"
#define kBillSubCategory @"SubCategory"
#define kBillDetails @"Details"
#define kBillLocation @"Location"


@interface MasterViewController () {
    NSMutableArray *_objects;
    NSArray *billFields;
    NSArray *billInitData;
    NSDictionary *categoryDictionary;
    NSArray *categorys;
    NSArray *subCategorys;
    
    NSDateFormatter *_dateFormatter;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"流水账";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    billFields =    @[kBillMoney,
                      kBillDate,
                      kBillCategory,
                      kBillSubCategory,
                      kBillDetails,
                      kBillLocation];
    billInitData =  @[@0.0,
                      [NSDate date],
                      @0,
                      @0,
                      @"备注",
                      @""];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"CategoryList" withExtension:@"plist"];
    categoryDictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    categorys = categoryDictionary.allKeys;
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *newBill = [[NSMutableDictionary alloc] initWithObjects:billInitData forKeys:billFields];
    [newBill setObject:[NSDate date] forKey:kBillDate];
     
    [_objects insertObject:newBill atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *oneBill = _objects[indexPath.row];
    
    NSNumber *categoryId = [oneBill objectForKey:kBillCategory];   
    NSNumber *subId = [oneBill valueForKey:kBillSubCategory];
    NSNumber *money = [oneBill objectForKey:kBillMoney];
    NSString *details = [oneBill objectForKey:kBillDetails];
    NSDate *date = (NSDate *)[oneBill objectForKey:kBillDate];
    
    
    NSObject *category = categorys[[categoryId integerValue]];
    NSArray *subCategorys = [categoryDictionary objectForKey:category];
    NSObject *sub = subCategorys[[subId integerValue]];
    
    NSString *billText = [NSString stringWithFormat:@"%@>%@:%@元",
                          category,sub,money];
    
    //NSString  *stringdate = [dateFormatter stringFromDate:date];
    cell.textLabel.text = billText;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@：%@",
                                 [_dateFormatter stringFromDate:date],
                                 details];
    
    //cell.textLabel.text = [(NSDate *)[oneBill objectForKey:kBillDate] description];
    //cell.textLabel.text = [oneBill description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
