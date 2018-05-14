//
//  ViewController.m
//  ACBitAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import "ViewController.h"

#import "YLCoinView.h"

@interface ViewController ()

//@property (nonatomic, strong) YLCoinBitView *bitView;
//@property (nonatomic, strong) YLCoinInnerView *bitInnerView;
@property (nonatomic, strong) YLCoinView *coinView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testBit3View];
}


- (void) testBit3View {
    YLCoinView *coinView = [[YLCoinView alloc] initWithFrame:CGRectMake(100, 200, 65, 28)];
    self.coinView = coinView;
    [self.coinView setCoinStr:@"352"];

    [self.view addSubview:coinView];
    
    UIButton *resetBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    resetBtn3.frame = CGRectMake(200, 200, 100, 50);
    [resetBtn3 setTitle:@"Reset" forState:UIControlStateNormal];
    [resetBtn3 addTarget:self action:@selector(resetBtn3Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn3];
    
    UIButton *startBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn3.frame = CGRectMake(200, 300, 100, 50);
    [startBtn3 setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn3 addTarget:self action:@selector(startBtn3Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn3];
}


- (void) resetBtn3Tapped: (id) sender {
    [self.coinView setCoinStr:@"200" duration:5];
}

- (void) startBtn3Tapped: (id) sender {
    [self.coinView setCoinStr:@"5,500" duration:5];
}


//- (void) testBit2View {
//    YLCoinInnerView *bitInnerView = [[YLCoinInnerView alloc] initWithFrame:CGRectMake(100, 200, 65, 28)];
//    self.bitInnerView = bitInnerView;
//
//    [self.view addSubview:bitInnerView];
//
//    UIButton *resetBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    resetBtn2.frame = CGRectMake(200, 200, 100, 50);
//    [resetBtn2 setTitle:@"Reset" forState:UIControlStateNormal];
//    [resetBtn2 addTarget:self action:@selector(resetBtn2Tapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:resetBtn2];
//
//    UIButton *startBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    startBtn2.frame = CGRectMake(200, 300, 100, 50);
//    [startBtn2 setTitle:@"Start" forState:UIControlStateNormal];
//    [startBtn2 addTarget:self action:@selector(startBtn2Tapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:startBtn2];
//}
//
//
//- (void) resetBtn2Tapped: (id) sender {
//    [self.bitInnerView setCoinStr:@"0" duration:1 direction:NO];
//}
//
//- (void) startBtn2Tapped: (id) sender {
//    [self.bitInnerView setCoinStr:@"4,239" duration:1 direction:YES];
//}
//
//- (void) testBitView {
//    YLCoinBitView *bitView = [[YLCoinBitView alloc] initWithFrame:CGRectMake(100, 200, 17, 28)];
//    NSString *bitSeqStr = @" ,5";
//    [bitView setCoinList: [bitSeqStr componentsSeparatedByString:@","]];
//    [bitView setCurrentBit:@" "];
//    self.bitView = bitView;
//
//    [self.view addSubview:bitView];
//
//    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    resetBtn.frame = CGRectMake(200, 200, 100, 50);
//    [resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
//    [resetBtn addTarget:self action:@selector(resetBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:resetBtn];
//
//    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    startBtn.frame = CGRectMake(200, 300, 100, 50);
//    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
//    [startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:startBtn];
//}
//
//- (void) resetBtnTapped: (id) sender {
//    NSString *bitSeqStr = @" ,5";
//    [self.bitView setCoinList: [bitSeqStr componentsSeparatedByString:@","]];
//    [self.bitView setCurrentBit:@" "];
//}
//
//- (void) startBtnTapped: (id) sender {
//    NSString *bitSeqStr = @" ,5";
//    [self.bitView setCoinList: [bitSeqStr componentsSeparatedByString:@","]];
////    [self.bitView setCurrentBit:@"5"];
//    [self.bitView setCurrentBit:@"5" duration:1];
//}

- (void) allFonts {
    NSArray *familyNames =[[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    
    NSLog(@"[familyNames count]===%lu",(unsigned long)[familyNames count]);
    for(NSInteger familyCount=0;familyCount<[familyNames count]; familyCount++)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:familyCount]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:familyCount]]];
        for(NSInteger fontCount=0; fontCount<[fontNames count]; fontCount++)
        {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:fontCount]);
            
        }
    }
}

- (void) testFont {
//    UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:17]; // DINCondensed-Bold // DINAlternate & DINCondensed
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSLog(@"font = %@", font);
    
    NSLog(@"ascender = %f", font.ascender);
    NSLog(@"descender = %f", font.descender);
    NSLog(@"pointSize = %f", font.pointSize);
    NSLog(@"capHeight = %f", font.capHeight);
    NSLog(@"xHeight = %f", font.xHeight);
    NSLog(@"lineHeight = %f", font.lineHeight);
    NSLog(@"leading = %f", font.leading);
    
    NSString *bit = @"8";
    CGSize bitSize = [bit sizeWithAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSLog(@"bitSize = %@", NSStringFromCGSize(bitSize));
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.minimumLineHeight = 3;
    paraStyle.minimumLineHeight = 3;
    paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSAttributedString *bitAttr = [[NSAttributedString alloc] initWithString:bit attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]/*, NSParagraphStyleAttributeName: paraStyle*/}];
    CGSize bitAttriSize = [bitAttr boundingRectWithSize:CGSizeMake(100, 100) options:0 context:nil].size;
    NSLog(@"bitAttriSize = %@", NSStringFromCGSize(bitAttriSize));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
