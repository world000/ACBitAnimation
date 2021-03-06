//
//  YLCoinView.m
//  CoinAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import "YLCoinView.h"




/* *********************************************
 *************    YLCoinBitView    *************
 *********************************************** */

#pragma mark -
#pragma mark YLCoinBitView
#pragma mark -

@interface YLCoinBitView : UIView

@property (nonatomic, strong) UILabel *barLabel;

@property (nonatomic, strong) NSArray *coinList;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat bitWidth;

@property (nonatomic, copy) NSString *currentBit;

- (void) setCurrentBit:(NSString *)currentBit duration: (NSTimeInterval) duration;

@end

@implementation YLCoinBitView

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
    // _font = [UIFont systemFontOfSize:17];
    _coinList = @[@"0", @"1"];
    _currentBit = @"0";
    
    _textFont = [UIFont fontWithName:@"DINAlternate-Bold" size:24]; // DINCondensed-Bold // DINAlternate & DINCondensed // TODO: font
    _textColor = [UIColor blackColor]; // TODO: font

    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;

    _barLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _barLabel.backgroundColor = [UIColor clearColor];
    _barLabel.numberOfLines = 0;
    [self addSubview:_barLabel];
    
    [self updateBarLabel];
}

- (CGFloat)lineHeight {
    return ceilf(self.textFont.lineHeight); // TODO: font
}

- (CGFloat) lineSpace {
    return 3; // TODO: font
}

- (CGFloat) bitWidth {
    return 12; // TODO: font
}

- (CGFloat) bitHeight {
    return ([self lineHeight] + [self lineSpace]); // TODO: font
}

- (void)setCoinList:(NSArray *)coinList {
    if (coinList.count == 0) {
        return;
    }
    
    if (coinList == _coinList) {
        return;
    }
    
    BOOL coinSame = YES;
    if (_coinList.count == coinList.count) {
        NSInteger coinListCount = _coinList.count;
        for (NSInteger index = 0; index < coinListCount; index++) {
            NSString *coinBit1 = _coinList[index];
            NSString *coinBit2 = coinList[index];
            if (![coinBit1 isEqualToString:coinBit2]) {
                coinSame = NO;
                break;
            }
        }
    }
    else {
        coinSame = NO;
    }
    
    if (coinSame) {
        return;
    }
    
    _coinList = coinList;
    
    // check whether current bit is still in coin list.
    NSInteger foundIndex = [self indexOfBit:self.currentBit];
    
    if (foundIndex == NSNotFound) {
        _currentBit = self.coinList[0]; // if not found, reset to index 0.
    }
    
    [self updateBarLabel];
}

- (void) updateBarLabel {
    NSString *coinStr = [self.coinList componentsJoinedByString:@"\n"];

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.minimumLineHeight = self.lineHeight;
    paraStyle.maximumLineHeight = self.lineHeight;
    paraStyle.lineSpacing = [self lineSpace];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSAttributedString *coinAttrStr = [[NSAttributedString alloc] initWithString:coinStr attributes:@{NSFontAttributeName: self.textFont, NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: paraStyle}];
    
    self.barLabel.attributedText = coinAttrStr;
    
    [self layoutBarLabel];
}

- (void) setCurrentBit:(NSString *)currentBit {
    [self setCurrentBit:currentBit duration:0];
}

- (void) setCurrentBit:(NSString *)currentBit duration: (NSTimeInterval) duration {
    if (currentBit == nil) {
        currentBit = @"";
    }
    
    if ([_currentBit isEqualToString:currentBit]) {
        return;
    }
    
    NSInteger foundIndex = [self indexOfBit:currentBit];
    
    if (foundIndex == NSNotFound) {
        return;
    }
    
    _currentBit = currentBit;
    
    CGRect barLabelRect = self.barLabel.frame;
    CGFloat barLabelOriginY = (CGRectGetHeight(self.bounds) - [self lineHeight]) / 2.0f;
    barLabelRect.origin.y = barLabelOriginY - foundIndex * [self bitHeight];
    
    if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.barLabel.frame = barLabelRect;
        }];
    }
    else {
        self.barLabel.frame = barLabelRect;
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self layoutBarLabel];
}

- (void) layoutBarLabel {
    if (self.barLabel.attributedText == nil) {
        self.barLabel.frame = CGRectZero;
    }
    else {
        NSInteger foundIndex = [self indexOfBit:self.currentBit];
        
        if (foundIndex == NSNotFound) {
            return;
        }
        
        CGRect barLabelRect = self.barLabel.frame;
        barLabelRect.size = [self barLabelContentSize];
        CGPoint barLabelOrigin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(barLabelRect)) / 2.0f,
                                             (CGRectGetHeight(self.bounds) - [self lineHeight]) / 2.0f);
        barLabelRect.origin = CGPointMake(barLabelOrigin.x, barLabelOrigin.y - foundIndex * [self bitHeight]);
        self.barLabel.frame = barLabelRect;
    }
}

