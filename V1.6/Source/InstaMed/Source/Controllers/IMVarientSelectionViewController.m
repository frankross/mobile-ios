//
//  IMVarientSelectionViewController.m
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#define TRANSPARENT_ALPHA       0.0f
#define OVERLAY_ALPHA           0.5f

#import "IMVarientSelectionViewController.h"
#import "IMOptionsTableViewCell.h"
#import "UIView+IMViewSupport.h"
#import "IMVarientSelction.h"
#import "IMVarientSelectionTableViewCell.h"
#import "IMConstants.h"
#import "IMVarientValue.h"
#import "IMVariationTheme.h"
#import "IMVariantUtility.h"

@interface IMVarientSelectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *cotainerView;

@property (weak, nonatomic) IBOutlet UIView *blockingView;

@property(strong,nonatomic) UITapGestureRecognizer* tapGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@end

@implementation IMVarientSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:IMDismissChildViewControllerNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUI
{
    [self.cotainerView slideInForDuration:RTFastAnimDuration delay:RTFastAnimDuration option:UIViewAnimationOptionCurveEaseIn completion:^(BOOL finished) {
        
    }];
    [self.blockingView fadeFromAplha:TRANSPARENT_ALPHA toAlpha:0.5
                            duration:RTFastAnimDuration
                               delay:RTFastAnimDuration
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissOverLay)];
         [self.blockingView addGestureRecognizer:self.tapGesture];
     }];
    
    [self downloadFeed];
}


- (void)fadeOutOverlayWithCompletion:(void (^)(BOOL completed))completion
{
//    [self.blockingView slideOutDuration:RTFastAnimDuration delay:RTFastAnimDuration option:UIViewAnimationOptionCurveEaseIn completion:^(BOOL finished)
//     {
//         completion(finished);
//     }];
    
    [self.cotainerView slideOutForDuration:RTQuickAnimDuration delay:RTNoAnimDelay option:UIViewAnimationOptionCurveEaseIn completion:^(BOOL finished) {
        completion(finished);
    }];
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

-(void)downloadFeed
{
    IMVarientSelction *varientModel = [IMVariantUtility varientSelectionModelfromProduct:self.product isPrimary:self.isPrimary currentSelection:self.selectedVariants];
    //    varientModel.attributeName = @"Size";
    //    IMVarientValue *value1 = [[IMVarientValue alloc] init];
    //    value1.valueName = @"S";
    //    value1.isSelected = YES;
    //    value1.isSupported = YES;
    //    IMVarientValue *value2 = [[IMVarientValue alloc] init];
    //    value2.valueName = @"M";
    //    value2.isSelected = NO;
    //    value2.isSupported = YES;
    //
    //    IMVarientValue *value3 = [[IMVarientValue alloc] init];
    //    value3.valueName = @"L";
    //    value3.isSelected = NO;
    //    value3.isSupported = NO;
    //
    //    IMVarientValue *value4 = [[IMVarientValue alloc] init];
    //    value4.valueName = @"XL";
    //    value4.isSelected = NO;
    //    value4.isSupported = NO;
    
    //    varientModel.supportedValues = @[value1,value2,value3,value4];
    // get the variation theme
    self.selectedModel = varientModel;
    NSLog(@"varientModel.supportedValues = %@",varientModel.supportedValues);
    [self updateUI];
}

-(void)updateUI
{
    // adjust the popup height based the total variants count
    IMVarientSelction *varientModel = (IMVarientSelction*)self.selectedModel;
    if (varientModel.supportedValues.count > 3) {
        self.containerViewHeight.constant = 285.0f;
    }
    else{
        self.containerViewHeight.constant = 176.0f;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = ((IMVarientSelction *)self.selectedModel).attributeName;
    [self.tableView reloadData];
}

-(void)dismissOverLay
{
    [self handleSecondaryVariantPopupTapOutside];
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
              {    [[NSNotificationCenter defaultCenter] removeObserver:self];
                  [self.view removeFromSuperview];
                  [self willMoveToParentViewController:nil];
                  [self removeFromParentViewController];
                  
                  
              }];
             
         }
     }];
}

- (void) handleSecondaryVariantPopupTapOutside
{
    if (self.isPrimary) {
        return;
    }
    IMVarientSelction *model = ((IMVarientSelction *)self.selectedModel);
    if ([self.delegate respondsToSelector:@selector(didSelectVarient:)]) {
        [self.delegate didSelectVarient:model];
    }
}
#pragma mark - Table View DataSource and Delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((IMVarientSelction *)self.selectedModel).supportedValues.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMVarientSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IMVarientSelectionCell" forIndexPath:indexPath];
    IMVarientSelction *model = ((IMVarientSelction *)self.selectedModel);
    cell.nameLabel.text = ((IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row]).valueName;
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //    if(((IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row]).isSelected)
    //    {
    //        cell.imgView.image = [UIImage imageNamed:@"SummaryRadioBtnActive"];
    //        cell.nameLabel.textColor = APP_THEME_COLOR;
    //    }
    //    else
    //    {
    ////        cell.imgView.image = [UIImage imageNamed:@"SummaryRadioBtnInActive"];
    ////        cell.nameLabel.textColor = APP_THEME_COLOR_WITH_ALPHA;
    //    }
    if(!((IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row]).isSupported)
    {
        cell.nameLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgView.image = nil;
    }
    else{
        cell.nameLabel.textColor = APP_THEME_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imgView.image = [UIImage imageNamed:@"SummaryRadioBtnInActive"];
    }
    if(((IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row]).isSelected)
    {
        cell.imgView.image = [UIImage imageNamed:@"SummaryRadioBtnActive"];
        cell.nameLabel.textColor = APP_THEME_COLOR;
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if([self.delegate respondsToSelector:@selector(didS)])
    //    {
    //        [self.delegate retryButtonPressed];
    //    }
    IMVarientSelction *model = ((IMVarientSelction *)self.selectedModel);
    model.selectedVarient = (IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row];
    
    if(((IMVarientValue *)[model.supportedValues objectAtIndex:indexPath.row]).isSupported){
        if ([self.delegate respondsToSelector:@selector(didSelectVarient:)]) {
            [self.delegate didSelectVarient:model];
        }
        [self dismiss];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


@end
