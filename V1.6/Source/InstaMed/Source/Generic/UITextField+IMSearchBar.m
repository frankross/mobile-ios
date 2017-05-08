//
//  UITextField+IMSearchBar.m
//  InstaMed
//
//  Created by Arjuna on 28/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "UITextField+IMSearchBar.h"

@implementation UITextField (IMSearchBar)

-(void)configureAsSearchBar
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
    imgView.image = [UIImage imageNamed:@"SearchIcon"];
    imgView.contentMode =  UIViewContentModeScaleAspectFit;
    self.rightView = imgView;
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.returnKeyType = UIReturnKeySearch;
    self.enablesReturnKeyAutomatically = YES;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeNo;

}

@end
