//
//  IMPDPTextDetailViewController.m
//  InstaMed
//
//  Created by Suhail K on 10/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPDPTextDetailViewController.h"
#import "IMCartUtility.h"

@interface IMPDPTextDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IMPDPTextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
//[super loadUI];
    [self setUpNavigationBar];
    SET_FOR_YOU_CELL_BORDER(self.textView, [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f], 4.0f);
    [self.textView  setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];
   
    if (self.infoType == IMActiveIngridients)
    {
        self.textView.attributedText = [self bulletedParagraphString:self.information];
    }
    else
    {
        self.textView.text  = self.information;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSAttributedString*) bulletedParagraphString:(NSString*) paragraph
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:paragraph];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:3];
    [paragraphStyle setParagraphSpacingBefore:3];
    [paragraphStyle setFirstLineHeadIndent:0.0f];  // First line is the one with bullet point
    [paragraphStyle setHeadIndent:10.5f];    // Set the indent for given bullet character and size font
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                             range:NSMakeRange(0, [paragraph length])];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [paragraph length])];
    return attributedString;
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
