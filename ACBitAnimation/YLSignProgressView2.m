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

- (void) alphaDotView: (CGFloat) alpha;

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

- (void) alphaDotView: (CGFloat) alpha {
    self.dotView.alpha = alpha;
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

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CADisplayLink *cycleDLink;
@property (nonatomic, assign) CFTimeInterval cycleTimeStamp;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat targetProgress;

@end

static const CGFloat kYLSignProgressViewNodeSize = 10;
static const NSInteger kYLSignProgressViewStageCount = 7;

@implementation YLSignProgressView

- (void) dealloc {
    [self stopProgress];
}

- (void) commonSetup {
    _progress = 0;
    
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
            
            [nodeView alphaDotView:0];

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
    
    CGFloat targetProgress = 0;
    CGFloat segmentProgress = 1.0f / (self.nodeView.count - 1);
    CGFloat progress = stage * segmentProgress;
    if (fabs(progress - 1) < 0.01f) {
        targetProgress = 1;
    }
    else {
        targetProgress = stage * segmentProgress;
    }
    
    if (duration > 0) {
        [self startProgress:targetProgress duration:duration];
    }
    else {
        [self stopProgress];
        
        if (fabs(targetProgress - self.progress) <= FLT_EPSILON) {
            return;
        }
        
        self.progress = targetProgress;
        
        [self layoutLineView];
        [self updateNodeViewsAlpha];
    }
}

- (void) startProgress: (CGFloat) targetProgress duration: (NSTimeInterval) duration {
    [self stopProgress];
    
    if (fabs(targetProgress - self.progress) <= FLT_EPSILON) {
        return;
    }
    
    self.cycleDLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(cycleDisplayLinkFired:)];
    self.cycleTimeStamp = 0;
    self.targetProgress = targetProgress;
    self.velocity = duration; // fabs(self.targetProgress - self.progress) / duration;
    
    [_cycleDLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) stopProgress {
    if (self.cycleDLink) {
        [self.cycleDLink invalidate];
        self.cycleDLink = nil;
        self.cycleTimeStamp = 0;
    }
}

- (void) cycleDisplayLinkFired: (CADisplayLink *) sender {
    if (self.cycleTimeStamp != 0) {
        CFTimeInterval interval = sender.timestamp - self.cycleTimeStamp;
        if (interval >= 0.01f) {
            NSInteger direction = (self.targetProgress > self.progress ? 1 : -1);
            self.progress += (((CGFloat)(interval / self.velocity)) * direction);
            if (self.progress > 1) {
                self.progress = 1;
            }
            else if (self.progress <= 0) {
                self.progress = 0;
            }
            
            self.cycleTimeStamp = sender.timestamp;
            
            if ((direction > 0 && self.progress >= self.targetProgress)
                || (direction < 0 && self.progress <= self.targetProgress)) {
                [self stopProgress];
                self.progress = self.targetProgress;
            }
            
            [self layoutLineView];
            [self updateNodeViewsAlpha];
        }
    }
    else {
        self.cycleTimeStamp = sender.timestamp;
    }
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
    
    CGFloat totalWidth = CGRectGetWidth(self.bounds);
    CGRect lineRect = self.lineView.frame;
    lineRect.size.width = floorf(self.progress * totalWidth);
    self.lineView.frame = lineRect;
}

- (void) updateNodeViewsAlpha {
    CGFloat segmentProgress = 1.0f / (self.nodeView.count - 1);

    for (NSInteger index = 0; index < (self.nodeView.count - 1); index++) {
        YLSignNodeView *nodeView = self.nodeView[index];
        CGFloat indexProgress = index * 1.0f / (self.nodeView.count - 1);
        if (indexProgress <= self.progress) {
            [nodeView alphaDotView:1];
        }
        else {
            CGFloat diffProcess = indexProgress - self.progress;
            if (diffProcess < segmentProgress) {
                [nodeView alphaDotView:(1 - (diffProcess / segmentProgress))];
            }
            else {
                [nodeView alphaDotView:0];
            }
        }
    }
}

@end
