//
//  ViewController.m
//  ACBitAnimation
//
//  Created by Alan Chen on 2018/5/10.
//  Copyright © 2018年 Alan Chen. All rights reserved.
//

#import "ViewController.h"

#import "YLCoinView.h"

#import "YLSignProgressView.h"


#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define RGBA(A,B,C,D) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:D]


@interface ViewController ()

//@property (nonatomic, strong) YLCoinBitView *bitView;
//@property (nonatomic, strong) YLCoinInnerView *bitInnerView;
@property (nonatomic, strong) YLCoinView *coinView;

@property (nonatomic, strong) YLSignProgressView *signProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testSignProgressView];
    
//    [self testBit3View];
    
//    [self testFont];
}


- (void) testSignProgressView {
    self.view.backgroundColor = RGB(201, 175, 121);

    YLSignProgressView *signProgressView = [[YLSignProgressView alloc] initWithFrame:CGRectMake(20, 200, 300, 2)];
    self.signProgressView = signProgressView;
    
    [self.view addSubview:signProgressView];
    
    UIButton *resetBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    resetBtn4.frame = CGRectMake(200, 240, 100, 50);
    [resetBtn4 setTitle:@"Reset" forState:UIControlStateNormal];
    [resetBtn4 addTarget:self action:@selector(resetBtn4Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn4];
    
    UIButton *startBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn4.frame = CGRectMake(200, 320, 100, 50);
    [startBtn4 setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn4 addTarget:self action:@selector(startBtn4Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn4];
}

- (void) resetBtn4Tapped: (id) sender {
    [self.signProgressView set2Stage:1];
}

- (void) startBtn4Tapped: (id) sender {
    [self.signProgressView plusStageWithDuration:1];
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
    [self.coinView setCoinStr:@"200" duration:3];
}

- (void) startBtn3Tapped: (id) sender {
    [self.coinView setCoinStr:@"5,500" duration:3];
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
    UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:24]; // DINCondensed-Bold // DINAlternate & DINCondensed
//    UIFont *font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold]; // DINCondensed-Bold // DINAlternate & DINCondensed
//    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSLog(@"font = %@", font);
    
    NSLog(@"ascender = %f", font.ascender);
    NSLog(@"descender = %f", font.descender);
    NSLog(@"pointSize = %f", font.pointSize);
    NSLog(@"capHeight = %f", font.capHeight);
    NSLog(@"xHeight = %f", font.xHeight);
    NSLog(@"lineHeight = %f", font.lineHeight);
    NSLog(@"leading = %f", font.leading);
    
    
    NSArray *bitArrays = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @",", @" "];
    for (NSString *bit in bitArrays) {
//        NSString *bit = @"8";
        CGSize bitSize = [bit sizeWithAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSLog(@"bit = %@, bitSize = %@", bit, NSStringFromCGSize(bitSize));
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.minimumLineHeight = 3;
        paraStyle.minimumLineHeight = 3;
        paraStyle.alignment = NSTextAlignmentJustified;
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        NSAttributedString *bitAttr = [[NSAttributedString alloc] initWithString:bit attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]/*, NSParagraphStyleAttributeName: paraStyle*/}];
        CGSize bitAttriSize = [bitAttr boundingRectWithSize:CGSizeMake(100, 100) options:0 context:nil].size;
        NSLog(@"bit = %@, bitAttriSize = %@", bit, NSStringFromCGSize(bitAttriSize));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
