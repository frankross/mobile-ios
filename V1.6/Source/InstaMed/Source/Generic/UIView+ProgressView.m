
#import "UIView+ProgressView.h"
#import <objc/runtime.h>
#import "UIView+ProgressView.h"

static char *kViewIdentifier = "progressViewID";
static char *kIndicatorViewIdentifier = "progressIndicatorID";
static char *kTextViewIdentifier = "textViewID";
static char *kRoundedViewIdentifier = "roundedViewID";

@implementation UIView (ProgressView)
@dynamic progressView;
@dynamic indicatorView;
@dynamic textView;
@dynamic roundedView;

- (UIView *)progressView
{
    return objc_getAssociatedObject(self, &kViewIdentifier);
}

- (void)setProgressView:(NSString *)newViewIdentifer
{
    objc_setAssociatedObject(self, &kViewIdentifier, newViewIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)textView
{
    return objc_getAssociatedObject(self, &kTextViewIdentifier);
}
- (void)setTextView:(NSString *)newViewIdentifer
{
    objc_setAssociatedObject(self, &kTextViewIdentifier, newViewIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)roundedView
{
    return objc_getAssociatedObject(self, &kRoundedViewIdentifier);
}

- (void)setRoundedView:(NSString *)newViewIdentifer
{
    objc_setAssociatedObject(self, &kRoundedViewIdentifier, newViewIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIActivityIndicatorView *)indicatorView
{
    return objc_getAssociatedObject(self, &kIndicatorViewIdentifier);
}

- (void)setIndicatorView:(NSString *)newViewIdentifer
{
    objc_setAssociatedObject(self, &kIndicatorViewIdentifier, newViewIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isShowingProgressView
{
    return self.progressView != nil;
}

#pragma mark- Interface methods

+(UIView*)roundedRectViewWithFrame:(CGRect)frame
{
    UIView *roundedView = [[UIView alloc] initWithFrame:frame];
    
    [roundedView setBackgroundColor:[UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f]];
    
    roundedView.layer.cornerRadius = 7.0;
    [roundedView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    return roundedView;
}

- (void)addProgressViewWithText:(NSString*)text
{
    if (nil == self.progressView)
    {
        CGRect bounds = self.bounds;
      
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            bounds.origin.y = 20;
            bounds.size.height = bounds.size.height - 20;
        }
        
        UIView *progView = [[UIView alloc] initWithFrame:bounds];
        
        progView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.progressView = progView;
        self.progressView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMemoryNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    
    if(!self.indicatorView)
    {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    
    
    [self.indicatorView startAnimating];
    
    self.textView = [[UILabel alloc] init];
    self.textView.text = text;
    [self.textView setBackgroundColor:[UIColor clearColor]];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont boldSystemFontOfSize:20];
    
    self.textView.layer.shadowColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0.0, -2.0);
    
    self.textView.layer.shadowRadius = 2.0;
    self.textView.layer.shadowOpacity = 0.7;
    [self.textView sizeToFit];
    
    
    CGRect destinationFrameSize = CGRectMake(0, 0, self.textView.frame.size.width + self.indicatorView.frame.size.width + 50, self.textView.frame.size.height + 30);
    
    [self.indicatorView setFrame:CGRectMake(20, ((destinationFrameSize.size.height - self.indicatorView.frame.size.height) /2), CGRectGetWidth(self.indicatorView.frame), CGRectGetHeight(self.indicatorView.frame))];
    [self.textView setFrame:CGRectMake((int)(CGRectGetMaxX(self.indicatorView.frame) + 10 ) , (int) ((destinationFrameSize.size.height - self.textView.frame.size.height) /2), CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))];
//    [self.indicatorView setFrameOrigin:CGPointMake(20, (destinationFrameSize.size.height - self.indicatorView.frame.size.height) /2)];
//    [self.textView setFrameOrigin:(CGPointMake((int)(CGRectGetMaxX(self.indicatorView.frame) + 10 ),(int) ((destinationFrameSize.size.height - self.textView.frame.size.height) /2)))];
    
    self.roundedView = [[self class] roundedRectViewWithFrame:destinationFrameSize];
    
    [self.roundedView addSubview:self.indicatorView];
    [self.roundedView addSubview:self.textView];
   
    CGPoint roundedViewCenter = self.progressView.center;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        roundedViewCenter.y = roundedViewCenter.y - 20;
    }
    
    self.roundedView.center = roundedViewCenter;
    
    [self.progressView addSubview:self.roundedView];
    
    [self addRoundedRectProgressView];
    }
}

-(void)addProgressViewWithFrame:(CGRect)frame WithText:(NSString *)text
{
    if (nil == self.progressView)
    {
        UIView *progView = [[UIView alloc] initWithFrame:frame];
        
        progView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.progressView = progView;
        self.progressView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.99];
//        self.progressView.backgroundColor = [UIColor greenColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMemoryNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        
        if(!self.indicatorView)
        {
            self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.indicatorView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        }
        
        
        [self.indicatorView startAnimating];
        
        self.textView = [[UILabel alloc] init];
        self.textView.text = text;
        [self.textView setBackgroundColor:[UIColor clearColor]];
        self.textView.textColor = [UIColor whiteColor];
        self.textView.font = [UIFont boldSystemFontOfSize:20];
        
        self.textView.layer.shadowColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f].CGColor;
        self.textView.layer.shadowOffset = CGSizeMake(0.0, -2.0);
        
        self.textView.layer.shadowRadius = 2.0;
        self.textView.layer.shadowOpacity = 0.7;
        [self.textView sizeToFit];
        
        
        CGRect destinationFrameSize = CGRectMake(0, 0, self.textView.frame.size.width + self.indicatorView.frame.size.width + 50, self.textView.frame.size.height + 30);
        
        [self.indicatorView setFrame:CGRectMake(20, ((destinationFrameSize.size.height - self.indicatorView.frame.size.height) /2), CGRectGetWidth(self.indicatorView.frame), CGRectGetHeight(self.indicatorView.frame))];
        [self.textView setFrame:CGRectMake((int)(CGRectGetMaxX(self.indicatorView.frame) + 10 ) , (int) ((destinationFrameSize.size.height - self.textView.frame.size.height) /2), CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))];
        //    [self.indicatorView setFrameOrigin:CGPointMake(20, (destinationFrameSize.size.height - self.indicatorView.frame.size.height) /2)];
        //    [self.textView setFrameOrigin:(CGPointMake((int)(CGRectGetMaxX(self.indicatorView.frame) + 10 ),(int) ((destinationFrameSize.size.height - self.textView.frame.size.height) /2)))];
        
        self.roundedView = [[self class] roundedRectViewWithFrame:destinationFrameSize];
        
        [self.roundedView addSubview:self.indicatorView];
        [self.roundedView addSubview:self.textView];
        
        CGPoint roundedViewCenter = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
        
        self.roundedView.center = roundedViewCenter;
        
        [self.progressView addSubview:self.roundedView];
        
        [self addRoundedRectProgressViewToFramedProgressView];
    }
    
}

