//
//  IMCartRevisionViewController.m
//  InstaMed
//
//  Created by Suhail K on 02/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartRevisionViewController.h"
#import "IMQuantitySelectionViewController.h"
#import "IMCartManager.h"
#import "IMOrder.h"
#import "IMCartTableViewCell.h"
#import "IMAccountsManager.h"
#import "IMProductUnAvailableTableViewCell.h"


@interface IMCartRevisionViewController ()<UITableViewDataSource,UITableViewDelegate,IMQuantitySelectionViewControllerDelegate>

@property (nonatomic,strong) IMOrder* order;
@property (weak, nonatomic)  UITextField *activeField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IMCartTableViewCell* prototypeCell;

@end

@implementation IMCartRevisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)loadUI
{
    [self setUpNavigationBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Cart revised";
    [self downloadFeed];
}

- (void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] fetchOrderDetailWithOrderId:@(529) completion:^(IMOrder *order, NSError *error) {
        if(!error)
        {
            [self hideActivityIndicatorView];
            self.selectedModel = order;
            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
            
        }
    }];
    
}

- (void)updateUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
//    for(NSInteger index=0;index<self.modelArray.count;index++)
//    {
//        height += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    }
//    self.tableViewHeightConstraint.constant = height;//self.modelArray.count
}

#pragma mark  - Textfield Delegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

#pragma mark  - Keyboard Handling Methods -

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.tableView convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.tableView scrollRectToVisible:  [self.tableView convertRect:self.activeField.frame fromView:self.activeField.superview] animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - TableView Datasource and delegate Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ((IMOrder *)self.selectedModel).orderedItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IMLineItem *item = [((IMOrder *)self.selectedModel).orderedItems objectAtIndex:indexPath.row];
    if(item.isAvailable)
    {
        IMCartTableViewCell* cartCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMCartCellIdentitifier" forIndexPath:indexPath];
        cartCell.qtyButton.tag = indexPath.row;
        cartCell.deleteButton.tag = indexPath.row;
         [self configureCell:cartCell forRowAtIndexPath:indexPath];
        return cartCell;
    }
    else
    {
        IMProductUnAvailableTableViewCell* cartUnavailableCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMUnavailablecell" forIndexPath:indexPath];
        cartUnavailableCell.nameLabel.text = item.name;
        cartUnavailableCell.unavailableLabel.text = @"Product is unavailable";
//        cartUnavailableCell.manufracturerNameLabel.text = item
        return cartUnavailableCell;
    }
 
}




- (void)configureCell:(IMCartTableViewCell *)cartCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMLineItem *model = [((IMOrder *)self.selectedModel).orderedItems objectAtIndex:indexPath.row];
    //address.tag = @"Home";
    cartCell.qtyButton.tag = indexPath.row;
    cartCell.deleteButton.tag = indexPath.row;
    cartCell.qtyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cartCell.qtyButton.layer.borderWidth = 1;
    cartCell.nameLabel.text = model.name;
    if([model.discountPercentage isEqual:@"0.0"])
    {
        cartCell.priceLabel.text = [NSString stringWithFormat:@"₹ %.02lf",[model.salesPrice doubleValue]];
    }
    else
    {
        cartCell.priceLabel.text = [NSString stringWithFormat:@"₹ %.02lf",[model.promotionalPrice doubleValue]];
    }
    cartCell.unitLabel.text = [NSString stringWithFormat:@"%@ (1x%@)",model.unitOfSales,model.innerPackingQuantity];
    cartCell.totalPriceLabel.text =  [NSString stringWithFormat:@"₹ %.02lf",[model.totalPrice doubleValue] ];
    [cartCell.qtyButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.quantity] forState:UIControlStateNormal]  ;
    
    cartCell.prescriptionrequiredLabel.text = @"";
    
    if(model.isPrescriptionAvailable)
    {
        cartCell.prescriptionrequiredLabel.text  = IMPrescriptionPresent;
        cartCell.prescriptionrequiredLabel.textColor  = [UIColor blackColor];
        
    }
    else if(model.isPrescriptionRequired)
    {
        cartCell.prescriptionrequiredLabel.text  = IMPrescriptionRequired;
        cartCell.prescriptionrequiredLabel.textColor  = APP_THEME_COLOR;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    CGFloat height = 165;
    //    IMLineItem *model = [self.modelArray objectAtIndex:indexPath.row];
    //    if(!model.isPrescriptionRequired)
    //    {
    //        height = 135;
    //    }
    //    return height;
    
    //    if (IS_IOS8_OR_ABOVE) {
    //        return UITableViewAutomaticDimension;
    //    }
    
    if(!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMCartCellIdentitifier"];
    }
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    //    [self.prototypeCell updateConstraintsIfNeeded];
    //    [self.prototypeCell layoutIfNeeded];
    
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"cell height = %lf",height);
    
    return height;
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    CGFloat height = 190;
//    IMLineItem *model = [((IMOrder *)self.selectedModel).orderedItems objectAtIndex:indexPath.row];
//
//    if(!model.isPrescriptionRequired)
//    {
//        height = 150;
//    }
//    if (!model.isAvailable) {
//        height = 140;
//    }
//    return height;
//    
//}


- (IBAction)editQuantityPressed:(UIButton *)sender
{
    self.selectedModel = self.modelArray[sender.tag];
    IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
    quantitySelectionViewController.delgate = self;
    quantitySelectionViewController.product = (IMLineItem*)self.selectedModel;
    
    quantitySelectionViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:quantitySelectionViewController animated:NO completion:nil];
}

- (IBAction)deleteCartItemPressed:(UIButton*)sender
{
//    self.selectedModel = self.modelArray[sender.tag];
//    [self showActivityIndicatorView];
//    
//    [[IMCartManager sharedManager] deleteCartItemWithId:self.selectedModel.identifier withCompletion:^(IMCart* cart, NSError *error) {
//        
//        [self hideActivityIndicatorView];
//        if(!error)
//        {
//            self.cart = cart;
//            self.modelArray = [cart lineItems];
//            
//            NSLog(@"deleted cart");
//        }
//        [self updateUI];
//    }];
    
}

-(void)quantitySelectionController:(IMQuantitySelectionViewController *)quantitySelectionController didFinishWithWithQuanity:(NSInteger)quanity
{
//    ((IMLineItem*)self.selectedModel).quantity = quanity;
//    
//    [self showActivityIndicatorView];
//    
//    [[IMCartManager sharedManager] updateCartItems:@[self.selectedModel] withCompletion:^(IMCart* cart, NSError *error) {
//        [self hideActivityIndicatorView];
//        if(!error)
//        {
//            self.cart = cart;
//            self.modelArray = [cart lineItems];
//            
//            NSLog(@"updated cart");
//        }
//        [self updateUI];
//    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    

    
    
}






@end
