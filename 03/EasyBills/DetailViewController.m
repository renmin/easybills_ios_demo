//
//  DetailViewController.m
//  EasyBills
//
//  Created by ren min on 13-3-30.
//  Copyright (c) 2013年 ren min. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
    UIView *_pickerView;
    NSDateFormatter *_dateFormatter;
}
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)configMoneyTextField
{
    /* 设置金额文本框 */
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.moneyTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.moneyTextField.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    
    self.moneyTextField.textAlignment = UITextAlignmentLeft;
    
    self.moneyTextField.placeholder = @"0.00";
    
    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    currencyLabel.text = [[[NSNumberFormatter alloc] init] currencySymbol];
    currencyLabel.font = self.moneyTextField.font;
    [currencyLabel sizeToFit];
    self.moneyTextField.leftView = currencyLabel;
    self.moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *unitLable = [[UILabel alloc] initWithFrame:CGRectZero];
    unitLable.text = @"元";
    unitLable.font = self.moneyTextField.font;
    [unitLable sizeToFit];
    self.moneyTextField.rightView = unitLable;
    self.moneyTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)configDatePickerActionSheet
{
    /*04 设置选取日期的 ActionSheet*/
    self.datePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"日期" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles:@"",@"", nil];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    //[self.view addSubview:self.scrollView];
    //[self.view insertSubview:self.scrollView atIndex:0];
    [self.scrollView addSubview:self.detailView];
    self.scrollView.contentSize = self.detailView.frame.size;
    
    
    [self configMoneyTextField];
    
    [self configDatePickerActionSheet];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    
    return self;
}

/* 2 设置TextView，当键盘弹出时，提升scrollView的高度 */
- (void) handleKeyboardDidShow:(NSNotification *)paramNotification{
    
    /* Get the frame of the keyboard */
    NSValue *keyboardRectAsObject =
    [[paramNotification userInfo]
     objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    /* Place it in a CGRect */
    CGRect keyboardRect;
    
    [keyboardRectAsObject getValue:&keyboardRect];
    
    CGSize size = self.detailView.frame.size;
    size.height += keyboardRect.size.height;
    self.scrollView.contentSize = size;

    
    
    /* Give a bottom margin to our text view that makes it
     reach to the top of the keyboard */
    self.scrollView.contentInset =
    UIEdgeInsetsMake(0.0f,
                     0.0f,
                     keyboardRect.size.height,
                     0.0f);
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{
    /* Make the text view as big as the whole view again */
    self.scrollView.contentSize = self.detailView.frame.size;
    self.billDetailTextView.contentInset = UIEdgeInsetsZero;
    [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}
//2.2 监听键盘出现和消失的事件
- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleKeyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleKeyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
}
- (void) viewWillDisappear:(BOOL)paramAnimated{
    [super viewWillDisappear:paramAnimated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 03.点击背景隐藏键盘
-(IBAction)backgroundTouchDown:(id)sender{
    [self.moneyTextField resignFirstResponder];
    [self.billDetailTextView resignFirstResponder];
}

#pragma mark 04.1 日期和类别的选择
-(IBAction)beginSelectDate:(id)sender{
    if (_pickerView!=nil && _pickerView.superview!=nil) {
        [_pickerView removeFromSuperview];
    }
    _pickerView = self.datePickerActionSheetView;
    [self.datePickerActionSheet addSubview:self.datePickerActionSheetView];
    [self.datePickerActionSheet showInView:self.view];
    
}
-(IBAction)dateSelected:(id)sender{
    [self.datePickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *date =[_dateFormatter stringFromDate:self.datePicker.date];
    
    [self.dateSelectedButton setTitle:date forState:UIControlStateNormal];
}

-(IBAction)beginSelectCategory:(id)sender{
    if (_pickerView!=nil && _pickerView.superview!=nil) {
        [_pickerView removeFromSuperview];
    }
    _pickerView = self.categoryPickerActionSheetView;
    [self.datePickerActionSheet addSubview:self.categoryPickerActionSheetView];
    [self.datePickerActionSheet showInView:self.view];
}


-(IBAction)categorySelected:(id)sender{
    [self.datePickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
