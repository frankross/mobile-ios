//
//  IMSubCategoryTableViewCell.h
//  InstaMed
//
//  Created by Arjuna on 07/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "RTExpandableTableViewCell.h"
#import "IMCategory.h"

@interface IMSubCategoryTableViewCell : RTExpandableTableViewCell

@property (nonatomic,strong) IMCategory* model;

@property (weak, nonatomic) IBOutlet UILabel *subCatLabel;
@end
