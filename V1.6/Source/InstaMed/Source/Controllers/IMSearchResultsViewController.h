//
//  IMSearchResultsViewController.h
//  InstaMed
//
//  Created by Arjuna on 13/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing product search result screen.

#import "IMBaseViewController.h"

@interface IMSearchResultsViewController : IMBaseViewController

@property(nonatomic,strong) NSString* searchTerm;
@property(nonatomic,strong) NSString* categoryName;

@end
