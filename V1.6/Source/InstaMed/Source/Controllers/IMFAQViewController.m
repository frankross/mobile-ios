//
//  IMFAQViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 04/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFAQViewController.h"
#import "IMFAQTableViewCell.h"
#import "RTExpandableTableView.h"
#import "IMFAQ.h"

#import "IMServerManager.h"

#define QUESTION_BOOTOM_CONSTRAINT  15


@interface IMFAQViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *noContentLabel;
@property(strong,nonatomic) IMFAQTableViewCell* protoTypeCell;
@property (weak, nonatomic) IBOutlet UITableView *faqTableView;



@end

@implementation IMFAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"FAQ";
    self.faqTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    [super loadUI];
    self.faqTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self downloadFeed];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.identifier stringValue], @"Faq_Topic_Id",
                                nil];
    [IMFlurry logEvent:IMFAQScreenVisited withParameters:flurryParams];
}

/**
 @brief To download feed
 @returns void
 */

-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] fetchFAQListForID:self.identifier WithCompletion:^(NSDictionary *FAQDictionary, NSError *error)
    {
        [self hideActivityIndicatorView];
        if(error)
        {
            [self handleError:error withRetryStatus:YES];
        }
        else
        {
            self.modelArray = [NSMutableArray array];
            NSArray *faqsArray = [FAQDictionary objectForKey:@"faqs"];
            for(NSDictionary *faqDictionary in faqsArray)
            {
                IMFAQ *faq = [[IMFAQ alloc] initWithDictionary:faqDictionary];
                [self.modelArray addObject:faq];
            }

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

    if(0 == self.modelArray.count)
    {
        [self setNoContentTitle:@"No FAQs found"];
    }
    else
    {
        [self setNoContentTitle:@""];
        self.faqTableView.dataSource = self;
        self.faqTableView.delegate = self;
        [self.faqTableView reloadData];
    }

}

#pragma - mark - TableView data source and delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMFAQTableViewCell* cell = [self.faqTableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    cell.questionLabel.attributedText = [self attributedStringForString: ((IMFAQ*)self.modelArray[indexPath.row]).question];
    //cell.isExpandable = YES;
    if(((IMFAQ*)self.modelArray[indexPath.row]).showingAnswer)
    {
        cell.answerLabel.attributedText =  [self attributedStringForString:((IMFAQ*)self.modelArray[indexPath.row]).answer];
        cell.questionBottomConstraint.constant = QUESTION_BOOTOM_CONSTRAINT;
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(!self.protoTypeCell)
    {
        self.protoTypeCell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    }
    
    self.protoTypeCell.questionLabel.attributedText = [self attributedStringForString: ((IMFAQ*)self.modelArray[indexPath.row]).question];
    //cell.isExpandable = YES;
    
    if(((IMFAQ*)self.modelArray[indexPath.row]).showingAnswer)
    {
        self.protoTypeCell.answerLabel.attributedText = [self attributedStringForString:((IMFAQ*)self.modelArray[indexPath.row]).answer];
        self.protoTypeCell.questionBottomConstraint.constant = QUESTION_BOOTOM_CONSTRAINT;
    }
    else
    {
        self.protoTypeCell.answerLabel.text = @"";
        self.protoTypeCell.questionBottomConstraint.constant = 0;
    }
    
    self.protoTypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.protoTypeCell.bounds));
    
    [self.protoTypeCell setNeedsUpdateConstraints];
    [self.protoTypeCell updateConstraints];
    
    [self.protoTypeCell setNeedsLayout];
    [self.protoTypeCell layoutIfNeeded];
    
   
    
    CGFloat height = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    NSLog(@"%lf",height);

    return height + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSIndexPath* selectedIndexPath = nil;
    
    
    IMFAQ* faq =    (IMFAQ*)self.modelArray[indexPath.row];
    faq.showingAnswer = !faq.showingAnswer;
    
    if(selectedIndexPath && selectedIndexPath.row != indexPath.row)
    {
        faq =    (IMFAQ*)self.modelArray[selectedIndexPath.row];
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

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [tableView setNeedsLayout];
    [tableView layoutIfNeeded];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}


/**
 @brief function to show NO content title label when there is no FAQ's
 @returns void
 */

- (void)setNoContentTitle:(NSString *)title
{
    if([title isEqualToString:@""])
    {
        self.noContentLabel.hidden = YES;
        self.faqTableView.hidden = NO;
    }
    else
    {
        self.noContentLabel.center = CGPointMake(self.view.bounds.size.width/2,  self.view.bounds.size.height/2);
        self.noContentLabel.hidden = NO;
        self.noContentLabel.text = title;
        self.faqTableView.hidden = YES;
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

@end
