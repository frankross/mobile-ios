//
//  IMSearchViewController.m
//  InstaMed
//
//  Created by Suhail K on 22/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#define HEADER_HEIGHT 72
#import "IMSearchViewController.h"
#import "IMProduct.h"
#import "IMPharmacyManager.h"
#import "IMSearchResultsViewController.h"
#import "IMNonPharmaSearchTableViewCell.h"
#import "IMPharmaSerachTableViewCell.h"
#import "IMCacheManager.h"
#import "UITextField+IMSearchBar.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"


#define SERACH_AFTER 3
@interface IMSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSArray *typeArray;
@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (nonatomic, strong) NSMutableDictionary *dataSourceDictionary;
@property (nonatomic, assign) IMSearchMode searchMode;
- (IBAction)clearHistoryPressed:(id)sender;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, strong) IMNonPharmaSearchTableViewCell *prototypeCell;
@end

@implementation IMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMSearchScreenVisited withParameters:@{}];

    [self addNotificationObservers];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationObservers];
    [super viewWillDisappear:animated];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI -

-(void)loadUI
{
    [self setUpNavigationBar];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchMode = IMRecentlySearched;
    [self downloadFeed];
    [IMFunctionUtilities setBackgroundImage:self.searchBar withImageColor:APP_THEME_COLOR];
    
    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
    [self.searchField configureAsSearchBar];
    
}

/**
 @brief Todownload feeds
 @returns void
 */

-(void)downloadFeed
{
    self.dataSourceDictionary = [[NSMutableDictionary alloc] init];
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    
//    IMProduct *product1 = [[IMProduct alloc] init];
//    product1.productID = @"1";
//    product1.name = @"Pharma product 1";
//    product1.category = @"pharmacy";
//    [self.dataSourceArray addObject:product1];
//    IMProduct *product2 = [[IMProduct alloc] init];
//    product2.productID = @"2";
//    product2.name = @"Pharma product 2";
//    product2.category = @"pharmacy";
//
//    [self.dataSourceArray addObject:product2];
//    IMProduct *product3 = [[IMProduct alloc] init];
//    product3.productID = @"3";
//    product3.name = @"Pharma product 3";
//    product3.category = @"pharmacy";
//
//    [self.dataSourceArray addObject:product3];
//    IMProduct *product4 = [[IMProduct alloc] init];
//    product4.productID = @"4";
//    product4.name = @"Pharma product 4";
//    product4.category = @"pharmacy";
//
//    [self.dataSourceArray addObject:product4];
//    
//    IMProduct *product5 = [[IMProduct alloc] init];
//    product5.productID = @"5";
//    product5.name = @"NonPharma product 1";
//    product5.category = @"Category 5";
//
//    [self.dataSourceArray addObject:product5];
//    IMProduct *product6 = [[IMProduct alloc] init];
//    product6.productID = @"6";
//    product6.name = @"NonPharma product 2";
//    product6.category = @"Category 5";
//
//    [self.dataSourceArray addObject:product6];
//    IMProduct *product7 = [[IMProduct alloc] init];
//    product7.productID = @"7";
//    product7.name = @"NonPharma product 3";
//    product7.category = @"Category 7";
//
//    [self.dataSourceArray addObject:product7];
//    IMProduct *product8 = [[IMProduct alloc] init];
//    product8.productID = @"8";
//    product8.name = @"NonPharma product 4";
//    product8.category = @"Category 3";
//
//    [self.dataSourceArray addObject:product8];
    
    NSDictionary *dict = [[IMCacheManager sharedManager] retriveDataFromPlist];
    NSMutableArray *pharma = [[NSMutableArray alloc] init];
    NSMutableArray *nonPharma = [[NSMutableArray alloc] init];
    NSMutableArray *pharmaArray = dict[@"pharma"];
    NSMutableArray *nonPharmaArray = dict[@"nonPharma"];

   NSArray* reversedPharma = [[pharmaArray reverseObjectEnumerator] allObjects];
    NSArray* reversedNonPharma = [[nonPharmaArray reverseObjectEnumerator] allObjects];

    for (NSDictionary *itemDict in reversedPharma)
    {
        IMProduct *product = [[IMProduct alloc] init];
        product.name = itemDict[IMSearchProductName];
        product.category = itemDict[IMSearchCatagory];
        product.identifier= itemDict[IMSearchProductID];
        product.manufacturer = itemDict[IMSearchCompanyName];
        product.thumbnailImageURL = itemDict[IMSearchImageURL];
        product.isPharma = [itemDict[IMIsPharma] boolValue];
        [pharma addObject:product];
    }
    for (NSDictionary *itemDict in reversedNonPharma)
    {
        IMProduct *product = [[IMProduct alloc] init];
        product.name = itemDict[IMSearchProductName];
        product.category = itemDict[IMSearchCatagory];
        product.identifier= itemDict[IMSearchProductID];
        product.isPharma = [itemDict[IMIsPharma] boolValue];
        [nonPharma addObject:product];
    }
    [self setUpDictionaryWithPharma:pharma andNonPharma:nonPharma];

}

