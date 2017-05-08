//
//  IMPrescriptionListViewController.m
//  InstaMed
//
//  Created by Suhail K on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionListViewController.h"
#import "IMPrescriptionCollectionViewCell.h"
#import "IMPrescription.h"
#import "IMPrescriptionTableViewCell.h"
#import "IMPatient.h"
#import "IMDoctor.h"
#import "IMAccountsManager.h"
#import "IMApptentiveManager.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import "IMPrescriptionDetailViewController.h"
#import "IMTransperentTouchView.h"
#import"IMUploadPrescriptionViewController.h"
#import "IMPrescriptionFilterViewController.h"

@interface IMPrescriptionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) BOOL isPrescriptionPresented;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prescriptionBtnToTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;
@property (weak, nonatomic) IBOutlet IMTransperentTouchView *transperentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadPrescriptionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (nonatomic, strong) IMPrescriptionTableViewCell *prototypeCell;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (weak, nonatomic) IBOutlet IMTransperentTouchView *prescriptionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)uploadPrescriptionPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *simplyUploadLabel;
@property (strong, nonatomic) NSMutableArray *patientList;
@property (strong, nonatomic) NSMutableArray *doctorList;

@property (strong, nonatomic) NSMutableArray *selectedPatientList;
@property (strong, nonatomic) NSMutableArray *selectedDoctorList;
@property (strong, nonatomic) NSMutableArray *tempModalArray;
@property (nonatomic, assign) BOOL isNeedToReload;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation IMPrescriptionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedToReload = YES;
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMPrescriptionListTimeSpend withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMPescriptionsScreenVisited withParameters:@{}];
    //To handle deeplinking push
    if(self.isDeepLinkingPush)
    {
        if(self.identifier)
        {
            [self performSegueWithIdentifier:@"IMPrescriptionDetailSegue" sender:nil];
            self.isNeedToReload = YES;
        }
    }
   else if(self.isNeedToReload)
    {
        self.scrollView.hidden = YES;
        self.filterButton.enabled = NO;
        [self.selectedDoctorList removeAllObjects];
        [self.selectedPatientList removeAllObjects];
        [self downloadFeed];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadDone:)
                                                 name:@"IMUploadDone"
                                               object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMApptentiveManager sharedManager] logPrescriptionScreenVisitedEventFromViewController:self];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMPrescriptionListTimeSpend withParameters:@{}];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.isFilterPush = NO;
}

- (void)uploadDone:(NSNotification *)notification
{
    if (self.isPrescriptionPresented) {
        self.isPrescriptionPresented = NO;
        [self.navigationController popToViewController:self animated:YES];
    }
}

-(void)loadUI
{
    [self setUpNavigationBar];
    self.selectedPatientList = [NSMutableArray array];
    self.selectedDoctorList = [NSMutableArray array];
    SET_CELL_CORER(self.uploadPrescriptionButton, 5.0);

    [IMFunctionUtilities setBackgroundImage:self.uploadPrescriptionButton withImageColor:APP_THEME_COLOR];
    self.modelArray = [[NSMutableArray alloc] init];
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
//    self.images = [[NSMutableArray alloc] initWithObjects:@"Pres1",@"Pres2",@"Pres3",@"Pres1", nil];
//    IMPrescription *prescriptionModel = [[IMPrescription alloc] init];
//    prescriptionModel.referenceNumber = [NSNumber numberWithInt:302010];
//    prescriptionModel.date = @"05 Jun 2015";
//    prescriptionModel.expiryDate = @"10 Dec 2015";
//    
//    IMPatient *patient = [[IMPatient alloc] init];
//    patient.name = @"Suresh Bhattacharya";
//    prescriptionModel.patient = patient;
//    IMDoctor *doctor = [[IMDoctor alloc] init];
//    doctor.name =  @"Dr. Rajesh Ghosh";
//    prescriptionModel.doctor = doctor;
//    
//    prescriptionModel.isExpired = YES;
//    prescriptionModel.dosageList = [[NSArray alloc] initWithObjects:@"Acnoff Ant-Acne Bar",@"Apresol",@"dummy dosage",@"Test dosage", nil];
//    [self.modelArray addObject:prescriptionModel];
    
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] fetchPresciptionsWithCompletion:^(NSArray *undigitisedPrescriptionImages, NSMutableArray *digitisedPrescriptions, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.images = [undigitisedPrescriptionImages mutableCopy];
            self.modelArray = digitisedPrescriptions;
            self.tempModalArray =  [self.modelArray mutableCopy];
            [self extractPatientDetails];
            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:NO];
        }
    }];
    
}