-(void)createProgressAndIndicatorViews
{
    if (nil == self.progressView)
    {
        CGRect bounds = self.bounds;
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            bounds.origin.y = 20;
//            bounds.size.height = bounds.size.height - 20;
//        }
        
        UIView *progView = [[UIView alloc] initWithFrame:bounds];
        progView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.progressView = progView;
        self.progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.99];
        
    }
    
    if(!self.indicatorView)
    {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicatorView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    self.indicatorView.center = CGPointMake(self.progressView.bounds.size.width / 2, self.progressView.bounds.size.height / 2);//self.progressView.center;
    [self.indicatorView startAnimating];
    [self.progressView addSubview:self.indicatorView];
    
}

-(void)addRoundedRectProgressViewToFramedProgressView
{
    self.progressView.alpha = 0.0;
    [self addSubview:self.progressView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];
    
}


-(void)addRoundedRectProgressView
{
    self.progressView.alpha = 0.0;
    [self addSubview:self.progressView];
    [self setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];
    
}

- (void)addProgressView
{
    [self createProgressAndIndicatorViews];
    self.progressView.alpha = 0.0;
    [self addSubview:self.progressView];
    [self setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1.0;
    }completion:^(BOOL finished){
        
    }];
    
}

- (void)removeProgressViewWithOutAnimation
{
    [self setUserInteractionEnabled:YES];
    [self.indicatorView stopAnimating];
    [self.roundedView removeFromSuperview];
    [self.progressView removeFromSuperview];
    
    if(self.progressView)
    self.progressView = nil;
    
    if(self.indicatorView)
    self.indicatorView = nil;
    
    if(self.roundedView)
    self.roundedView = nil;
    
    if(self.textView)
    self.textView = nil;

}

- (void)removeProgressView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 0.0;
        self.textView.alpha = 0.0;
        self.roundedView.alpha = 0.0;
    }completion:^(BOOL finished)
     {
         [self setUserInteractionEnabled:YES];
         [self.roundedView removeFromSuperview];
         [self.progressView removeFromSuperview];
         self.progressView = nil;
         self.indicatorView = nil;
         self.roundedView = nil;
         self.textView = nil;
     }];
}

#pragma mark- Cleanup

- (void) receivedMemoryNotification:(NSNotification*)notification
{
    //    self.progressView = nil;
}

@end
