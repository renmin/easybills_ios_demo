//
//  DetailViewController.h
//  EasyBills
//
//  Created by ren min on 13-3-30.
//  Copyright (c) 2013年 ren min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIView *detailView;
@property (strong,nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *billDetailTextView;


@property (strong,nonatomic) UIActionSheet *datePickerActionSheet;
@property (strong,nonatomic) IBOutlet UIView *datePickerActionSheetView;
@property (strong,nonatomic) IBOutlet UIButton *dateSelectedButton;

-(IBAction)dateSelected:(id)sender;
-(IBAction)beginSelectDate:(id)sender;

@property (strong,nonatomic) IBOutlet UIView *categoryPickerActionSheetView;
@property (strong,nonatomic) IBOutlet UIButton *categorySelectedButton;

-(IBAction)categorySelected:(id)sender;
-(IBAction)beginSelectCategory:(id)sender;

- (IBAction)backgroundTouchDown:(id)sender;

//Picker
@property (strong,nonatomic) IBOutlet UIDatePicker *datePicker;

@end
