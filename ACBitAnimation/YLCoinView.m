//
//  YLCoinView.m
//  CoinAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import "YLCoinView.h"

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
    
    _textFont = [UIFont fontWithName:@"DINAlternate-Bold" size:17]; // DINCondensed-Bold // DINAlternate & DINCondensed
    _textColor = [UIColor blackColor]; // TODO:

    self.backgroundColor = [UIColor clearColor]; // TODO:
    self.clipsToBounds = YES; // TODO:

    _barLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _barLabel.backgroundColor = [UIColor clearColor]; // TODO:
    _barLabel.numberOfLines = 0;
    [self addSubview:_barLabel];
    [self updateBarLabel];
}

- (CGFloat)lineHeight {
    return ceilf(self.textFont.lineHeight);
}

- (CGFloat) lineSpace {
    return 5;
}

- (CGFloat) bitWidth {
    return 15;
}

- (CGFloat) bitHeight {
    return ([self lineHeight] + [self lineSpace]);
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
    
    [self updateBarLabel];
    
    // check whether current bit is still in coin list.
    NSInteger foundIndex = [self indexOfBit:self.currentBit];
    
    if (foundIndex == NSNotFound) {
        _currentBit = self.coinList[0]; // if not found, reset to index 0.
    }
    
    [self layoutBarLabel];
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
    
    CGSize coinAttrStrSize = [self.barLabel.attributedText boundingRectWithSize:CGSizeMake([self bitWidth], CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    coinAttrStrSize.width = ceilf(coinAttrStrSize.width);
    coinAttrStrSize.height = ceilf(coinAttrStrSize.height) - (self.coinList.count > 1 ? 0 : [self lineSpace]);
    
    CGRect barLabelRect = self.barLabel.frame;
    barLabelRect.size = coinAttrStrSize;
    self.barLabel.frame = barLabelRect;
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
        CGPoint barLabelOrigin = CGPointMake((CGRectGetWidth(self.bounds) - barLabelRect.size.width) / 2.0f,
                                             (CGRectGetHeight(self.bounds) - [self lineHeight]) / 2.0f);
        barLabelRect.origin = CGPointMake(barLabelOrigin.x, barLabelOrigin.y - foundIndex * [self bitHeight]);
        self.barLabel.frame = barLabelRect;
    }
}

#pragma mark - private methods

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
    
    [self updateBitViewsWithDuration:0 direction:NO];
}

- (CGFloat) bitWidth {
    return 10;
}

- (CGFloat) thousandSymbolWidth {
    return 5;
}

- (CGFloat) viewWidth {
    CGFloat width = 0;
    CGFloat coinBitCount = self.coinBitList.count;
    if (coinBitCount >= 5) {
        width = [self bitWidth] * (coinBitCount - 1) + [self thousandSymbolWidth];
    }
    else {
        width = [self bitWidth] * coinBitCount;
    }
    
    return width;
}

- (void) setupBitViews {
    const NSInteger maxBitCount = 7; // max seven bits, 999,999
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
        
//        bitView.backgroundColor =
        [bitViews addObject:bitView];
    }
    
    self.bitViews = [bitViews copy];
}

- (void) updateBitViewsWithDuration: (NSTimeInterval) duration direction: (BOOL) direction {
    
    for (NSInteger index = 0; index < self.bitViews.count; index++) {
        YLCoinBitView *bitView = self.bitViews[index];
        if (index < self.coinBitList.count) {
            NSString *coinBit = self.coinBitList[index];
            if ([coinBit isEqualToString:bitView.currentBit]) {
                
            }
            else {
                if ([coinBit isEqualToString:@","]) {
                    if (direction) {
                        [bitView setCoinList:@[@" ", @","]];
                    }
                    else {
                        [bitView setCoinList:@[@",", @" "]];
                    }
                    [bitView setCurrentBit:coinBit duration:duration];
                }
                else {
                    if ([bitView.currentBit isEqualToString:@" "]) {
                        if (direction) {
                            [bitView setCoinList:@[@" ", coinBit]];
                        }
                        else {
                            [bitView setCoinList:@[coinBit, @" "]];
                        }
                        [bitView setCurrentBit:coinBit duration:duration];
                    }
                    else {
                        [bitView setCoinList:[self generateCoinListFrom:bitView.currentBit to:coinBit withDirection:direction]];
                        [bitView setCurrentBit:coinBit duration:duration];
                    }
                }
            }
        }
        else {
            if ([bitView.currentBit isEqualToString:@" "]) {
                ;
            }
            else {
                if (direction) {
                    [bitView setCoinList:@[bitView.currentBit, @" "]];
                }
                else {
                    [bitView setCoinList:@[@" ", bitView.currentBit]];
                }
                [bitView setCurrentBit:@" " duration:duration];
            }
        }
    }
}

