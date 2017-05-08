//
//  IMFAQCategoryViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 08/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFAQCategoryViewController.h"
#import "IMFAQViewController.h"
#import "IMFAQTableViewCell.h"
#import "IMFAQCategoryTableViewCell.h"
#import "IMServerManager.h"
#import "IMFAQ.h"
#import "IMHelpTopics.h"

#define QUESTION_BOTTOM_CONSTRAINT  15

static NSString *const IMFAQDetailSegueIdentifier = @"SegueToFaqDetail";

@interface IMFAQCategoryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *faqCategoryTableView;
@property (nonatomic, strong) UILabel *noContentLabel;
@property (nonatomic, strong) NSArray *topQueriesArray;
@property (nonatomic, strong) NSArray *helpTopicsArray;
@property(strong,nonatomic) IMFAQTableViewCell *FAQPrototypeCell;
@property(strong,nonatomic) IMFAQCategoryTableViewCell *helpTopicsPrototypeCell;

@end

@implementation IMFAQCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faqCategoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMFAQTopicScreeenVisited withParameters:@{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**
 @brief To setup UI when screen loads
 @returns void
 */
-(void)loadUI
{
    [super setUpNavigationBar];
    self.faqCategoryTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self downloadFeed];
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] fetchFAQCategoriesWithCompletion:^(NSDictionary *FAQDictionary, NSError *error) {
        [self hideActivityIndicatorView];
        
        if(error)
        {
            [self handleError:error withRetryStatus:YES];
        }
        else
        {
            NSMutableArray *topQueries = [NSMutableArray array];
            NSArray *topQueriesArray = [FAQDictionary objectForKey:@"top_queries"];
            for(NSDictionary *faqDictionary in topQueriesArray)
            {
                    IMFAQ *faq = [[IMFAQ alloc] initWithDictionary:faqDictionary];
                    [topQueries addObject:faq];
                
            }
            self.topQueriesArray = [NSArray arrayWithArray:topQueries];

            NSMutableArray *helpTopics = [NSMutableArray array];
            NSArray *helpTopicsArray = [FAQDictionary objectForKey:@"help_topics"];
            for(NSDictionary *faqDictionary in helpTopicsArray)
            {
                IMHelpTopics *topic = [[IMHelpTopics alloc] initWithDictionary:faqDictionary];
                [helpTopics addObject:topic];
                
            }
            self.helpTopicsArray = [NSArray arrayWithArray:helpTopics];
            [self updateUI];
        }
    }];

}

/**
 @brief To update UI after download feed compltes
 @returns void
 */
