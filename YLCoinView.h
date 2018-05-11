//
//  YLCoinView.h
//  CoinAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLCoinBitView : UIView

@property (nonatomic, strong) UILabel *barLabel;

@property (nonatomic, strong) NSArray *coinList;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign, readonly) CGFloat lineHeight;

@property (nonatomic, copy) NSString *currentBit;

- (void) setCurrentBit:(NSString *)currentBit duration: (NSTimeInterval) duration;

@end





@interface YLCoinInnerView : UIView

@property (nonatomic, strong) NSArray *bitViews;

@property (nonatomic, copy) NSString *coinStr;
@property (nonatomic, strong) NSArray *coinBitList;

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration direction: (BOOL) direction;

@end




@interface YLCoinView : UIView

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration direction: (BOOL) direction;

@end
