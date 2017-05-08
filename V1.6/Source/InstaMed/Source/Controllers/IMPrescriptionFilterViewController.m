//
//  IMPrescriptionFilterViewController.m
//  InstaMed
//
//  Created by Suhail K on 02/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#define  SECTION_HEIGHT 65
#import "IMPrescriptionFilterViewController.h"
#import "IMPrescriptionFilterTableViewCell.h"


@interface IMPrescriptionFilterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (nonatomic, assign) BOOL isClearPressed;


@end

@implementation IMPrescriptionFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUI
{
    [self setUpNavigationBar];
    [IMFunctionUtilities setBackgroundImage:self.applyButton withImageColor:APP_THEME_COLOR];
    [self downloadFeed];
    
}

-(void)downloadFeed
{
    [self updateUI];
}

/**
 @brief To update Ui after feed downloading
 @returns void
 */
-(void)updateUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
    for(NSString* patient in self.selectedPatients)
    {
        
        for(NSInteger index = 0; index < self.patientList.count;index++)
        {
            NSString* name = self.patientList[index];
            if([patient isEqual:name])
            {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
    for(NSString* doctor in self.selectedDoctors)
    {
        
        for(NSInteger index = 0; index < self.doctorList.count;index++)
        {
            NSString* name = self.doctorList[index];
            if([doctor isEqual:name])
            {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
}


/**
 @brief To handle apply action
 @returns void
 */
- (IBAction)applyPressed:(id)sender
{
    
    [self.selectedPatients removeAllObjects];
    [self.selectedDoctors removeAllObjects];
    for (NSIndexPath* indexPath in [self.tableView indexPathsForSelectedRows])
    {
//        [selectedOptions addObject:self.modelArray[indexPath.row]];
        if(0 == indexPath.section)
        {
            [self.selectedPatients addObject:self.patientList[indexPath.row]];
        }
        else if(1== indexPath.section)
        {
            [self.selectedDoctors addObject:self.doctorList[indexPath.row]];
        }
    }
    self.completionBlock(self.selectedPatients,self.selectedDoctors);
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 @brief To handle clear action
 @returns void
 */
- (IBAction)clearPressed:(id)sender
{
    [self.tableView reloadData];
}

#pragma mark - Table View DataSource and Delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if(0 == section)
    {
        count = self.patientList.count;
    }
    else if (1 == section)
    {
        count = self.doctorList.count;

    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMPrescriptionFilterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IMOptionsTableViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.modelArray[indexPath.row];
    
    if(0 == indexPath.section)
    {
//        cell.nameLabel.text = self.patientList[indexPath.row];
        if([self.patientList[indexPath.row] length] >=1)
        {
            cell.nameLabel.text = [self.patientList[indexPath.row] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.patientList[indexPath.row]  substringToIndex:1] uppercaseString]];

        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if(indexPath.row == self.patientList.count - 1)
        {
            cell.separatorView.hidden = YES;
        }
        else
        {
            cell.separatorView.hidden = NO;
        }
    }
    else if (1 == indexPath.section)
    {
        if([self.doctorList[indexPath.row] length] >=1)
        {
        cell.nameLabel.text = [self.doctorList[indexPath.row] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.doctorList[indexPath.row]  substringToIndex:1] uppercaseString]];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0  blue:249.0/255.0  alpha:1.0];

        if(indexPath.row == self.doctorList.count -1)
        {
            cell.separatorView.hidden = YES;
        }
        else
        {
            cell.separatorView.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if(0 == indexPath.section)
//    {
//        NSString *name = self.patientList[indexPath.row];
//        if([self.selectedPatients containsObject:name])
//        {
//            [self.selectedPatients removeObject:name];
//        }
//        else
//        {
//            [self.selectedPatients addObject:name];
//        }
//    }
//    else if (1 == indexPath.section)
//    {
//        NSString *name = self.doctorList[indexPath.row];
//        if([self.selectedDoctors containsObject:name])
//        {
//            [self.selectedDoctors removeObject:name];
//        }
//        else
//        {
//            [self.selectedDoctors addObject:name];
//        }
//    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if(0 == indexPath.section)
//    {
//        NSString *name = self.patientList[indexPath.row];
//        if([self.selectedPatients containsObject:name])
//        {
//            [self.selectedPatients removeObject:name];
//        }
//        else
//        {
//            [self.selectedPatients addObject:name];
//        }
//    }
//    else if (1 == indexPath.section)
//    {
//        NSString *name = self.doctorList[indexPath.row];
//        if([self.selectedDoctors containsObject:name])
//        {
//            [self.selectedDoctors removeObject:name];
//        }
//        else
//        {
//            [self.selectedDoctors addObject:name];
//        }
//    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

//Tableview header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = SECTION_HEIGHT;
    
    
    CGRect frame = CGRectMake(0,0, screenWidth , height);
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, screenWidth - 50, 20)];
    titleLabel.font = [UIFont fontWithName:@"Helevetica Neue Medium" size:18];
    titleLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    if(0 == section)
    {
        headerView.backgroundColor =  [UIColor whiteColor];
        titleLabel.text = @"Patient";
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 27, 18, 24)];

        imageView1.image = [UIImage imageNamed:@"PatientIcon"];
        [headerView addSubview:imageView1];

    }
    else if (1 == section)
    {
        headerView.backgroundColor =  [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        titleLabel.text = @"Doctor";
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 27, 25, 20)];

        imageView2.image = [UIImage imageNamed:@"DoctorIcon"];
        [headerView addSubview:imageView2];

    }

    [headerView addSubview:titleLabel];
    
    UIView* bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(15, height-1, screenWidth, 1)];
    bottomSeparatorView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:220/255.0];
    
    [headerView addSubview:bottomSeparatorView];
    
    return headerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
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
