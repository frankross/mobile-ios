//
//  IMReturnReasonSelectionViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 01/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "VSDropdown.h"
#import "IMReturnReasonSelectionViewController.h"

#define DROP_DOWN_HEIGHT 180

@interface IMReturnReasonSelectionViewController () <VSDropdownDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *returnReasons;

@property (nonatomic,strong) VSDropdown *dropDownMenu;
@property (weak, nonatomic) IBOutlet UITextField *reasonTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (nonatomic, assign) BOOL isDropDownShown;


@property (weak, nonatomic) IBOutlet UILabel *pickUpSlotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpSlotTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpSlotDateLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickUpSlotTitleLabelTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickUpTimeSlotBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PickUpDateLabelBottomConstraint;

@end

@implementation IMReturnReasonSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Return products";
    
}

-(void)loadUI
{
    [self setUpNavigationBar];
    
    self.dropDownMenu = [[VSDropdown alloc]initWithDelegate:self];
    [self.dropDownMenu setAdoptParentTheme:YES];
    [self.dropDownMenu setShouldSortItems:NO];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.reasonTextField.frame.size.height)];
    self.reasonTextField.leftView = label;
    self.reasonTextField.leftViewMode = UITextFieldViewModeAlways;
    
    SET_FOR_YOU_CELL_BORDER(self.remarkTextView, [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0], 5.0)
    
    self.remarkTextView.text = IMComments;
    self.remarkTextView.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    
    
    
    self.pickUpSlotTimeLabel.textColor = APP_THEME_COLOR;
    self.pickUpSlotTimeLabel.font = [UIFont fontWithName:IMHelveticaMedium size:18];
    self.pickUpSlotTimeLabel.text = @"Choose pickup slot";
    self.pickUpSlotDateLabel.text = @"";
    self.pickUpSlotTitleLabel.text = @"";
    self.pickUpSlotTitleLabelTopConstraint.constant = 5;
    self.pickUpTimeSlotBottomConstraint.constant = 10;
    self.PickUpDateLabelBottomConstraint.constant = 5;
    [self.view layoutIfNeeded];
    
    [self downloadFeed];
    
}


-(void)downloadFeed
{
    self.returnReasons = [NSMutableArray arrayWithObjects:@"Order created by mistake",@"Incorrect SKU's added to order",@"Change my mind", @"Items did not arrive on time",@"Item price too high",@"Incorrect delivery slot chosen",@"Shipping Charge too high",@"Incorrect Shipping address",@"Incorrect Billing address",  @"Others",nil];
    
}

-(void)updateUI
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [self.view endEditing:YES];

}

#pragma mark - IBActions

- (IBAction)tappedDropDownMenu:(UITapGestureRecognizer *)sender
{
//    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [self.view endEditing:YES];
//    for(IMCancelReason *reason in self.modelArray)
//    {
//        [contents addObject:reason.reason];
//    }
    if(!self.isDropDownShown)
    {
        [self showDropDownForView:sender.view adContents:self.returnReasons multipleSelection:NO];
        self.remarkTextView.hidden = YES;
        self.isDropDownShown = YES;
        
    }
    else
    {
        [self.dropDownMenu remove];
        self.remarkTextView.hidden = NO;
        self.isDropDownShown = NO;
        
    }
}



- (IBAction)submitButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)selectPickUpSlotPressed:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"SegueToPickUpSlot" sender:self];
}


//callback
-(void)showDropDownForView:(UIView *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    
    
    
    
    [self.dropDownMenu setDrodownAnimation:rand()%2];
    
    [self.dropDownMenu setAllowMultipleSelection:multipleSelection];
    
    [self.dropDownMenu setupDropdownForView:sender];
    //dropdown max height
    self.dropDownMenu.maxDropdownHeight = DROP_DOWN_HEIGHT;
    
    [self.dropDownMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    self.dropDownMenu.textColor = APP_THEME_COLOR;
    if (self.dropDownMenu.allowMultipleSelection)
    {
        //        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[[sender titleForState:UIControlStateNormal] componentsSeparatedByString:@";"]];
    }
    else
    {
        [self.dropDownMenu reloadDropdownWithContents:contents andSelectedItems:@[self.reasonTextField.text]];
    }
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
}
- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 1.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 1.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}

//call back
-(void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
//    self.selectedModel =  self.selectedModel = self.modelArray[index];
    self.reasonTextField.text = self.returnReasons[index];
}


-(void)dropdownDidAppear:(VSDropdown *)dropDown
{
    self.remarkTextView.hidden = YES;
    self.isDropDownShown = YES;
    
}

-(void)dropdownWillDisappear:(VSDropdown *)dropDown
{
    self.remarkTextView.hidden = NO;
    
    self.isDropDownShown = NO;

    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:IMComments]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = IMComments;
        textView.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]; //optional
    }
    [textView resignFirstResponder];
}

@end
