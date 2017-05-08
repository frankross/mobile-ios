//
//  IMPrescriptionDetailViewController.m
//  InstaMed
//
//  Created by Suhail K on 28/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionDetailViewController.h"
#import "IMPrescription.h"
#import "IMPatient.h"
#import "IMDoctor.h"
#import "IMProductDosage.h"
#import "IMPrescriptionCollectionViewCell.h"
#import "IMproductDosageTableViewCell.h"
#import "IMAccountsManager.h"
#import "IMPDPTextDetailViewController.h"
#import "IMProduct.h"
#import "IMPharmaDetailViewController.h"
#import "IMCartManager.h"

@interface IMPrescriptionDetailViewController ()< UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *patientViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *doctorViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expireLabelWidthConstraint;

- (IBAction)doctorExpantionPressed:(UIButton *)sender;
- (IBAction)patientExpantionPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarktopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *referenceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *isExpiredLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *patientnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientGenderLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorRegNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *facilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceNumberLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger previousIndex;
@property (assign, nonatomic) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIView *doctorDetail;
@property (weak, nonatomic) IBOutlet UIView *patientDetails;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;

- (IBAction)orderPressed:(id)sender;

- (IBAction)deletePrescriptionPressed:(id)sender;

@property (nonatomic, strong) NSArray *collectionViewImageList;

@property (nonatomic, strong) NSMutableArray *dosageMedicineList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) IMproductDosageTableViewCell *prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *symptomsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diagnosisHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prescribedHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *symptomsView;
@property (weak, nonatomic) IBOutlet UIView *diagnosisView;
@property (weak, nonatomic) IBOutlet UIView *testPrescribedView;
@property (weak, nonatomic) IBOutlet UIView *notesAndDirectionView;

@property (nonatomic, assign) CGFloat doctorViewHeight;
@property (nonatomic, assign) CGFloat patientViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBottomConstraint;
@end

@implementation IMPrescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMPrescriptionDetailTimeSpend withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMPrescriptionDetailScreenVisited withParameters:@{}];
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMPrescriptionDetailTimeSpend withParameters:@{}];
}

-(void)loadUI
{
    [self setUpNavigationBar];
    [IMFunctionUtilities setBackgroundImage:self.orderButton withImageColor:APP_THEME_COLOR];
        self.dosageMedicineList = [[NSMutableArray alloc] init];
    self.patientViewHeightConstraint.constant = 0;
    self.doctorViewHeightConstraint.constant = 0;
    self.previousIndex = -1;
    self.currentIndex = 0;
    [self sizeHeaderToFit];
    [self downloadFeed];
}

/**
 @brief To download feeds
 @returns void
 */
-(void)downloadFeed
{
    
// Dummy data
    
//    self.collectionViewImageList = [[NSArray alloc]
//                                    initWithObjects:@"Morning",@"Afternoon",@"Evening",@"Night",@"Recurse", nil];

//    IMPrescription *prescriptionModel = [[IMPrescription alloc] init];
//    prescriptionModel.referenceNumber = [NSNumber numberWithInt:302010];
//    prescriptionModel.date = @"05 Jun 2015";
//    prescriptionModel.expiryDate = @"10 Dec 2015";
//    
//    IMPatient *patient = [[IMPatient alloc] init];
//    patient.name = @"Suresh Bhattacharya";
//    patient.age = @"50 Yrs";
//    patient.height = @"180 cms";
//    patient.weight = @"68 Kgs";
//    patient.gender = @"Male";
//    prescriptionModel.patient = patient;
//    IMDoctor *doctor = [[IMDoctor alloc] init];
//    doctor.name =  @"Dr. Rajesh Ghosh";
//    doctor.regNumber = @"56467";
//    doctor.speciality = @"Dermatology";
//    doctor.phone = @"0345768990";
//    doctor.mobile = @"9865765434";
//    doctor.facility = @"Fortis Hospital";
//    IMAddress *address = [[IMAddress alloc] init];
//    address.addressLine1 = @"111A, Rash Behari Avenue,Gariahat, Kolkata, West Bengal";
//    address.pinCode = [NSNumber numberWithInt:700029];
//    doctor.address = address;
//    prescriptionModel.doctor = doctor;
//    prescriptionModel.isExpired = NO;
//    
//    IMProductDosage *dosage1 = [[IMProductDosage alloc] init];
//    dosage1.productName = @"Acnoff Ant-Acne Bar";
//    dosage1.quantity = @"20ml";
//    dosage1.whenToTake = @"Before food";
//    dosage1.timings = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",nil];
//
//    dosage1.duration = @"10";
//    
//    IMProductDosage *dosage2 = [[IMProductDosage alloc] init];
//    dosage2.productName = @"Apresol";
//    dosage2.quantity = @"1 tablet";
//    dosage2.whenToTake = @"Before food";
//    dosage2.timings = [[NSArray alloc] initWithObjects:@"0",@"2",@"3",nil];
//    dosage2.duration = @"10";
//    
//    prescriptionModel.dosageList = [[NSArray alloc] initWithObjects:dosage1,dosage2,nil];
//    self.selectedModel = prescriptionModel;
    
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] fetchPrescriptionDetailWithId:self.prescriptionId completion:^(IMPrescription *prescription, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.selectedModel = prescription;
            [self updateUI];
        }
        else
        {
//            [self showAlertWithTitle:IMError andMessage:error.userInfo[IMMessage]];
            [self handleError:error withRetryStatus:YES];
            self.tableView.hidden = YES;
        }
    }];
}