-(void)updateUI
{
    if(0 == self.topQueriesArray.count && 0 == self.helpTopicsArray.count)
    {
        [self setNoContentTitle:@"No FAQs found"];
    }
    else
    {
        [self setNoContentTitle:@""];
        [self.faqCategoryTableView reloadData];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = 48;
    
    CGRect frame = CGRectMake(0,0, screenWidth , height);
    CGRect Lframe = CGRectMake(0,0, screenWidth , 30);
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:Lframe];
    titleLabel.textAlignment = NSTextAlignmentCenter;
   if(section == 0)
   {
       titleLabel.text = @"Top queries";
   }
    else
    {
        titleLabel.text = @"Help topics";
    }
    titleLabel.backgroundColor = [UIColor clearColor];
    CGFloat fontSize = 18.0;
    
    titleLabel.font = [UIFont fontWithName:IMHelveticaMedium size:fontSize];
    titleLabel.textColor = [UIColor lightGrayColor];

    [headerView addSubview:titleLabel];
    titleLabel.center = headerView.center;
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.topQueriesArray.count;
    }
    else
    {
        return self.helpTopicsArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{   if((section == 0 && self.topQueriesArray.count > 0) || (section == 1 && self.helpTopicsArray.count >0))
    {
        return 48;
    }
    else
    {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        IMFAQTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
        cell.questionLabel.attributedText = [self attributedStringForString: ((IMFAQ*)self.topQueriesArray[indexPath.row]).question];
        
        if(((IMFAQ*)self.topQueriesArray[indexPath.row]).showingAnswer)
        {
            cell.answerLabel.attributedText =  [self attributedStringForString:((IMFAQ*)self.topQueriesArray[indexPath.row]).answer];
            cell.questionBottomConstraint.constant = QUESTION_BOTTOM_CONSTRAINT;
            cell.questionLabel.textColor = [UIColor darkGrayColor];
            cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
            [UIView animateWithDuration:0.5 animations:^{
                cell.expansionIndicatorImageView.transform = CGAffineTransformMakeRotation( M_PI);
                
            }];
        }
        else
        {
            cell.answerLabel.text = @"";
            cell.questionLabel.textColor = APP_THEME_COLOR; 
            cell.questionBottomConstraint.constant = 0;
            cell.backgroundColor = [UIColor whiteColor];
            [UIView animateWithDuration:0.5 animations:^{
                cell.expansionIndicatorImageView.transform = CGAffineTransformMakeRotation( 0);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        IMFAQCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryTopicCell" forIndexPath:indexPath];
        cell.categoryNameLabel.attributedText = [self attributedStringForString: ((IMHelpTopics*)self.helpTopicsArray[indexPath.row]).name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(!self.FAQPrototypeCell)
        {
            self.FAQPrototypeCell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        }
        
        self.FAQPrototypeCell.questionLabel.attributedText = [self attributedStringForString: ((IMFAQ*)self.topQueriesArray[indexPath.row]).question];
        //cell.isExpandable = YES;
        
        if(((IMFAQ*)self.topQueriesArray[indexPath.row]).showingAnswer)
        {
            self.FAQPrototypeCell.answerLabel.attributedText = [self attributedStringForString:((IMFAQ*)self.topQueriesArray[indexPath.row]).answer];
            self.FAQPrototypeCell.questionBottomConstraint.constant = QUESTION_BOTTOM_CONSTRAINT;
        }
        else
        {
            self.FAQPrototypeCell.answerLabel.text = @"";
            self.FAQPrototypeCell.questionBottomConstraint.constant = 0;
        }
        
        self.FAQPrototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.FAQPrototypeCell.bounds));
        
        [self.FAQPrototypeCell setNeedsUpdateConstraints];
        [self.FAQPrototypeCell updateConstraints];
        
        [self.FAQPrototypeCell setNeedsLayout];
        [self.FAQPrototypeCell layoutIfNeeded];
        
        
        
        CGFloat height = [self.FAQPrototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        NSLog(@"%lf",height);
        
        return height + 1;
    }
    else
    {
        if(!self.helpTopicsPrototypeCell)
        {
            self.helpTopicsPrototypeCell = [tableView dequeueReusableCellWithIdentifier:@"categoryTopicCell"];
        }
        
        self.helpTopicsPrototypeCell.categoryNameLabel.attributedText = [self attributedStringForString: ((IMHelpTopics*)self.helpTopicsArray[indexPath.row]).name];

        
        self.helpTopicsPrototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.helpTopicsPrototypeCell.bounds));
        
        [self.helpTopicsPrototypeCell setNeedsUpdateConstraints];
        [self.helpTopicsPrototypeCell updateConstraints];
        
        [self.helpTopicsPrototypeCell setNeedsLayout];
        [self.helpTopicsPrototypeCell layoutIfNeeded];
        
        
        
        CGFloat height = [self.helpTopicsPrototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        NSLog(@"%lf",height);
        
        return height + 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSIndexPath* selectedIndexPath = nil;
        
        
        IMFAQ* faq =    (IMFAQ*)self.topQueriesArray[indexPath.row];
        faq.showingAnswer = !faq.showingAnswer;
        
        if(selectedIndexPath && selectedIndexPath.row != indexPath.row)
        {
            faq =    (IMFAQ*)self.topQueriesArray[selectedIndexPath.row];
            faq.showingAnswer = NO;
        }
        IMFAQTableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.questionLabel.textColor = APP_THEME_COLOR;
        cell.questionBottomConstraint.constant = 0;
        cell.backgroundColor = [UIColor whiteColor];
        cell.answerLabel.text = @"";
        [UIView animateWithDuration:0.5 animations:^{
            cell.expansionIndicatorImageView.transform = CGAffineTransformMakeRotation( 0);
            
        }];
        selectedIndexPath = indexPath;
        
        //    [tableView reloadData];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView setNeedsLayout];
        [tableView layoutIfNeeded];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }

}



- (NSMutableAttributedString *)attributedStringForString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    //[paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    //Used becoz for textAlign justified
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, [string length])];
    return attributedString;
    
}
/**
 @brief function to show NO content title label when there is no FAQ's categories & help topics
 @returns void
 */
- (void)setNoContentTitle:(NSString *)title
{
    if([title isEqualToString:@""])
    {
        self.noContentLabel.hidden = YES;
        self.faqCategoryTableView.hidden = NO;
    }
    else
    {
        self.noContentLabel.center = CGPointMake(self.view.bounds.size.width/2,  self.view.bounds.size.height/2);
        self.noContentLabel.hidden = NO;
        self.noContentLabel.text = title;
        self.faqCategoryTableView.hidden = YES;
    }
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:IMFAQDetailSegueIdentifier])
    {
        NSIndexPath *selectedIndexPath = [self.faqCategoryTableView indexPathForSelectedRow];
        IMHelpTopics *selectedTopic = self.helpTopicsArray[selectedIndexPath.row];
        IMFAQViewController *destinationVC = [segue destinationViewController];
        destinationVC.identifier = selectedTopic.identifier;
        destinationVC.title = selectedTopic.name;
        
    }
}



@end
