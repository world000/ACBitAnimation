//
//  YLCoinView.m
//  CoinAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import "YLCoinView.h"

@interface YLCoinBitView : UIView

@property (nonatomic, strong) UILabel *barLabel;

@end


@implementation YLCoinBitView

@end



@interface YLCoinInnerView : UIView

@property (nonatomic, strong) NSArray *bitViews;

@property (nonatomic, copy) NSString *preCoinStr;
@property (nonatomic, copy) NSString *coinStr;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation YLCoinInnerView

- (void) setupBitViews {
    YLCoinBitView *bitView = [[YLCoinBitView alloc] init];
    
    NSMutableArray *coinBitArray = [[NSMutableArray alloc] initWithCapacity:_coinStr.length];
    for (NSInteger index = 0; index < _coinStr.length; index++) {
        [coinBitArray addObject:[_coinStr substringWithRange:NSMakeRange(index, 1)]];
    }
    
}

- (void) commonSetupWithCoinStr: (NSString *) coinStr {
    _coinStr = coinStr;
    _animationDuration = 1;
    
    [self setupBitViews];
}

- (instancetype)initWithCoinStr: (NSString *)coinStr {
    self = [super init];
    
    if (self) {
        [self commonSetupWithCoinStr:coinStr];
    }
    
    return self;
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr animated:NO];
}

- (void) setCoinStr:(NSString *)coinStr animated: (BOOL) animated {
    if (coinStr.length == 0) {
        return;
    }
    
    if ([_coinStr isEqualToString:coinStr]) {
        return;
    }
    
    _preCoinStr = [_coinStr copy];
    _coinStr = [coinStr copy];
    
    
}



@end









@interface YLCoinView ()

@property (nonatomic, strong) YLCoinInnerView *coinView;

@end

@implementation YLCoinView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (void) commonSetup {
    _coinView = [[YLCoinInnerView alloc] initWithCoinStr:@"0"];
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr animated:NO];
}

- (void) setCoinStr:(NSString *)coinStr animated: (BOOL) animated {
    [self.coinView setCoinStr:coinStr animated:animated];
    
    if (animated) {
        [UIView animateWithDuration:self.coinView.animationDuration animations:^{
            self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        }];
    }
    else {
        self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}

@end