- (CGSize) barLabelContentSize {
    CGSize coinAttrStrSize = [self.barLabel.attributedText boundingRectWithSize:CGSizeMake([self bitWidth], CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    coinAttrStrSize.width = ceilf(coinAttrStrSize.width);
    coinAttrStrSize.height = ceilf(coinAttrStrSize.height) - (self.coinList.count > 1 ? 0 : [self lineSpace]);

    return coinAttrStrSize;
}

- (NSInteger) indexOfBit:(NSString *) bit {
    NSInteger foundIndex = NSNotFound;
    for (NSInteger index = 0; index < self.coinList.count; index++) {
        if ([self.coinList[index] isEqualToString:bit]) {
            foundIndex = index;
            break;
        }
    }
    
    return foundIndex;
}

- (NSString *)debugDescription {
    NSString *debug = [[NSString alloc] initWithFormat:@"%p \n bitlist = %@ \n current = %@", &self, self.coinList, self.currentBit];
    
    return debug;
}

@end




/* *********************************************
 ************    YLCoinInnerView    ************
 *********************************************** */

#pragma mark -
#pragma mark YLCoinInnerView
#pragma mark -

@interface YLCoinInnerView : UIView

@property (nonatomic, strong) NSArray *bitViews;

@property (nonatomic, copy) NSString *coinStr;
@property (nonatomic, strong) NSArray *coinBitList;

- (void) setFont: (UIFont *) font;
- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration;

@end


@implementation YLCoinInnerView

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
    [self setupBitViews];
    
    _coinStr = @"0";
    NSMutableArray *coinBitList = [[NSMutableArray alloc] initWithCapacity:_coinStr.length];
    for (NSInteger index = _coinStr.length - 1; index < _coinStr.length; index--) {
        [coinBitList addObject:[_coinStr substringWithRange:NSMakeRange(index, 1)]];
    }
    _coinBitList = [coinBitList copy];
    
    [self updateBitViewsWithDuration:0 direction:YES];
}

- (CGFloat) bitWidth {
    return 16; // TODO: font
}

- (CGFloat) thousandSymbolWidth {
    return 6; // TODO: font
}

- (CGFloat) viewWidth {
    CGFloat width = 0;
    CGFloat coinBitCount = self.coinBitList.count;
    if (coinBitCount >= 5) { // thousand symbol
        width = [self bitWidth] * (coinBitCount - 1) + [self thousandSymbolWidth];
    }
    else {  // NO thousand symbol
        width = [self bitWidth] * coinBitCount;
    }
    
    return width;
}

- (void) setupBitViews {
    const NSInteger maxBitCount = 7; // TODO: max seven bits, 999,999
    NSMutableArray *bitViews = [[NSMutableArray alloc] initWithCapacity:maxBitCount];
    for (NSInteger index = 0; index < maxBitCount; index++) {
        YLCoinBitView *bitView = [[YLCoinBitView alloc] initWithFrame:CGRectZero];
        [self addSubview:bitView];

        if (index == 3) { // thounsand symbol
            bitView.frame = CGRectMake(0, 0, [self thousandSymbolWidth], CGRectGetHeight(self.bounds));
            [bitView setCoinList:@[@" ", @","]];
            bitView.currentBit = @" ";
        }
        else {
            bitView.frame = CGRectMake(0, 0, [self bitWidth], CGRectGetHeight(self.bounds));
            [bitView setCoinList:@[@" ", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
            bitView.currentBit = @" ";
        }
        
        [bitViews addObject:bitView];
    }
    
    self.bitViews = [bitViews copy];
}

- (void) updateBitViewsWithDuration: (NSTimeInterval) duration direction: (BOOL) direction {
    
    for (NSInteger index = 0; index < self.bitViews.count; index++) {
        YLCoinBitView *bitView = self.bitViews[index];
        if (index < self.coinBitList.count) { // convert to new bit.
            NSString *coinBit = self.coinBitList[index];
            if ([coinBit isEqualToString:bitView.currentBit]) {
                ;
            }
            else {
                if ([coinBit isEqualToString:@","]) {
                    if (direction) {
                        [bitView setCoinList:@[@" ", @","]];
                    }
                    else {
                        [bitView setCoinList:@[@",", @" "]]; // never happned.
                    }
                    [bitView setCurrentBit:coinBit duration:duration];
                }
                else {
                    [bitView setCoinList:[self generateCoinListFrom:bitView.currentBit to:coinBit withDirection:direction]];
                    [bitView setCurrentBit:coinBit duration:duration];
                }
            }
        }
        else { // convert to " "[space]
            if ([bitView.currentBit isEqualToString:@" "]) {
                ;
            }
            else {
                if ([bitView.currentBit isEqualToString:@","]) {
                    if (direction) {
                        [bitView setCoinList:@[@",", @" "]]; // never happened.
                    }
                    else {
                        [bitView setCoinList:@[@" ", @","]];
                    }
                    [bitView setCurrentBit:@" " duration:duration];
                }
                else {
                    [bitView setCoinList:[self generateCoinListFrom:bitView.currentBit to:@" " withDirection:direction]];
                    [bitView setCurrentBit:@" " duration:duration];
                }
            }
        }
    }
}

- (NSArray *) generateCoinListFrom: (NSString *) start to: (NSString *) end withDirection: (BOOL) direction {
    
    NSInteger startInt = 0;
    NSInteger endInt = 0;
    NSMutableArray *coinList = [[NSMutableArray alloc] initWithCapacity:11];

    if (direction) {
        startInt = [self valueForBitStr: start];
        endInt = [self valueForBitStr: end];
    }
    else {
        startInt = [self valueForBitStr: end];
        endInt = [self valueForBitStr: start];
    }
    
    while (startInt != endInt) {
        [coinList addObject:[self bitStrForValue:startInt]];
        
        startInt++;
        if (startInt == 10) {
            startInt = 0;
        }
    }
    
    [coinList addObject:[@(startInt) stringValue]];
    
    return coinList;
}

- (NSInteger) valueForBitStr: (NSString *) bitStr {
    if ([bitStr isEqualToString:@" "]) {
        return -1;
    }
    
    return [bitStr integerValue];
}

- (NSString *) bitStrForValue: (NSInteger) bit {
    if (bit == -1) {
        return @" ";
    }
    
    return [@(bit) stringValue];
}

- (void) setFont: (UIFont *) font {
    // TODO: font
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr duration:0];
}

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration {
    if (coinStr.length == 0) {
        coinStr = @"0";
    }
    
    if ([_coinStr isEqualToString:coinStr]) {
        return;
    }
    
    NSInteger coinInt = [[coinStr stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    NSInteger prevCoinInt = [[_coinStr stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];

    _coinStr = [coinStr copy];
    
    NSMutableArray *coinBitList = [[NSMutableArray alloc] initWithCapacity:_coinStr.length];
    for (NSInteger index = _coinStr.length - 1; index < _coinStr.length; index--) {
        [coinBitList addObject:[_coinStr substringWithRange:NSMakeRange(index, 1)]];
    }
    _coinBitList = [coinBitList copy];
    
    [self updateBitViewsWithDuration:duration direction:coinInt > prevCoinInt];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger index = 0; index < self.bitViews.count; index++) {
        YLCoinBitView *bitView = self.bitViews[index];
        if (index == 0) {
            CGRect bitViewRect = bitView.frame;
            bitViewRect.size = CGSizeMake([self bitWidth], CGRectGetHeight(self.bounds));
            bitViewRect.origin = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetWidth(bitViewRect), 0);
            bitView.frame = bitViewRect;
        }
        else {
            YLCoinBitView *prevBitView = self.bitViews[index - 1];
            CGRect prevBitViewRect = prevBitView.frame;
            CGRect bitViewRect = bitView.frame;
            
            if (index == 3) { // thounsand symbol
                bitViewRect.size = CGSizeMake([self thousandSymbolWidth], CGRectGetHeight(self.bounds));
            }
            else {
                bitViewRect.size = CGSizeMake([self bitWidth], CGRectGetHeight(self.bounds));
            }
            
            bitViewRect.origin = CGPointMake(CGRectGetMinX(prevBitViewRect) - CGRectGetWidth(bitViewRect), 0);
            bitView.frame = bitViewRect;
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return (CGSizeMake([self viewWidth], size.height));
}

@end




/* *********************************************
 ***************    YLCoinView    **************
 *********************************************** */

#pragma mark -
#pragma mark YLCoinView
#pragma mark -

@interface YLCoinView ()

@property (nonatomic, strong) YLCoinInnerView *coinView;

@end

@implementation YLCoinView

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
    _coinView = [[YLCoinInnerView alloc] initWithFrame:self.bounds];
    [self addSubview:_coinView];
}

- (void) setFont: (UIFont *) font {
    [self.coinView setFont: font];
}

- (NSString *) coinStr {
    return (self.coinView.coinStr);
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr duration:0];
}

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration {
    CGRect prevCoinViewRect = self.coinView.frame;
    CGPoint upperRight = CGPointMake(CGRectGetMaxX(prevCoinViewRect), 0);

    [self.coinView setCoinStr:coinStr duration:duration];
    [self.coinView sizeToFit];
    
    CGRect coinViewRect = self.coinView.frame;
    coinViewRect.origin = CGPointMake(upperRight.x - CGRectGetWidth(coinViewRect), 0);
    self.coinView.frame = coinViewRect;
    
    if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        }];
    }
    else {
        self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self.coinView sizeToFit];
    self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
