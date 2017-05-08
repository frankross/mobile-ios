//
//  IMOrderReminderViewController.m
//  InstaMed
//
//  Created by Arjuna on 02/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderReminderViewController.h"
#import "UIView+IMViewSupport.h"
#import "IMAccountsManager.h"

#define TRANSPARENT_ALPHA       0.0f
#define OVERLAY_ALPHA           0.5f


@interface IMOrderReminderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *daysButton;
@property (weak, nonatomic) IBOutlet UIButton *weeksButton;
@property (weak, nonatomic) IBOutlet UIButton *monthsButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *blockingView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(strong,nonatomic) UITapGestureRecognizer* tapGesture;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation IMOrderReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:IMDismissChildViewControllerNotification object:nil];
    [self loadUI];
}

-(void)loadUI
{
    
    if(!self.count)
       self.count = 1;
    
    if(self.reminderType == IMDay)
    {
       self.daysButton.selected = YES;
    }
    else if(self.reminderType == IMWeek)
    {
        self.weeksButton.selected = YES;
    }
    else if(self.reminderType == IMMonth)
    {
        self.monthsButton.selected = YES;
    }
    
    if(!self.referenceDate)
    {
        self.referenceDate = [NSDate date];
    }
    
    SET_CELL_CORER(self.containerView, 5);

    [self.blockingView fadeFromAplha:TRANSPARENT_ALPHA toAlpha:0.5
                            duration:RTFastAnimDuration
                               delay:RTFastAnimDuration
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapedOutSide)];
         [self.blockingView addGestureRecognizer:self.tapGesture];
     }];
    [self setUpUIForCurrentCount];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUIForCurrentCount
{
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
   // NSDateComponents* dateComponent = [[NSDateComponents alloc] init];
    
    NSTimeInterval interval = 24*3600;
    if(self.daysButton.selected)
    {
        interval = interval * self.count;
    
    }
    else if(self.weeksButton.selected)
    {
        interval = 7 * interval * self.count;
    }
    else
    {
        interval = 30 * interval * self.count;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:interval];//[[NSCalendar currentCalendar] dateByAddingComponents:dateComponent toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM YYYY";
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
                                
}

- (IBAction)reminderUnitButtonPressed:(UIButton*)sender
{
    self.daysButton.selected = NO;
    self.weeksButton.selected  = NO;
    self.monthsButton.selected = NO;
    
    sender.selected = YES;
    [self setUpUIForCurrentCount];
}

- (IBAction)incrementPressed:(id)sender
{
    self.count++;
    [self setUpUIForCurrentCount];
}
- (IBAction)decrementPressed:(id)sender
{
    if(self.count > 1)
    {
        self.count--;
        [self setUpUIForCurrentCount];
    }
}

- (IBAction)donePressed:(id)sender
{
    
    __block NSString* durationUnit = @"";
    
    if(self.daysButton.selected)
    {


        durationUnit = @"day";
    }
    else if(self.weeksButton.selected)
    {
        durationUnit = @"week";
    }
    else if(self.monthsButton.selected)
    {
        durationUnit = @"month";
    }

    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] setReorderReminderForOrder:self.orderId withDuration:[NSString stringWithFormat:@"%ld",(long)self.count] durationUnit:[durationUnit stringByAppendingString:@"s"] completion:^(NSString *message, NSError *error) {
        
        [self hideActivityIndicatorView];
        
        if(!error)
        {
            
            [self showAlertWithTitle:IMReorderReminderSet andMessage:message];
            
            if(self.count > 1)
            {
                durationUnit = [durationUnit stringByAppendingString:@"s"];
            }
            
            if([self.delegate respondsToSelector:@selector(reminderController:didFinshWithFrequencyString:nextDate:)])
            {
                [self.delegate reminderController:self didFinshWithFrequencyString:[NSString stringWithFormat:@"After every %ld %@",(long)self.count,durationUnit] nextDate:[NSString stringWithFormat:@"Next on %@",self.dateLabel.text]];
            }
            
            [self dismiss];
            
        }
        else  if(error.userInfo[IMMessage])
        {
            [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
        }
        else
        {
            [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
    }];
}


- (void)fadeOutOverlayWithCompletion:(void (^)(BOOL completed))completion
{
    [self.blockingView fadeFromAplha:self.blockingView.alpha
                             toAlpha:TRANSPARENT_ALPHA
                            duration:RTQuickAnimDuration
                               delay:RTNoAnimDelay
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         completion(finished);
     }];
}


-(void)tapedOutSide
{
    if([self.delegate respondsToSelector:@selector(reminderController:didFinshWithFrequencyString:nextDate:)])
    {
        [self.delegate reminderController:self didFinshWithFrequencyString:nil nextDate:nil];
    }
    [self dismiss];
}

-(void)dismiss
{
    [self fadeOutOverlayWithCompletion:^(BOOL completed)
     {
         if(completed)
         {
             [self.blockingView removeGestureRecognizer:self.tapGesture];
             [UIView animateWithDuration:0.9f
                              animations:
              ^{
              } completion:^(BOOL finished)
              {
                  [[NSNotificationCenter defaultCenter] removeObserver:self];
                  [self.view removeFromSuperview];
                  [self removeFromParentViewController];
                  
              }];
             
         }
     }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