/**
 @brief To update Ui after feed download
 @returns void
 */
-(void)updateUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    if(self.searchMode == IMRecentlySearched)
    {
        [self setTableHeaderWithStatus:YES];
    }
    else
    {
        [self setTableHeaderWithStatus:NO];
    }
    [self.tableView reloadData];
}

/**
 @brief To setup data source for tableview
 @returns void
 */
- (void)setUpDictionaryWithPharma:(NSArray *)pharma andNonPharma:(NSArray *)nonPharma
{

    [self.dataSourceDictionary removeAllObjects];
    if (pharma.count)
    {
        [self.dataSourceDictionary setObject:pharma forKey:@"Pharma"];
    }
    if (nonPharma.count)
    {
        [self.dataSourceDictionary setObject:nonPharma forKey:@"NonPharma"];
    }
    if(!self.dataSourceDictionary.count)
    {
        self.tableView.hidden = YES;
        if(self.searchMode == IMRecentlySearched)
        {
            [self setNoContentTitle:IMNoHistory];

        }
        else
        {
            [self setNoContentTitle:IMNoResultFound];

        }
    }
    else
    {
        self.tableView.hidden = NO;
        [self setNoContentTitle:@""];
    }
    self.typeArray = [[self.dataSourceDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = NSOrderedDescending ;
        if([obj1 isEqualToString:@"Pharma"])
        {
            result = NSOrderedAscending;
        }
        return result;
    }];
    [self updateUI];
}

/**
 @brief To setup table header
 @returns void
 */
