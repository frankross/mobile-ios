//
//  IMProductListSortViewController.m
//  InstaMed
//
//  Created by Arjuna on 17/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOptionsViewController.h"
#import "IMConstants.h"
#import "IMCategory.h"


@interface IMOptionsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;


@end

@implementation IMOptionsViewController

-(void)loadUI
{
    self.optionsTableView.allowsMultipleSelection = YES;
    
    if(self.optionType == IMSort)
    {
        self.optionsTableView.allowsMultipleSelection = NO;
        self.title = IMSortText;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if(self.optionType == IMBrands)
    {
        self.title = IMBrandsText;
    }
    else if(self.optionType == IMOffers)
    {
        self.title = IMOffersText;
    }
    else if(self.optionType == IMCat)
    {
        self.title = IMCategoriesText;
    }
    
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = IMCancel;
    [self downloadFeed];
 }

-(void)downloadFeed
{
//    self.modelArray = [NSMutableArray array];
//    
//    
//    if(self.optionType == IMSort)
//    {
//            self.modelArray = [NSMutableArray array];
//        IMSortType* type = [[IMSortType alloc] init];
//        
//        type.identifier = @(1);
//        type.name = @"Most relevant";
//        [self.modelArray addObject:type];
//        
//        type = [[IMSortType alloc] init];
//        type.identifier = @(2);
//        type.name = @"Most popular";
//        [self.modelArray addObject:type];
//        
//        type = [[IMSortType alloc] init];
//        type.identifier = @(3);
//        type.name = @"Price: low to high";
//        [self.modelArray addObject:type];
//        
//        type = [[IMSortType alloc] init];
//        type.identifier = @(4);
//        type.name = @"Price: high to low";
//        [self.modelArray addObject:type];
//        
//       
//    }
//    else if(self.optionType == IMBrands)
//    {
//        IMBrand* brand = [[IMBrand alloc] init];
//        
//        brand.identifier = @(1);
//        brand.name = @"Puma";
//        [self.modelArray addObject:brand];
//        
//        brand = [[IMBrand alloc] init];
//        brand.identifier = @(2);
//        brand.name = @"Bata";
//        [self.modelArray addObject:brand];
//        
//        brand = [[IMBrand alloc] init];
//        brand.identifier = @(3);
//        brand.name = @"Peter England";
//        [self.modelArray addObject:brand];
//        
//        brand = [[IMBrand alloc] init];
//        brand.identifier = @(4);
//        brand.name = @"Woodland";
//        [self.modelArray addObject:brand];
//
//        
//    }
//    else if(self.optionType == IMOffers)
//    {
//        IMOffer* offer = [[IMOffer alloc] init];
//        
//        offer.identifier = @(1);
//        offer.name = @"Buy 1 get 1";
//        [self.modelArray addObject:offer];
//        
//        offer = [[IMOffer alloc] init];
//        offer.identifier = @(2);
//        offer.name = @"100% off";
//        [self.modelArray addObject:offer];
//        
//        offer = [[IMOffer alloc] init];
//        offer.identifier = @(3);
//        offer.name = @"Buy 2 get 1";
//        [self.modelArray addObject:offer];
//        
//        offer = [[IMOffer alloc] init];
//        offer.identifier = @(4);
//        offer.name = @"Combo Offer";
//        [self.modelArray addObject:offer];
//
//    }
    [self updateUI];
}

/**
 @brief To update Ui after feed
 @returns void
 */
-(void)updateUI
{
    self.optionsTableView.dataSource = self;
    self.optionsTableView.delegate = self;
    [self.optionsTableView reloadData];
   
    
    for(IMBaseModel* option in self.selectedOptions)
    {
    
        for(NSInteger index = 0; index < self.modelArray.count;index++)
        {
            if(self.optionType == IMCat)
            {
                IMCategory *cat = self.modelArray[index];
                if([ ((IMCategory *)option).name isEqual:cat.name])
                {
                    [self.optionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
            else
            {
                IMBaseModel* model = self.modelArray[index];

                if([option isEqual:model])
                {
                    [self.optionsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
            
        }
    }
}

#pragma mark - Table View DataSource and Delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOptionsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IMOptionsTableViewCell" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.optionType == IMSort)
    {
        [self doneButtonPressed:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

/**
 @brief To handle done button action
 @returns void
 */
- (IBAction)doneButtonPressed:(id)sender
{
    [IMFlurry logEvent:IMSortEvent withParameters:@{}];
    NSMutableArray* selectedOptions = [NSMutableArray array];
    for (NSIndexPath* indexPath in [self.optionsTableView indexPathsForSelectedRows])
    {
        [selectedOptions addObject:self.modelArray[indexPath.row]];
    }
    if(selectedOptions)
    {
        self.completionBlock(selectedOptions);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