/**
 @brief To update UI after downloading
 @returns void
 */
-(void)updateUI
{
    IMPrescription *model = (IMPrescription *) self.selectedModel;
    self.dosageMedicineList = model.dosageList;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.hidden = NO;

    //self.tableViewHeightConstraint.constant = self.dosageMedicineList.count * 130;
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView layoutIfNeeded];
    }];
    NSString *remarks;
    if(![model.remarks isEqualToString:@""])
    {
        remarks = [NSString stringWithFormat:@"Remarks: %@", model.remarks];
        self.remarkBottomConstraint.constant = 10;
        self.remarktopConstraint.constant = 10;
    }
    else
    {
        remarks = @"";
        self.remarkBottomConstraint.constant = 0;
        self.remarktopConstraint.constant = 0;
    }

    self.remarksLabel.attributedText = [self attributedStringForString:remarks];
    self.remarksLabel.preferredMaxLayoutWidth = self.tableView.frame.size.width - 40.0f;
//    [self.remarksLabel sizeToFit];
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
//    // NSString class method: boundingRectWithSize:options:attributes:context is
//    // available only on ios7.0 sdk.
//    CGRect rect = [model.remarks boundingRectWithSize:CGSizeMake(self.tableView.frame.si, CGFLOAT_MAX)
//                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:attributes
//                                              context:nil];
//    
//    self.remarksHeightConstraint.constant = rect.size.height;
    
    
    [self.tableView reloadData];
   
    if (!model.identifier)
    {
        NSString *prescriptionNo = @"Prescription no: ";
        NSString *notAvailable = IMNotAvailable;
        NSString * referenceNum = [NSString stringWithFormat:@"%@%@", prescriptionNo,notAvailable];
        
        NSMutableAttributedString* referenceString = [[NSMutableAttributedString alloc] initWithString:referenceNum];
        [referenceString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,prescriptionNo.length)];
        [referenceString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(prescriptionNo.length,notAvailable.length)];
        self.referenceIdLabel.attributedText = referenceString;
    }
    else
    {
         self.referenceIdLabel.text = [NSString stringWithFormat:@"Prescription no: %@",model.identifier];
    }
    
    if (model.referenceNumber && ![model.referenceNumber isEqualToString:@""])
    {
        self.referenceNumberLabel.text = [NSString stringWithFormat:@"Ref:%@", model.referenceNumber];
    }
    else
    {
        self.referenceNumberLabel.text = @"Ref no: NA";
    }

    if(model.date != nil && model.date.length > 0){
        NSMutableAttributedString *attString =[[NSMutableAttributedString alloc]
                                               initWithString:model.date];
        UIFont *mediumFont = [UIFont fontWithName:IMHelveticaMedium size:16];
        [attString setAttributes:@{NSFontAttributeName: mediumFont} range:NSMakeRange(0, model.date.length)];
        self.dateLabel.attributedText = attString;
    }
    else{
        self.dateLabel.text = @"";
    }
    
    if(model.expiryDate != nil)
    {
        self.expiryDateLabel.text = model.expiryDate;
    }
    else{
        self.expiryDateLabel.text = @"";
    }
    if(model.isExpired)
    {
        self.isExpiredLabel.text = @"Expired";
        self.expireLabelWidthConstraint.constant = 52;
    }
    else
    {
        self.isExpiredLabel.text = @"";
        self.expireLabelWidthConstraint.constant = 0;
    }
    
    self.patientnameLabel.text = model.patient.name;
    self.patientAgeLabel.text = model.patient.age;
    self.patientHeightLabel.text = model.patient.height;
    self.patientWeightLabel.text = model.patient.weight;
    self.patientGenderLabel.text = model.patient.gender;
    
    self.doctorNameLabel.text = model.doctor.name;
    self.doctorRegNumberLabel.text =  model.doctor.regNumber;
    self.specialityLabel.text =  model.doctor.speciality;
    self.doctorPhoneLabel.text =  model.doctor.phone;
    self.doctorMobileLabel.text =  model.doctor.mobile;
    self.facilityLabel.text =  model.doctor.facility;
    self.addressLabel.text = model.doctor.address;

    