- (void)setTableHeaderWithStatus:(BOOL)status
{
    if(status)
    {
        self.tableView.tableFooterView.hidden = NO;
        self.tableView.tableHeaderView = self.tableViewHeader;
        self.tableView.tableFooterView = self.tableFooterView;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView.hidden = YES;
//        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - Observers -

-(void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 @brief To handle keyboard show notification
 @returns void
 */
- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbRect.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
}

/**
 @brief To handle keyboard hide notification
 @returns void
 */
- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - TableView -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    NSInteger sectionCount;
    sectionCount = self.dataSourceDictionary.count;
    return sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    rowCount = [[self.dataSourceDictionary objectForKey:[self.typeArray objectAtIndex:section]] count];
    return rowCount;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = PRODUCT_LIST_HEADER_HEIGHT;
    
    CGRect viewFrame = CGRectMake(0, 0, screenWidth , height);
    CGRect labelFrame = CGRectMake(20, 25, screenWidth - 40 , 30);

    UIView *headerView = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:labelFrame];

    NSString *text = [self.typeArray objectAtIndex:section];
    if ([text isEqualToString:@"NonPharma"])
    {
        titleLabel.text = IMOtherProducts;
//        headerView.backgroundColor = [UIColor whiteColor];
        headerView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:249/255.0];

    }
    else
    {
        titleLabel.text = IMMedicines;
        headerView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:249/255.0];
    }
    titleLabel.backgroundColor = [UIColor clearColor];
    CGFloat fontSize = (IS_IPAD ? 18 : 16);
    
    titleLabel.font = [UIFont fontWithName:IMHelveticaMedium size:fontSize];
    titleLabel.textColor = [UIColor colorWithRed:9.0/255.0 green:47.0/255.0 blue:24.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleLabel];
    
    UIView* topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    topSeparatorView.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:179.0/255.0 alpha:1.0];
    [headerView addSubview:topSeparatorView];
    
    UIView* bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, screenWidth - 0, 1)];
    bottomSeparatorView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:225.0/255.0 alpha:1.0];
    [headerView addSubview:bottomSeparatorView];
    if(self.searchMode == IMRecentlySearched && [text isEqualToString:@"Pharma"])
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = HEADER_HEIGHT;
    NSString *text = [self.typeArray objectAtIndex:section];

    if(self.searchMode == IMRecentlySearched && [text isEqualToString:@"Pharma"])
    {
        return 0.0;
    }
    return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMProduct *product = [[ self.dataSourceDictionary objectForKey:self.typeArray[indexPath.section] ] objectAtIndex:indexPath.row];
    
    if(product.isPharma)
    {
        return 60.0;

    }
    else
    {
        self.prototypeCell.suggestionLabel.text = [NSString stringWithFormat:@"%@ in %@",product.name,product.category];
         self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.prototypeCell.bounds));
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMNonPharmaSearchTableViewCell *nonPharmaCell;
    IMPharmaSerachTableViewCell *pharmaCell;
    
    
    IMProduct *product = [[ self.dataSourceDictionary objectForKey:self.typeArray[indexPath.section] ] objectAtIndex:indexPath.row];
    
    if(product.isPharma)
    {
        pharmaCell = [tableView dequeueReusableCellWithIdentifier:@"pharmaSearchCell" forIndexPath:indexPath];
        if (pharmaCell == nil)
        {
            pharmaCell = [[IMPharmaSerachTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                                  reuseIdentifier:@"pharmaSearchCell"];
        }
        if(product.thumbnailImageURL != ((id)[NSNull null]))
        {
            [pharmaCell.imgView setImageWithURL:[NSURL URLWithString:product.thumbnailImageURL]
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
        pharmaCell.suggestionLabel.text = [NSString stringWithFormat:@"%@",product.name];
        pharmaCell.suggestionLabel.textColor = APP_THEME_COLOR;
        if(product.manufacturer)
        {
            pharmaCell.comPanyNameLabel.text = product.manufacturer;
        }
        else
        {
            //ka if no manufacturer then do not display anything
            pharmaCell.comPanyNameLabel.text = @"";
        }
        
        
        pharmaCell.backgroundColor = [UIColor clearColor];
        if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1))
        {
            pharmaCell.bottomSeparatorView.hidden = YES;
        }
        else
        {
            pharmaCell.bottomSeparatorView.hidden = NO;
        }

        return pharmaCell;
    }
    else
    {
        nonPharmaCell = [tableView dequeueReusableCellWithIdentifier:@"nonPharmaSearchCell" forIndexPath:indexPath];
        if (nonPharmaCell == nil)
        {
            nonPharmaCell = [[IMNonPharmaSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:@"nonPharmaSearchCell"];
        }

        NSString *categoryText = [NSString stringWithFormat:@" in %@", product.category];
        NSString *suggestionText = [product.name stringByAppendingString:categoryText];
        
        NSMutableAttributedString *suggestionAttributedString = [[NSMutableAttributedString alloc] initWithString: suggestionText];
        [suggestionAttributedString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0 , product.name.length)];
        UIColor *color = [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
        [suggestionAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(product.name.length , categoryText.length)];
        
        nonPharmaCell.suggestionLabel.attributedText = suggestionAttributedString;
        nonPharmaCell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:249/255.0];
        if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1))
        {
            nonPharmaCell.bottomSeparatorView.hidden = YES;
        }
        else
        {
            nonPharmaCell.bottomSeparatorView.hidden = NO;
        }
        return  nonPharmaCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMProduct *product = [[ self.dataSourceDictionary objectForKey:self.typeArray[indexPath.section] ] objectAtIndex:indexPath.row];
    NSString *imageURL;
    if(product.thumbnailImageURL != ((id)[NSNull null]))
    {
        imageURL = product.thumbnailImageURL;
    }
    else
    {
        imageURL = @"";
    }
    NSDictionary *cacheDict = [[NSDictionary alloc] initWithObjectsAndKeys:product.name,IMSearchProductName,product.identifier,IMSearchProductID,product.category,IMSearchCatagory, product.manufacturer,IMSearchCompanyName,[NSNumber numberWithBool:product.isPharma],IMIsPharma,imageURL,IMSearchImageURL, nil];
    
    [[IMCacheManager sharedManager] saveActionWithDictionary:cacheDict];
    
    
    
    //TODO:If from table autosuggesstion it directly showing PDP.
//    [self performSegueWithIdentifier:@"IMAutoSuggestionSegue" sender:product];
    
    
    [IMFlurry logEvent:IMAutoSuggestionTapped withParameters:@{}];
    if(product.isPharma)
    {
        [self performSegueWithIdentifier:@"IMPharmaAutoSuggestionSegue" sender:product];
    }
    else
    {
        [self performSegueWithIdentifier:@"IMNonPharmaAutoSuggestionSegue" sender:product];
    }
}

