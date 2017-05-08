//
//  IMUploadPrescriptionViewController.m
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMUploadPrescriptionViewController.h"
#import "IMSubmitPrescriptionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "IMCart.h"
#import "IMAccountsManager.h"


@interface IMUploadPrescriptionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property(nonatomic, strong) UIImage *selectedPrescriptionImage;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveDescriptionLabel;

@property(nonatomic, assign) IMPicMode picMode;

- (IBAction)cameraButtonPressed:(UIButton *)sender;
- (IBAction)galleryButtonPressed:(UIButton *)sender;

@end

@implementation IMUploadPrescriptionViewController

static ALAssetsLibrary * library = nil ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMUploadPrescriptionVisit withParameters:@{}];
}
/**
 @brief To handle initial UI element setup
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
    
    SET_CELL_CORER(self.cameraButton,8.0);
    SET_CELL_CORER(self.galleryButton,8.0);
    SET_CELL_CORER(self.oneLabel, 8.0);
    SET_CELL_CORER(self.twoLabel, 8.0);
    [IMFunctionUtilities setBackgroundImage:self.cameraButton withImageColor:APP_THEME_COLOR];
    [IMFunctionUtilities setBackgroundImage:self.galleryButton withImageColor:APP_THEME_COLOR];
    
    library = [[ALAssetsLibrary alloc] init];
    
    if(self.prescriptionType == IMFromOrder)
    {
        self.titleLabel.text = IMUploadPrescriptionForOrderTitle;
        self.oneDescriptionLabel.attributedText = [self attributedStringForString: IMUploadPrescriptionForOrderPoint1];
        self.twoDescriptionLabel.attributedText =  [self attributedStringForString:IMUploadPrescriptionForOrderPoint2];
        self.threeDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForOrderPoint3];
        self.fourDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForOrderPoint4];
        self.fiveDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForOrderPoint5];
    }
    else
    {
        self.titleLabel.text = IMUploadPrescriptionForNormalTitle;
        self.oneDescriptionLabel.attributedText = [self attributedStringForString: IMUploadPrescriptionForNormalPoint1];
        self.twoDescriptionLabel.attributedText =  [self attributedStringForString:IMUploadPrescriptionForNormalPoint2];
        self.threeDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForNormalPoint3];
        self.fourDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForNormalPoint4];
        self.fiveDescriptionLabel.attributedText = [self attributedStringForString:IMUploadPrescriptionForNormalPoint5];
    
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 @brief To handle back button action
 @returns void
 */
-(void)backPressed
{

    if([IMAccountsManager sharedManager].currentPrescriptionUploadId !=nil || [IMAccountsManager sharedManager].currentRevisePrescriptionUploadId !=nil)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:IMPrescriptionNotCompleteMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//        alert.tag = 200;
//        [alert show];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:IMPrescriptionNotCompleteMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction
                                       actionWithTitle:@"Yes"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (self.cart != nil && !self.cart.isNewOrder) {
                                               [self donePressedForOrderRevise];
                                           }
                                       }];
        UIAlertAction *noAction = [UIAlertAction
                                    actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        [self showActivityIndicatorView];
                                        [[IMAccountsManager sharedManager] completePrescriptionUploadWithCompletion:^(NSError *error) {
                                            [self hideActivityIndicatorView];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
                                            if(!error)
                                            {
                                            }
                                        }];
                                    }];
        
        
        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
#pragma mark - Image Picker -

/**
 @brief To handle camera button action
 @returns void
 */
- (IBAction)cameraButtonPressed:(UIButton *)sender {
    
    [IMFlurry logEvent:IMPhotoTapped withParameters:@{}];
    self.picMode = IMCamera;
    [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
}

/**
 @brief To handle gallery button action
 @returns void
 */
- (IBAction)galleryButtonPressed:(UIButton *)sender {
    [IMFlurry logEvent:IMGalleryTapped withParameters:@{}];

    self.picMode = IMGallery;
    [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void) displayImagePickerWithSource:(UIImagePickerControllerSourceType)source;
{
    if([UIImagePickerController isSourceTypeAvailable:source])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:source];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGFloat width;
    CGFloat height;
    //Restrictiong image resolution
    if(image.size.width > image.size.height)
    {
        width = 1000.0;
        height = 750.0;
    }
    else
    {
        width = 750.0;
        height = 1000.0;
    }
    
    self.selectedPrescriptionImage = [self imageWithImage:image scaledToSize:CGSizeMake(width, height)];
    
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
       [self addImage:self.selectedPrescriptionImage toAlbum:IMPhotoAlbumName withCompletionBlock:^(BOOL status) {
       }];
    }
  
    [self performSegueWithIdentifier:@"IMSubmitPrescriptionSegue" sender:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 @brief To add selected image to the album
 @returns void
 */
-(void) addImage:(UIImage *) image toAlbum:(NSString *)albumName withCompletionBlock :(void (^)( BOOL)) completionBlock ;
{
    if(image)
    {
        [library saveImage:image toAlbum:albumName withCompletionBlock:^(NSError *error) {
            if(!error)
            {
                completionBlock(YES);
            }
            else
            {
                
                completionBlock(YES);
            }
        }];
    }
    
}

#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMSubmitPrescriptionSegue"])
    {
        IMSubmitPrescriptionViewController *submitVC = (IMSubmitPrescriptionViewController *) segue.destinationViewController;
        submitVC.selectedImage  = self.selectedPrescriptionImage;
        submitVC.selectedPicMode = self.picMode;
        submitVC.prescriptionType = self.prescriptionType;
        submitVC.delegate = self;
        submitVC.cart = self.cart;
    }
}

/**
 @brief To handle retake button action
 @returns void
 */
- (void)retakePressedWithPicMode:(IMPicMode)picMode
{
    if (picMode == IMCamera) {
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];

    }
    else{
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];

    }

}

/**
 @brief To handle done button action
 @returns void
 */
- (void)donePressedForOrderRevise
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] completePrescriptionUploadForOrderReviseWithCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
        if(!error)
        {
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200)
    {
        if(0 == buttonIndex)
        {
            // order revise flow
            if (self.cart != nil && !self.cart.isNewOrder) {
                [self donePressedForOrderRevise];
            }
            else
            {
                [self showActivityIndicatorView];
                [[IMAccountsManager sharedManager] completePrescriptionUploadWithCompletion:^(NSError *error) {
                    [self hideActivityIndicatorView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
                    if(!error)
                    {
                    }
                }];
            }
        }
    }
}

@end
