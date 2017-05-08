//
//  IMMoreViewController.m
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMMoreViewController.h"
#import "IMReferAFriendViewController.h"
#import "IMHealthArticlesViewController.h"
#import "IMMoreTableViewCell.h"
#import "IMMoreTaggedTableViewCell.h"
#import "IMSetLocationViewController.h"
#import "IMLocationManager.h"
#import "IMServerManager.h"
#import "IMAccountsManager.h"
#import "IMLoginViewController.h"
#import "IMNotification.h"
#import "IMConstants.h"

static NSString *const IMEmergencyConstantsSegueIdentifier = @"SegueToEmergencyContacts";

@interface IMMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *featuredKeysArray;
@property (nonatomic, strong) NSDictionary *featuredTagValuesDictionary;

@end

@implementation IMMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.featuredKeysArray = [NSArray arrayWithObjects:@"store_locator",@"health_articles",@"refer_a_friend",@"emergency_services",@"faqs",@"privacy_policy",nil];
    self.screenName = @"More_Landing";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMMoreScreenVisited withParameters:@{}];
    [self.tableView reloadData];
}
-(void)loadUI
{
    [super loadUI];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self downloadFeed];
}

-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] fetchFeaturedTagsWithFeaturesDictionary:[self dictionaryForFeaturedItems] withCompletion:^(NSDictionary *responseDict, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.featuredTagValuesDictionary = responseDict[@"features"];
            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
        
    }];
    
}

-(void)updateUI
{
    self.modelArray = [[NSMutableArray alloc] initWithObjects:@"Store locator",@"Health Articles",@"Refer a friend",@"Emergency Services",@"FAQs",@"Privacy policy", nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

-(void)pushToDetailWithNotification:(IMNotification *)notification
{
    UIStoryboard* supportStoryboard = [UIStoryboard storyboardWithName:IMSupportSBName bundle:nil];
    
    if([notification.notificationType isEqualToString:NOTIFICATION_TYPE_SEVENTEEN])
    {
        IMReferAFriendViewController *referAFriendVC = [ supportStoryboard instantiateViewControllerWithIdentifier:IMReferAFriendViewControllerID];
        if( [[IMAccountsManager sharedManager] userToken])
        {

            [self.navigationController pushViewController:referAFriendVC animated:NO];
         
        }
        else
        {
            UIStoryboard *accountStoryboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
            __weak typeof(self)weakSelf = self;
            IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
            loginViewController.loginCompletionBlock = ^(NSError* error ){
                if(!error)
                {
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    [weakSelf.navigationController pushViewController:referAFriendVC animated:NO];
                }
            };
            if(loginViewController)
            {
                [weakSelf.navigationController pushViewController:loginViewController animated:NO];
            }
        }
    }
    else if ([notification.notificationType isEqualToString:NOTIFICATION_TYPE_EIGHTEEN])
    {
        IMHealthArticlesViewController *healthArticlesViewController = [supportStoryboard instantiateViewControllerWithIdentifier:IMHealthArticlesViewControllerID];
        healthArticlesViewController.isDeepLinkingPush = YES;
        healthArticlesViewController.webPageUrl = notification.htmlURL;
        [self.navigationController pushViewController:healthArticlesViewController animated:NO];
    }
}

#pragma mark - Table view data source and delegate methods -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 1;  //only set location Cell
    }
    else
    {
       return self.modelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        IMMoreTableViewCell *cell = (IMMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IMMoreCell" forIndexPath:indexPath];
        cell.titleLAbel.text = @"Set location";
        cell.subTitleLabel.text = ((IMCity *)[IMLocationManager sharedManager].currentLocation).name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        IMMoreTaggedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMMoreTaggedCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.modelArray[indexPath.row];
        NSString *tagValue = [self getFeaturedTagvalueForKey:self.featuredKeysArray[indexPath.row]];
        if(tagValue)
        {
            cell.tagName.hidden = NO;
            [cell.tagName setTitle:[NSString stringWithFormat:@" %@ ",tagValue] forState:UIControlStateNormal];
            
        }
        else
        {
            cell.tagName.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0)
    {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IMSetLocationViewController *SetLocationVC = [storyboard instantiateViewControllerWithIdentifier:@"IMSetLocationVC"];
        [self.navigationController pushViewController:SetLocationVC animated:YES];
        
    }
    else
    {
        switch (indexPath.row) {

            case 0:
                [self performSegueWithIdentifier:@"IMStoreLocatorSegue" sender:nil];
                break;
                
            case 1:
                [IMFlurry logEvent:IMHealthArticleMenuTapped withParameters:@{}];
                [self performSegueWithIdentifier:@"IMSegueToHealthArticles" sender:nil];
                break;
                
            case 2:
                
                if([[IMAccountsManager sharedManager] userToken])
                {
                    [self performSegueWithIdentifier:@"SegueToReferAFriend" sender:nil];
                }
                else
                {
                    UIStoryboard *accountStoryboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    __weak typeof(self)weakSelf = self;
                    IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
                    loginViewController.loginCompletionBlock = ^(NSError* error ){
                        if(!error)
                        {
                            [weakSelf.navigationController popViewControllerAnimated:NO];
                            [weakSelf performSegueWithIdentifier:@"SegueToReferAFriend" sender:nil];
                        }
                    };
                    if(loginViewController)
                    {
                        [weakSelf.navigationController pushViewController:loginViewController animated:YES];
                    }
                }
                
                break;
            case 3:
                [self performSegueWithIdentifier:@"SegueToEmergencyContacts" sender:nil];
                break;
                
            case 4:
                [self performSegueWithIdentifier:@"IMFAQSegue" sender:nil];
                break;

            case 5:
                [self performSegueWithIdentifier:@"IMPrivacyPolicySegue" sender:nil];
                break;
                
            default:
                break;
        }
    }
}

- (NSString *) getFeaturedTagvalueForKey:(NSString *)featuredkey
{
    return [self.featuredTagValuesDictionary objectForKey:featuredkey];
}

- (NSDictionary *) dictionaryForFeaturedItems
{
    return  @{@"features": [NSArray arrayWithArray:self.featuredKeysArray] };
}

@end
