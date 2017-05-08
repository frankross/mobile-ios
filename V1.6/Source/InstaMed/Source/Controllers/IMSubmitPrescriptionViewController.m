//
//  IMSubmitPrescriptionViewController.m
//  InstaMed
//
//  Created by Suhail K on 11/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSubmitPrescriptionViewController.h"
#import "IMPrescriptionSuccessViewController.h"
#import "IMAccountsManager.h"
#import "IMCart.h"


@interface IMSubmitPrescriptionViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (nonatomic) CGFloat lastZoomScale;

- (IBAction)submitPressed:(UIButton *)sender;

- (IBAction)retakePressed:(UIButton *)sender;
@end

@implementation IMSubmitPrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.imageView.image = self.selectedImage;
    self.scrollView.delegate = self;
    [self updateZoom];
}


-(void)loadUI
{
    [self setUpNavigationBar];
   
    SET_CELL_CORER(self.submitButton, 10.0);
    [IMFunctionUtilities setBackgroundImage:self.submitButton withImageColor:APP_THEME_COLOR];
    SET_CELL_CORER(self.retakeButton, 10.0);
    SET_FOR_YOU_CELL_BORDER(self.retakeButton,APP_THEME_COLOR,8.0);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMUploadSuccessSegue"])
    {
        IMPrescriptionSuccessViewController *successVC = (IMPrescriptionSuccessViewController *) segue.destinationViewController;
        successVC.selectedImage  = self.selectedImage;
        successVC.cart = self.cart;
    }
}

/**
 @brief To handle submit button action in revise order flow
 @returns void
 */
- (IBAction)submitPressedForReviseOrder:(UIButton *)sender
{
    [self showActivityIndicatorView];
    __weak IMSubmitPrescriptionViewController* weakSelf = self;
    [[IMAccountsManager sharedManager] uploadPrescriptionForOrderRevise:weakSelf.selectedImage withCompletion:^(NSNumber *prescriptionId, NSError *error) {
        [weakSelf hideActivityIndicatorView];
        if(!error)
        {
            if(weakSelf.navigationController.topViewController == weakSelf)
            {
                [weakSelf performSegueWithIdentifier:@"IMUploadSuccessSegue" sender:nil];
            }
        }
        else if(error.userInfo[IMMessage])
        {
            [weakSelf showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
        }
        else if (error.code == kCFNetServiceErrorTimeout || error.code == kCFURLErrorNotConnectedToInternet ||  error.code == kCFURLErrorNetworkConnectionLost)
        {
            [weakSelf showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
        }
        else
        {
            [weakSelf showAlertWithTitle:@"" andMessage:IMGeneralRequestFailureMessage];
        }
    }];
}

/**
 @brief To handle submit button action
 @returns void
 */
- (IBAction)submitPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMUploadPrescriptionEvent withParameters:@{}];
     // order revise flow
    if (self.cart != nil && !self.cart.isNewOrder) {
        [self submitPressedForReviseOrder:sender];
    }
    else{
        [self showActivityIndicatorView];
        
        __weak IMSubmitPrescriptionViewController* weakSelf = self;
        
        BOOL status;
        if(self.prescriptionType == IMFromOrder)
        {
            status = NO;
        }
        else if (self.prescriptionType == IMFromOthers)
        {
            status = YES;
        }
        
        [[IMAccountsManager sharedManager] uploadPrescription:weakSelf.selectedImage andCartCreationStatus:status withCompletion:^(NSNumber *prescriptionId, NSError *error) {
            [weakSelf hideActivityIndicatorView];
            if(!error)
            {
                if(weakSelf.navigationController.topViewController == weakSelf)
                {
                    [weakSelf performSegueWithIdentifier:@"IMUploadSuccessSegue" sender:nil];
                }
            }
            else if(error.userInfo[IMMessage])
            {
                [weakSelf showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
            }
            else if (error.code == kCFNetServiceErrorTimeout || error.code == kCFURLErrorNotConnectedToInternet ||  error.code == kCFURLErrorNetworkConnectionLost)
            {
                [weakSelf showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
            }
            else
            {
                [weakSelf showAlertWithTitle:@"" andMessage:IMGeneralRequestFailureMessage];
            }
        }];
    }
}

/**
 @brief To handle retake button action
 @returns void
 */
- (IBAction)retakePressed:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(retakePressedWithPicMode:)])
    {
        [self.delegate retakePressedWithPicMode:self.selectedPicMode];
    }
    [self.navigationController popViewControllerAnimated:YES];
  
}

/**
 @brief To handle image zooming
 @returns void
 */
- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraints];
}

- (void) updateConstraints {
    float imageWidth = self.imageView.image.size.width;
    float imageHeight = self.imageView.image.size.height;
    
    float viewWidth = self.view.bounds.size.width;
    float viewHeight = self.scrollView.bounds.size.height;
    
    // center image if it is smaller than screen
    float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.constraintLeft.constant = hPadding;
    self.constraintRight.constant = hPadding;
    
    self.constraintTop.constant = vPadding;
    self.constraintBottom.constant = vPadding;
    
    [self.view layoutIfNeeded];
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void) updateZoom {
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                        self.view.bounds.size.height / self.imageView.image.size.height);
    
    if (minZoom > 1) minZoom = 1;
    
    self.scrollView.minimumZoomScale = minZoom;
    
    // Force scrollViewDidZoom fire if zoom did not change
    if (minZoom == self.lastZoomScale) minZoom += 0.000001;
    
    self.lastZoomScale = self.scrollView.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

/**
 @brief To handle image zoom in double tap
 @returns void
 */
- (IBAction)doubleTapped:(UITapGestureRecognizer *)sender
{
    CGPoint pointInView = [sender locationInView:self.imageView];
    float newZoomScale = self.scrollView.zoomScale * 1.5;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    CGSize scrollViewize = self.scrollView.bounds.size;
    float w = scrollViewize.width / newZoomScale;
    float h = scrollViewize.height / newZoomScale;
    float x = pointInView.x - (w / 2.0);
    float y = pointInView.y - (h / 2.0);
    CGRect rectToZoom = CGRectMake(x,y, w, h);
    [self.scrollView zoomToRect:rectToZoom animated:YES];
}

@end
