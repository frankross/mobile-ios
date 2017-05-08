//
//  IMAddressListViewController.m
//  InstaMed
//
//  Created by Arjuna on 19/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAddressListViewController.h"
#import "IMAddressTableViewCell.h"
#import "IMAccountsManager.h"
#import "IMAddressAddEditViewController.h"


@interface IMAddressListViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property NSInteger indexOfCellShowingMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTableViewHeightContraint;
@property(nonatomic,strong) IMAddressTableViewCell* prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultAdreesLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *footerSeparatorView;

@end

@implementation IMAddressListViewController

/**
 @brief To initial Ui setup
 @returns void
 */
-(void)loadUI
{
    [super setUpNavigationBar];

    if(self.addressType == IMDeliveryAddressList)
    {
        self.addressTableView.tableHeaderView = nil;
    }
    else if(self.addressType == IMMyAccountAddressList)
    {
        self.addressTableView.scrollEnabled = NO;
    }
    
    if(IS_IOS8_OR_ABOVE)
        self.addressTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMAddressSelectionVisited  withParameters:@{}];

    if([[IMAccountsManager sharedManager] userToken])
    {
        [self downloadFeed];
    }
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{

    
    if(self.addressType == IMDeliveryAddressList)
    {
        [self showActivityIndicatorView];
    }
    [[IMAccountsManager sharedManager] fetchAddressesWithCompletion:^(NSMutableArray *addresses, NSError *error) {
        [self hideActivityIndicatorView];
        if (!error)
        {
            if(addresses)
            {
                self.modelArray = addresses;
                NSArray* reversedAddressArray = [[self.modelArray reverseObjectEnumerator] allObjects];
                self.modelArray = [reversedAddressArray mutableCopy];

            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        }
        else
        {
            self.modelArray = addresses;
            [self handleError:error withRetryStatus:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });

        }
    }];
}

/**
 @brief To update Ui after feed
 @returns void
 */
-(void)updateUI
{
    self.addressTableView.dataSource = self;
    self.addressTableView.delegate = self;
    [self.addressTableView reloadData];
    if(self.modelArray.count)
    {
        self.footerSeparatorView.hidden = NO;
    }
    else
    {
        self.footerSeparatorView.hidden = YES;
        
    }
    if([self.delegate respondsToSelector:@selector(didLoadWithAddressTableViewHeight:)])
    {
        
        CGFloat height = self.addressTableView.tableHeaderView.frame.size.height + self.addressTableView.tableFooterView.frame.size.height;
        
        for(NSInteger index=0;index<self.modelArray.count;index++)
        {
            height += [self tableView:self.addressTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        [self.delegate didLoadWithAddressTableViewHeight:height];
    }
    
    if(self.addressType == IMDeliveryAddressList)
        self.addressTableViewHeightContraint.constant = self.view.bounds.size.height;
    
    [self.addressTableView layoutIfNeeded];
}

#pragma mark - TableView Datasource and delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.modelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAddressTableViewCell* addressCell = [self.addressTableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
    
    [self configureCell:addressCell forRowAtIndexPath:indexPath];
    return addressCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(didSelectAddress:)])
    {
        [self.delegate didSelectAddress:self.modelArray[indexPath.row]];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!self.prototypeCell)
    {
          self.prototypeCell = [self.addressTableView dequeueReusableCellWithIdentifier:@"addressCell"];
    }
    
    
    //address.tag = @"Home";
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"cell height = %lf",height);
    
    return height+1;

}

/**
 @brief To configure dynamic height cell
 @returns void
 */