//    self.doctorViewHeightConstraint.constant = 0.0f;
//    self.patientViewHeightConstraint.constant = 0.0f;
    NSArray *labels = @[self.patientnameLabel, self.patientAgeLabel, self.patientHeightLabel, self.patientGenderLabel, self.patientWeightLabel, self.doctorNameLabel,self.doctorRegNumberLabel, self.specialityLabel,self.doctorPhoneLabel,self.doctorMobileLabel,self.facilityLabel, self.addressLabel];
    
    for (UILabel *label in labels)
    {
        [self checkForBlank:label];
    }
    
    [self configureFooter];
    [self getViewHeight];
    [self sizeHeaderToFit];
    [self sizeFooterToFit];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView Datasource and delegate Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dosageMedicineList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMproductDosageTableViewCell* dosageCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMProductDosageCell" forIndexPath:indexPath];
    IMProductDosage *model = [self.dosageMedicineList objectAtIndex:indexPath.row];
    dosageCell.model = model;
    dosageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return dosageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMProductDosage *model = [self.dosageMedicineList objectAtIndex:indexPath.row];

    self.prototypeCell.model = model;
    [self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IMProductDosage *model = [self.dosageMedicineList objectAtIndex:indexPath.row];
//
//    if(model.identifier)
//    {
//        IMProduct *product = [[IMProduct alloc] init];
//        product.identifier = model.identifier;
//        
//        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        IMPharmaDetailViewController* pharmaVC = [storyboard instantiateViewControllerWithIdentifier:@"IMPharmaViewController"];
//        pharmaVC.product = product;
//        [self.navigationController pushViewController:pharmaVC animated:YES];
//    }
//    else
//    {
//        [self showAlertWithTitle:@"No product" andMessage:@"Product unavailable"];
//    }
}

- (IMproductDosageTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMProductDosageCell"];
    }
    return _prototypeCell;
}

/**
 @brief To handle patient expansion action
 @returns void
 */
- (IBAction)patientExpantionPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.patientViewHeightConstraint.constant == 0)
        {
            self.patientDetails.alpha = 1.0f;
            self.patientViewHeightConstraint.constant = self.patientViewHeight;
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            self.patientDetails.alpha = 0.0f;
            self.patientViewHeightConstraint.constant = 0;
            sender.transform = CGAffineTransformMakeRotation(0);
            
        }
        [self sizeHeaderToFit];
    }completion:^(BOOL finished) {
        
    }];
}

/**
 @brief To handle doctor expansion action
 @returns void
 */
- (IBAction)doctorExpantionPressed:(UIButton *)sender
{

    [UIView animateWithDuration:0.5 animations:^{
        if (self.doctorViewHeightConstraint.constant == 0)
        {
            self.doctorDetail.alpha = 1.0f;
            self.doctorViewHeightConstraint.constant = self.doctorViewHeight;
            sender.transform = CGAffineTransformMakeRotation(M_PI);
            
        }
        else
        {
            self.doctorDetail.alpha = 0.0f;
            self.doctorViewHeightConstraint.constant = 0;
            sender.transform = CGAffineTransformMakeRotation(0);
            
        }
         [self sizeHeaderToFit];
    }completion:^(BOOL finished) {
        
    }];
    
}

/**
 @brief To handle order button action 
 @returns void
 */
