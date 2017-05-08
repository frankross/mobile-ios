//
//  IMOrderReminderViewController.h
//  InstaMed
//
//  Created by Arjuna on 02/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//Class for managing order remainder screen.


#import "IMBaseViewController.h"


@class IMOrderReminderViewController;

@protocol IMOrderReminderViewControllerDelgate <NSObject>

-(void)reminderController:(IMOrderReminderViewController*)reminderController didFinshWithFrequencyString:(NSString*)frequencyString nextDate:(NSString*)nextDate;

@end



typedef enum : NSUInteger {
    IMDay,
    IMWeek,
    IMMonth,
} IMReorderReminderType;

@interface IMOrderReminderViewController : IMBaseViewController

@property(nonatomic)IMReorderReminderType reminderType;
@property (nonatomic) NSInteger count;
@property (nonatomic,strong) NSDate* referenceDate;
@property (nonatomic,strong) NSNumber* orderId;

@property(weak,nonatomic) id<IMOrderReminderViewControllerDelgate> delegate;

@end
