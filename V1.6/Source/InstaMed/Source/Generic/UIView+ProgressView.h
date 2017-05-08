
#import <UIKit/UIKit.h>

@interface UIView (ProgressView)

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *textView;
@property (nonatomic, strong) UIView *roundedView;

- (void)addProgressView;
- (void)removeProgressView;
- (void)addProgressViewWithText:(NSString*)text;
- (BOOL)isShowingProgressView;
- (void)removeProgressViewWithOutAnimation;
- (void)addProgressViewWithFrame:(CGRect)frame WithText:(NSString *)text;

@end
