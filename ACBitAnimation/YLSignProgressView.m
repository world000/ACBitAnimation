//
//  YLSignProgressView.m
//  ACBitAnimation
//
//  Created by Alan Chen on 2018/5/14.
//  Copyright © 2018年 Xiaoxin Tech Inc. All rights reserved.
//

#import "YLSignProgressView.h"

#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define RGBA(A,B,C,D) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:D]

#pragma mark -
#pragma mark - YLSignNodeView
#pragma mark -

static const CGFloat kYLSignNodeViewDotSize = 4;

@interface YLSignNodeView : UIView

@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIView *dotHeartView;

- (void) alphaDotView: (BOOL) hide;

@end

@implementation YLSignNodeView

- (void) commonSetup {
    self.backgroundColor = RGB(241, 215, 181);
    
    _dotView = [[UIView alloc] initWithFrame:self.bounds];
    _dotView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_dotView];
    
    _dotHeartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kYLSignNodeViewDotSize, kYLSignNodeViewDotSize)];
    _dotHeartView.backgroundColor = RGB(255, 159, 3);
    _dotHeartView.layer.cornerRadius = ceilf(kYLSignNodeViewDotSize / 2);
    _dotHeartView.layer.masksToBounds = YES;

    [_dotView addSubview:_dotHeartView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (void) alphaDotView: (BOOL) hide {
    if (hide) {
        if (self.dotView.alpha != 0) {
            self.dotView.alpha = 0;
        }
    }
    else {
        if (self.dotView.alpha != 1) {
            self.dotView.alpha = 1;
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.dotView.frame = self.bounds;
    self.dotHeartView.center = CGPointMake(CGRectGetMidX(self.dotView.bounds), CGRectGetMidX(self.dotView.bounds));
}

@end




#pragma mark -
#pragma mark - YLSignProgressView
#pragma mark -

@interface YLSignProgressView ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *nodeView;

@property (nonatomic, assign) NSInteger stage;

@end

static const CGFloat kYLSignProgressViewNodeSize = 10;
static const NSInteger kYLSignProgressViewStageCount = 7;

@implementation YLSignProgressView

- (void) commonSetup {
    _stage = 0;
    
    self.backgroundColor = RGB(241, 215, 181);
    
    _lineView = [[UIView alloc] initWithFrame:self.bounds];
    _lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lineView];
    
    NSMutableArray *nodeViews = [[NSMutableArray alloc] initWithCapacity:kYLSignProgressViewStageCount];
    for (NSInteger index = 0; index < kYLSignProgressViewStageCount; index++) {
        if (index == (kYLSignProgressViewStageCount - 1)) {
            UIImageView *endImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 18)];
            endImageView.image = [UIImage imageNamed:@"v472_500_icon"];
            [self addSubview:endImageView];
            
            [nodeViews addObject:endImageView];
        }
        else {
            YLSignNodeView *nodeView = [[YLSignNodeView alloc] initWithFrame:CGRectMake(0, 0, kYLSignProgressViewNodeSize, kYLSignProgressViewNodeSize)];
            nodeView.layer.cornerRadius = ceilf(kYLSignProgressViewNodeSize / 2);
            nodeView.layer.masksToBounds = YES;
            
            [nodeView alphaDotView:YES];

            [self addSubview:nodeView];
            
            [nodeViews addObject:nodeView];
        }
    }
    
    self.nodeView = [nodeViews copy];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        [self commonSetup];
    }
    
    return self;
}

- (void) set2Stage: (NSInteger) stage {
    [self set2Stage:stage duration:0];
}

- (void) set2Stage: (NSInteger) stage duration: (NSTimeInterval) duration {
    if (stage < 0 || stage > 6) {
        return;
    }
    
    if (_stage == stage) {
        return;
    }
    
    _stage = stage;
    
    if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            [self updateNodeViewsAlpha];
            [self layoutLineView];
        }];
    }
    else {
        [self updateNodeViewsAlpha];
        [self layoutLineView];
    }
}

- (void) plusStageWithDuration: (NSTimeInterval) duration {
    [self set2Stage:(_stage + 1) duration:duration];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSInteger nodeCount = self.nodeView.count;
    
    if (nodeCount == 0) {
        return;
    }
    
    if (nodeCount == 1) {
        UIView *nodeView = self.nodeView.firstObject;
        nodeView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        return;
    }
    
    CGFloat nodeWidth = CGRectGetWidth(self.bounds) / (nodeCount - 1);
    for (NSInteger index = 0; index < self.nodeView.count; index++) {
        UIView *nodeView = self.nodeView[index];
        CGPoint center = CGPointMake(floorf(index * nodeWidth), floorf(CGRectGetMidY(self.bounds)));
        nodeView.center = center;
    }
    
    [self layoutLineView];
}

- (void) layoutLineView {
    NSInteger nodeCount = self.nodeView.count;
    
    if (nodeCount == 0) {
        return;
    }
    
    if (nodeCount == 1) {
        self.lineView.frame = CGRectZero;
    }
    
    CGFloat nodeWidth = CGRectGetWidth(self.bounds) / (nodeCount - 1);
    CGRect lineRect = self.lineView.frame;
    lineRect.size.width = floorf(self.stage * nodeWidth);
    self.lineView.frame = lineRect;
}

- (void) updateNodeViewsAlpha {
    for (NSInteger index = 0; index < (self.nodeView.count - 1); index++) {
        YLSignNodeView *nodeView = self.nodeView[index];
        [nodeView alphaDotView:(index > self.stage)];
    }
}

@end
