//
//  IMSearchViewController.h
//  InstaMed
//
//  Created by Suhail K on 22/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//Class for managing search screen.
//Including algolia.

#import "IMBaseViewController.h"

typedef enum
{
    IMRecentlySearched      = 0,
    IMAutoSuggestion    = 1
}
IMSearchMode;

@interface IMSearchViewController : IMBaseViewController

@end