/**
 @brief To update Ui after feed download
 @returns void
 */
- (void)updateUI
{
    self.scrollView.hidden = NO;
    self.filterButton.enabled = YES;

    [self.collectionView reloadData];
    [self setNoContentTitle:@""];

    if(!self.images.count)//NO in progress
    {
        self.prescriptionBtnToTopConstraint.constant = 30;
        self.prescriptionDescriptionLabel.hidden = YES;

        self.collectionView.hidden = YES;
        self.transperentView.hidden = YES;
        self.notifyLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.pageControl.hidden = YES;
    }
    else // in progress
    {
        self.prescriptionBtnToTopConstraint.constant = 275;
        self.prescriptionDescriptionLabel.hidden = YES;

        self.uploadPrescriptionButton.hidden = NO;
        self.collectionView.hidden = NO;
        self.transperentView.hidden = NO;
        self.notifyLabel.hidden = NO;
        self.titleLabel.hidden = NO;
        self.pageControl.hidden = NO;

    }
    if(!self.modelArray.count && !self.images.count)//no complete & in progress
    {
        self.uploadPrescriptionButton.hidden = NO;
        self.prescriptionBtnToTopConstraint.constant = 130;
        self.prescriptionDescriptionLabel.hidden = NO;
        self.collectionView.hidden = YES;
        self.transperentView.hidden = YES;
        self.notifyLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.pageControl.hidden = YES;
        //       [self setNoContentTitle:IMNOPrescription];
        self.simplyUploadLabel.hidden = NO;
    }
    if(!self.modelArray.count)
    {
        self.tableView.tableHeaderView = nil;
    }
    else
    {
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    
    self.pageControl.numberOfPages = self.images.count;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableViewHeight = 0;
    [self.tableView reloadData];
    self.tableViewHeightConstraint.constant = self.tableViewHeight + self.tableView.tableHeaderView.frame.size.height;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 @brief Extract patient details for showing in filter screen
 @returns void
 */
- (void)extractPatientDetails
{
    
    self.patientList = [NSMutableArray array];
    self.doctorList = [NSMutableArray array];
    for (IMPrescription *prescription in self.tempModalArray)
    {
        if (prescription.patient.name)
        {
            if(![self.patientList containsObject:[prescription.patient.name lowercaseString]])
            {
                [self.patientList addObject:[prescription.patient.name lowercaseString]];

            }
        }
        if (prescription.doctor.name)
        {
            if(![self.doctorList containsObject:[prescription.doctor.name lowercaseString]])
            {
                [self.doctorList addObject:[prescription.doctor.name lowercaseString]];
            }
        }
    }
}

#pragma mark - CollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMPrescriptionCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMPrescriptionCell" forIndexPath:indexPath];
    collectionViewCell.imgView.image = [UIImage imageNamed:IMProductPlaceholderName];
    [collectionViewCell.imgView setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:indexPath.row]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];//[UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
    return collectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size = CGSizeMake(self.view.frame.size.width, 175.0);
    return size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
}



