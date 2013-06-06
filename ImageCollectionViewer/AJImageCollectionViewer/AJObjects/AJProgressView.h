//
//  Based on DACircularProgress from Daniel Amitay (2012)
//

#import <UIKit/UIKit.h>

@interface AJProgressView : UIView

@property(nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) CGFloat thickness UI_APPEARANCE_SELECTOR;
@property(nonatomic) CGFloat progress;

- (id)initInCenterOfFrame:(CGRect)frame;

@end