- (IMNonPharmaSearchTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"nonPharmaSearchCell"];
    }
    return _prototypeCell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMPharmaAutoSuggestionSegue"])
    {
        ((IMPharmaDetailViewController*)segue.destinationViewController).product = (IMProduct*) sender;

    }
    if([segue.identifier isEqualToString:@"IMNonPharmaAutoSuggestionSegue"])
    {
        ((IMNonPharmaDetailViewController*)segue.destinationViewController).selectedModel = (IMProduct*) sender;

    }
    if([segue.identifier isEqualToString:@"IMSearchTermSegue"])
    {
        IMSearchResultsViewController* searchResultsController = (IMSearchResultsViewController*)segue.destinationViewController;
        
        searchResultsController.searchTerm = self.searchField.text;
    }
    else if([segue.identifier isEqualToString:@"IMAutoSuggestionSegue"])
    {
        IMSearchResultsViewController* searchResultsController = (IMSearchResultsViewController*)segue.destinationViewController;
        
       // NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        
        IMProduct *product = sender;//[[ self.dataSourceDictionary objectForKey:self.typeArray[indexPath.section] ] objectAtIndex:indexPath.row];
        
        searchResultsController.searchTerm = product.name;
        searchResultsController.categoryName = product.category;

    }
}

#pragma mark - searchBar -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length >= SERACH_AFTER)
    {
        IMPharmacyManager *pharmacyManager = [IMPharmacyManager sharedManager];
        [pharmacyManager cancelAutoSuggestionRequest];
        if(![searchText isEqualToString:@""])
        {
            self.searchMode = IMAutoSuggestion;
            if(self.activityIndicator == nil)
            {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                self.activityIndicator.center = self.view.center;
                self.activityIndicator.color = [UIColor colorWithRed:46.0/255.0 green:89.0/255.0 blue:82.0/255.0 alpha:1.0];
            }
            [self.view addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self setNoContentTitle:@""];
            [pharmacyManager fetchAutoSuggestionsForSearchTerm:searchText withCompletion:^(NSArray *pharmaProducts, NSArray *nonPharmaProducts, NSError *error)
             {
                 [self.activityIndicator removeFromSuperview];
                 if(!error)
                 {
                     //error handling for immediate deleting of charecters before loading.
                     if([self.searchBar.text isEqualToString:@""])
                     {
                         NSLog(@"recently");
                         self.searchMode = IMRecentlySearched;
                         [self downloadFeed];
                     }
                     else
                     {
                         NSLog(@"auto");
                         self.searchMode = IMAutoSuggestion;
                         [self setUpDictionaryWithPharma:pharmaProducts andNonPharma:nonPharmaProducts];
                     }
                 }
                 else
                 {
//                     [self showAlertWithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"error"]];
//                     self.tableView.hidden = YES;
                 }
             }];
        }
        else
        {
            self.searchMode = IMRecentlySearched;
            [self downloadFeed];
        }
    }
    else
    {
        self.searchMode = IMRecentlySearched;
        [self downloadFeed];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSegueWithIdentifier:@"IMSearchTermSegue" sender:self];
}

/**
 @brief To handle clear history action
 @returns void
 */
- (IBAction)clearHistoryPressed:(id)sender {
    
    [[IMCacheManager sharedManager] clearCache];
    [self downloadFeed];
}
#pragma mark - UITextField Delegate Methods -
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"IMSearchTermSegue" sender:self];

    return YES;
}

/**
 @brief To handle search field entry handling
 @returns void
 */
-(IBAction)textFieldTextChanged:(UITextField*)textField
{
    NSString* searchText = textField.text;
    
    if(searchText.length >= SERACH_AFTER)
    {
        IMPharmacyManager *pharmacyManager = [IMPharmacyManager sharedManager];
        [pharmacyManager cancelAutoSuggestionRequest];
        if(![searchText isEqualToString:@""])
        {
            self.searchMode = IMAutoSuggestion;
            if(self.activityIndicator == nil)
            {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                self.activityIndicator.center = self.view.center;
                self.activityIndicator.color = [UIColor colorWithRed:46.0/255.0 green:89.0/255.0 blue:82.0/255.0 alpha:1.0];
            }
            [self.view addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self setNoContentTitle:@""];
            [pharmacyManager fetchAutoSuggestionsForSearchTerm:searchText withCompletion:^(NSArray *pharmaProducts, NSArray *nonPharmaProducts, NSError *error)
             {
                 [self.activityIndicator removeFromSuperview];
                 if(!error)
                 {
                     //error handling for immediate deleting of charecters before loading.
                     if([self.searchField.text isEqualToString:@""])
                     {
                         NSLog(@"recently");
                         self.searchMode = IMRecentlySearched;
                         [self downloadFeed];
                     }
                     else
                     {
                         NSLog(@"auto");
                         self.searchMode = IMAutoSuggestion;
                         [self setUpDictionaryWithPharma:pharmaProducts andNonPharma:nonPharmaProducts];
                     }
                 }
                 else
                 {
                     [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:@"error"]];
                     self.tableView.hidden = YES;
                 }
             }];
        }
        else
        {
            self.searchMode = IMRecentlySearched;
            [self downloadFeed];
        }
    }
    else
    {
        self.searchMode = IMRecentlySearched;
        [self downloadFeed];
    }    
}


@end
