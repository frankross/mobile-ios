//
//  IMProductFilterViewController.h
//  InstaMed
//
//  Created by Suhail K on 30/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing product filter screen.

#import "IMBaseViewController.h"

typedef enum
{
    IMFromCategory,
    IMOtherScreens
}
IMFilterType;

@protocol IMProductFilterViewControllerDelegate <NSObject>

-(void)filterReset;
-(void)filtersApplied;

@end

@interface IMProductFilterViewController : IMBaseViewController

@property(nonatomic,strong) NSDictionary* facetInfo;
@property(nonatomic,strong) NSMutableDictionary* filterDictionary;

@property(nonatomic,weak) id<IMProductFilterViewControllerDelegate> delegate;

@property(nonatomic ) IMFilterType filterType;


@end