- (void)configureCell:(IMAddressTableViewCell *)addressCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAddress* address = self.modelArray[indexPath.row];
    //address.tag = @"Home";
    
    addressCell.nameLabel.text = [address.name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[address.name  substringToIndex:1] uppercaseString]];

    addressCell.tagLabel.text = [address.tag stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[address.tag  substringToIndex:1] uppercaseString]];
    
    if(address.landmark)
    {
        
        addressCell.addressLabel.attributedText  = [self attributedStringForString: [[NSString stringWithFormat:@"%@, %@, %@",address.addressLine1,address.addressLine2,address.landmark] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[NSString stringWithFormat:@"%@, %@, %@",address.addressLine1,address.addressLine2,address.landmark]  substringToIndex:1] uppercaseString]]];
    }
    else
    {
        addressCell.addressLabel.attributedText  = [self attributedStringForString:[[NSString stringWithFormat:@"%@, %@",address.addressLine1,address.addressLine2] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[NSString stringWithFormat:@"%@, %@",address.addressLine1,address.addressLine2]  substringToIndex:1] uppercaseString]]];
        
    }
    
    
    addressCell.cityPincodeLabel.text = [NSString stringWithFormat:@"%@ - %@",address.city.name,address.pinCode];
    addressCell.mobileNumberLabel.text = [NSString stringWithFormat:@"+91 %@",address.phoneNumber];//[NSString stringWithFormat:@"%@",address.phoneNumber];
    addressCell.menuButton.tag = indexPath.row;
    if(address.tag)
    {
        addressCell.defaultAddressLabelLeadingConstraint.constant = 15;
   }
    else
    {
        addressCell.defaultAddressLabelLeadingConstraint.constant = 0;
    }
    
    if(address.isDefault)
    {
        addressCell.defaultAddressIndicatorLabel.hidden = NO;
    }
        else
    {
        addressCell.defaultAddressIndicatorLabel.hidden = YES;
    }
    if(!address.isDefault && address.tag == nil)
    {
        addressCell.defaultAdressheightConstraint.constant = 0;
        addressCell.defaultToNameVConstraint.constant = 3;
    }
    else
    {
        addressCell.defaultAdressheightConstraint.constant = 20;
        addressCell.defaultToNameVConstraint.constant = 13;

    }
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Actions -

- (IBAction)toggleMenu:(UIButton *)sender
{
    self.indexOfCellShowingMenu = sender.tag;

    
    if(IS_IOS8_OR_ABOVE)
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:IMSetAsDefualt style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self setAddressAsDefault];
        }]];
        
        
        
        [alert addAction:[UIAlertAction actionWithTitle:IMEdit style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"editAddressSegue" sender:self];


        }]];
        
            
        [alert addAction:[UIAlertAction actionWithTitle:IMDelete style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self deleteAddress];
        }]];


        
        [alert addAction:[UIAlertAction actionWithTitle:IMCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
           
        }]];
        
        alert.view.tintColor = APP_THEME_COLOR;
        [self presentViewController:alert animated:YES completion:nil];
        alert.view.tintColor = APP_THEME_COLOR;
    }
    else
    {
        UIActionSheet *actionSheet;

        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:IMCancel destructiveButtonTitle:nil otherButtonTitles:IMSetAsDefualt,IMEdit,IMDelete, nil];

        
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }

}

/**
 @brief To dchange the action sheet color
 @returns void
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        }
    }
}

- (IBAction)editAddress:(UIButton *)sender
{
    
}

/**
 @brief To handle setasdefualt button action
 @returns void
 */
-(void)setAddressAsDefault
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] setDefaultAddress:self.modelArray[self.indexOfCellShowingMenu] withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
      if(!error)
      {
          [self downloadFeed];
      }
      else if(error.userInfo[IMMessage])
      {
          [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
      }
      else
      {
          if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost)
          {
              [self showErrorPanelWithMessage:IMNoNetworkErrorMessage showRetryButton:YES];
          }
      }

    }];

}

/**
 @brief To handle delete button action
 @returns void
 */
- (void)deleteAddress
{

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:IMDeleteConfirmationAlertMessageTitle
                                          message:IMDeleteConfirmationAlertMessageMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:IMCancel
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:IMOK
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       [self deleteAddressOfUser];
                                       
                                   }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Action sheet delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
       
            [self setAddressAsDefault];
            break;
        case 1:
            [self performSegueWithIdentifier:@"editAddressSegue" sender:self];
            break;
        case 2:
        {
            [self deleteAddress];
            break;
        }
        default:
            break;
    }
}


#pragma mark - Navigation -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"editAddressSegue"])
    {
        IMAddressAddEditViewController* addressEditViewController = (IMAddressAddEditViewController*)segue.destinationViewController;
        addressEditViewController.selectedModel  = self.modelArray[self.indexOfCellShowingMenu];
    }
}


- (void) deleteAddressOfUser
{
    [IMFlurry logEvent:IMDeleteAddressEvent withParameters:@{}];
    
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] deleteAddress:self.modelArray[self.indexOfCellShowingMenu] withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            [self.modelArray removeObjectAtIndex:self.indexOfCellShowingMenu];
            [self.addressTableView reloadData];
            if([self.delegate respondsToSelector:@selector(didLoadWithAddressTableViewHeight:)])
            {
                
                CGFloat height = self.addressTableView.tableHeaderView.frame.size.height + self.addressTableView.tableFooterView.frame.size.height;
                
                for(NSInteger index=0;index<self.modelArray.count;index++)
                {
                    height += [self tableView:self.addressTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                }
                
                [self.delegate didLoadWithAddressTableViewHeight:height];
            }
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
}
@end