- (IBAction)orderPressed:(id)sender
{
    [IMFlurry logEvent:IMOrderFromPrescription withParameters:@{}];

    IMPrescription* prescription  = (IMPrescription*)self.selectedModel;
    if(prescription.doctor.name && ![prescription.doctor.name isEqualToString:@""])
    {
        [IMCartManager sharedManager].doctorName = prescription.doctor.name;
        
    }
    if(prescription.patient.name && ![prescription.patient.name isEqualToString:@""])
    {
        [IMCartManager sharedManager].patientName = prescription.patient.name;
        
    }

    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] orderFromPrescription:prescription withCompletion:^(NSError *error) {
        
        [self hideActivityIndicatorView];
        if(error)
        {
            [self handleError:error withRetryStatus:NO];
        }
        else
        {

            [self loadCart:self];
        }

        
    }];
}

- (IBAction)deletePrescriptionPressed:(id)sender
{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    IMPrescription* prescription = (IMPrescription*)self.selectedModel;
    
    if([segue.identifier isEqualToString:@"IMSymptomsSegue"])
    {
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = prescription.symptoms;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).title = IMSymptoms;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"IMDiagnosisSegue"])
    {
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = prescription.diagnosis;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).title =IMDiagnosis;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

        
    }
    else if([segue.identifier isEqualToString:@"IMTestPrescribedSegue"])
    {
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = prescription.testsPrescribed;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).title = IMTestPrescribed;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

        
    }
    else if([segue.identifier isEqualToString:@"IMNotesAndDirectionsSegue"])
    {
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = prescription.notesAndDirections;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).title = IMNotesAndDirections;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
}


// To reset the tableview header frame.
- (void)sizeHeaderToFit
{
    UIView *header = self.tableView.tableHeaderView;
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    frame.size.height = height;
    header.frame = frame;
    self.tableView.tableHeaderView = header;
    [header layoutIfNeeded];
}

// To reset the tableview footer frame.

- (void)sizeFooterToFit
{
    UIView *footer = self.tableView.tableFooterView;
    [footer setNeedsLayout];
    [footer layoutIfNeeded];
    CGFloat height = [footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footer.frame;
    frame.size.height = height;
    footer.frame = frame;
    self.tableView.tableFooterView = footer;
}

// To get the doctor and patient views height.

- (void)getViewHeight
{
    [self.doctorDetail removeConstraint:self.doctorViewHeightConstraint];
    [self.patientDetails removeConstraint:self.patientViewHeightConstraint];

    [self.patientnameLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.patientnameLabel.frame)];
    [self.doctorNameLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.doctorNameLabel.frame)];
    self.addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.addressLabel.frame);
    [self.doctorDetail setNeedsLayout];
    [self.doctorDetail layoutIfNeeded];
    self.doctorViewHeight = [self.doctorDetail systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    [self.patientDetails setNeedsLayout];
    [self.patientDetails layoutIfNeeded];
    self.patientViewHeight = [self.patientDetails systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    [self.doctorDetail removeConstraint:self.addressBottomConstraint];
    [self.patientDetails removeConstraint:self.genderBottomConstraint];

    [self.doctorDetail addConstraint:self.doctorViewHeightConstraint];
    [self.patientDetails addConstraint:self.patientViewHeightConstraint];
    
}

 - (void)configureFooter
{
    IMPrescription* prescription = (IMPrescription*)self.selectedModel;
    if (!prescription.symptoms || [prescription.symptoms isEqualToString:@""])
    {
        self.symptomsView.hidden = YES;
        self.symptomsHeightConstraint.constant = 0.0f;
    }
    
    if (!prescription.diagnosis || [prescription.diagnosis isEqualToString:@""])
    {
        self.diagnosisView.hidden = YES;
        self.diagnosisHeightConstraint.constant = 0.0f;
    }
    
    if (!prescription.testsPrescribed || [prescription.testsPrescribed isEqualToString:@""])
    {
        self.testPrescribedView.hidden = YES;
        self.prescribedHeightConstraint.constant = 0.0f;
    }
    
    if (!prescription.notesAndDirections || [prescription.notesAndDirections isEqualToString:@""])
    {
        self.notesAndDirectionView.hidden = YES;
        self.testHeightConstraint.constant = 0.0f;
    }
}

- (void)checkForBlank:(UILabel *)label
{
    if ([label.text isEqualToString:@""] || label.text == nil) {
        label.text = @"-";
    }
}
@end