#pragma mark - TableView Datasource and delegate Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.modelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMPrescriptionTableViewCell* prescriptionCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMPrescriptionCell" forIndexPath:indexPath];
    IMPrescription *model = [self.modelArray objectAtIndex:indexPath.row];
    prescriptionCell.model = model;
    prescriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return prescriptionCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMPrescription *model = [self.modelArray objectAtIndex:indexPath.row];
    self.prototypeCell.model = model;
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.tableViewHeight += size.height + 1;
    return size.height+1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [IMFlurry logEvent:IMPrescriptionTapped withParameters:@{}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 @brief To handle upload prescription button action 
 @returns void
 */
- (IBAction)uploadPrescriptionPressed:(UIButton *)sender
{
    self.isPrescriptionPresented = YES;
     self.isNeedToReload = YES;
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
    
    IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
    prescriptionVC.prescriptionType = IMFromOthers;
    [self.navigationController pushViewController:prescriptionVC animated:YES];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.isNeedToReload = NO;
    if([segue.identifier isEqualToString:@"IMPrescriptionDetailSegue"])
    {
        ((IMPrescriptionDetailViewController*)segue.destinationViewController).prescriptionId = ((IMPrescriptionTableViewCell*)sender).model.identifier;

        if(self.isDeepLinkingPush)
        {
            ((IMPrescriptionDetailViewController*)segue.destinationViewController).prescriptionId = self.identifier;
            self.isDeepLinkingPush = NO;
        }
    }
    if([segue.identifier isEqualToString:@"IMFilterSegue"])
    {
        IMPrescriptionFilterViewController* filterVC = segue.destinationViewController;
        filterVC.patientList = self.patientList;
        filterVC.doctorList = self.doctorList;
        filterVC.selectedPatients = self.selectedPatientList;
        filterVC.selectedDoctors = self.selectedDoctorList;
        filterVC.completionBlock = ^(NSMutableArray* patients,NSMutableArray *doctors)
        {
            self.selectedPatientList = patients;
            self.selectedDoctorList = doctors;
            if (patients.count == 0 && doctors.count == 0)
            {
                self.modelArray = [self.tempModalArray mutableCopy];
            }
            else
            {
                //filter tempArray and assign to modalArray
                [self.modelArray removeAllObjects];
//                for (NSString *patient in self.selectedPatientList)
//                {
//                    for(IMPrescription *prescription in self.tempModalArray)
//                    {
//                        if([[prescription.patient.name lowercaseString] isEqual:[patient lowercaseString]])
//                        {
//                            if(![self.modelArray containsObject:prescription])
//                            {
//                                [self.modelArray addObject:prescription];
//                            }
//                        }
//                    }
//                }
//                for (NSString *doctor in self.selectedDoctorList)
//                {
//                    for(IMPrescription *prescription in self.tempModalArray)
//                    {
//                        if([[prescription.doctor.name lowercaseString] isEqual:[doctor lowercaseString]])
//                        {
//                            if(![self.modelArray containsObject:prescription])
//                            {
//                                [self.modelArray addObject:prescription];
//                            }
//                        }
//                    }
//                }
//            NSArray *sortedArray;
//            sortedArray = [self.modelArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//                NSNumber *first = ((IMPrescription*) a).identifier ;
//                NSNumber *second = ((IMPrescription*)b).identifier ;
//                return [first compare:second];
//            }];
//            self.modelArray = [sortedArray mutableCopy];
                
                
                for(IMPrescription *prescription in self.tempModalArray)
                {
                    for (NSString *patient in self.selectedPatientList)
                    {
                        if([[prescription.patient.name lowercaseString] isEqual:[patient lowercaseString]])
                        {
                            if(![self.modelArray containsObject:prescription])
                            {
                                [self.modelArray addObject:prescription];
                            }
                        }
                    }
                    for (NSString *doctor in self.selectedDoctorList)
                    {
                        if([[prescription.doctor.name lowercaseString] isEqual:[doctor lowercaseString]])
                        {
                            if(![self.modelArray containsObject:prescription])
                            {
                                [self.modelArray addObject:prescription];
                            }
                        }
                    }
                }
            }

            [self updateUI];
        };
    }
}

- (IMPrescriptionTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMPrescriptionCell"];
    }
    return _prototypeCell;
}

@end