- (NSArray *) generateCoinListFrom: (NSString *) start to: (NSString *) end withDirection: (BOOL) direction {
    NSInteger startInt = 0;
    NSInteger endInt = 0;
    NSMutableArray *coinList = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (direction) {
        startInt = [start integerValue];
        endInt = [end integerValue];
    }
    else {
        startInt = [end integerValue];
        endInt = [start integerValue];
    }
    
    while (startInt != endInt) {
        [coinList addObject:[@(startInt) stringValue]];
        
        startInt++;
        if (startInt == 10) {
            startInt = 0;
        }
    }
    
    [coinList addObject:[@(startInt) stringValue]];
    
    return coinList;
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr duration:0 direction:NO];
}

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration direction: (BOOL) direction {
    if (coinStr.length == 0) {
        coinStr = @"0";
    }
    
    if ([_coinStr isEqualToString:coinStr]) {
        return;
    }
    
    _coinStr = [coinStr copy];
    
    NSMutableArray *coinBitList = [[NSMutableArray alloc] initWithCapacity:_coinStr.length];
    for (NSInteger index = _coinStr.length - 1; index < _coinStr.length; index--) {
        [coinBitList addObject:[_coinStr substringWithRange:NSMakeRange(index, 1)]];
    }
    self.coinBitList = [coinBitList copy];
    
    [self updateBitViewsWithDuration:duration direction:direction];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger index = 0; index < self.bitViews.count; index++) {
        YLCoinBitView *bitView = self.bitViews[index];
        if (index == 0) {
            CGRect bitViewRect = bitView.frame;
            bitViewRect.origin = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetWidth(bitViewRect), 0);
            bitView.frame = bitViewRect;
        }
        else {
            YLCoinBitView *prevBitView = self.bitViews[index - 1];
            CGRect prevBitViewRect = prevBitView.frame;
            CGRect bitViewRect = bitView.frame;
            bitViewRect.origin = CGPointMake(CGRectGetMinX(prevBitViewRect) - CGRectGetWidth(bitViewRect), 0);
            bitView.frame = bitViewRect;
        }
    }
}


@end









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
    
//    self.backgroundColor = [UIColor redColor];
}

- (void) setCoinStr:(NSString *)coinStr {
    [self setCoinStr:coinStr duration:0 direction:NO];
}

- (void) setCoinStr:(NSString *)coinStr duration: (NSTimeInterval) duration direction: (BOOL) direction {
    [self.coinView setCoinStr:coinStr duration:duration direction: direction];
    
    CGRect coinViewRect = self.coinView.frame;
    CGPoint upperRight = CGPointMake(CGRectGetMaxX(coinViewRect), 0);
    coinViewRect.size = CGSizeMake([self.coinView viewWidth], CGRectGetHeight(self.bounds));
    coinViewRect.origin = CGPointMake(upperRight.x - coinViewRect.size.width, 0);
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
    
    [self layoutCoinView];
    self.coinView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void) layoutCoinView {
    CGRect coinViewRect = self.coinView.frame;
    coinViewRect.size = CGSizeMake([self.coinView viewWidth], CGRectGetHeight(self.bounds));
    self.coinView.frame = coinViewRect;
}

@end
