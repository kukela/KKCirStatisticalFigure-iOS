//
//  ViewController.m
//  CirStatisticalFigure
//
//  Created by kukela on 16/4/22.
//  Copyright © 2016年 kukela. All rights reserved.
//

#import "ViewController.h"
#import "KKCirStatisticalFigureView.h"
#import "NSTimer+KKTools.h"

@interface ViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet KKCirStatisticalFigureView *cirStatisticalFigureView;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@end

@implementation ViewController{
    NSTimer *testDataTimer;
    CGFloat speed;
    BOOL isStopTestDataTimer;
    NSInteger testStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [NSThread detachNewThreadSelector:@selector(testData) toTarget:self withObject:nil];
}

#pragma mark - Init

-(void)initView{
    self.cirStatisticalFigureView.backgroundColor = [UIColor clearColor];
    self.cirStatisticalFigureView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.cirStatisticalFigureView.isAdapter = YES;
    speed = 0.1f;
    testStyle = 1;
    [self.speedSlider setValue:speed animated:YES];
    
//    self.cirStatisticalFigureView.percentageArray = @[@104, @2, @5, @1, @4];
//    self.cirStatisticalFigureView.startAngle = 1.413717;
//    self.cirStatisticalFigureView.isClockwise = NO;
}

#pragma mark - Data

-(void)testData{
    if (!testDataTimer) {
        testDataTimer = [NSTimer kkScheduledTimerWithTimeInterval:speed block:^{
            NSArray *percentageArray = [self randomPerentageArrayWithStyle:testStyle];
            CGFloat startAngle = [self randomAngle];
            BOOL isClockwise = arc4random() % 2;
            
            self.cirStatisticalFigureView.percentageArray = percentageArray;
            self.cirStatisticalFigureView.startAngle = startAngle;
            self.cirStatisticalFigureView.isClockwise = isClockwise;
            
            NSMutableString *percentageArrayMS = [NSMutableString string];
            for (NSInteger i = 0; i < percentageArray.count; i++) {
                if (!i) {
                    [percentageArrayMS appendString:@"@["];
                }
                NSString *percentageString = [NSString stringWithFormat:@"@%ld", [percentageArray[i] integerValue]];
                [percentageArrayMS appendString:percentageString];
                if (i == percentageArray.count - 1) {
                    [percentageArrayMS appendString:@"];"];
                }else{
                    [percentageArrayMS appendString:@", "];
                }
            }
            
            NSLog(@"%f %@", startAngle, isClockwise ? @"YES" : @"NO");
            NSLog(@"%@", percentageArrayMS);
            
            NSLog(@"------------------------------------------------------ ");
        } repeats:YES];
        [testDataTimer fire];
        [[NSRunLoop currentRunLoop] run];
    }
}

#pragma mark - Button

- (IBAction)button:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{
            isStopTestDataTimer = !isStopTestDataTimer;
            NSString *buttonTitle = nil;
            if (isStopTestDataTimer) {
                [testDataTimer setFireDate:[NSDate distantFuture]];
                buttonTitle = @"开始";
            }else{
                [testDataTimer setFireDate:[NSDate date]];
                buttonTitle = @"暂停";
            }
            [sender setTitle:buttonTitle forState:UIControlStateNormal];
            break;
        }
        case 1:{
            [testDataTimer setFireDate:[NSDate distantFuture]];
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            for (NSInteger i = 0; i <= 6; i++) {
                [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"样式 %ld", (long)i]];
            }
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UISlider

- (IBAction)sliderTouchDown:(UISlider *)sender {
    isStopTestDataTimer = NO;
    [self.stopButton setTitle:@"暂停" forState:UIControlStateNormal];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    speed = sender.value;
    [testDataTimer invalidate];
    testDataTimer = nil;
    [NSThread detachNewThreadSelector:@selector(testData) toTarget:self withObject:nil];
}

#pragma mark - UIActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    testStyle = buttonIndex - 1;
    [testDataTimer setFireDate:[NSDate date]];
}

#pragma mark - Private

#define ONE_ANGLE_PI 0.01745329251994329547437168059786927
-(CGFloat)randomAngle{
    NSInteger angleDegreeRandom = arc4random() % 381;
    CGFloat angle = angleDegreeRandom * ONE_ANGLE_PI;
    return angle;
}

-(NSArray *)randomPerentageArrayWithStyle:(NSInteger)style{
    NSMutableArray *percentageMArray = [NSMutableArray array];
    switch (style) {
        case 0:{
            for (NSInteger i = 0; i < 5; i++) {
                NSInteger percentage = arc4random() % 100 + 1;
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 1:{
            for (NSInteger i = 0; i < 5; i++) {
                NSInteger percentage = 0;
                if (i) {
                    percentage = arc4random() % 7 + 1;
                }else{
                    percentage = arc4random() % 120 + 1;
                }
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 2:{
            for (NSInteger i = 0; i < 15; i++) {
                NSInteger percentage = arc4random() % 100 + 1;
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 3:{
            NSInteger percentageNumber = arc4random() % 15 + 1;
            for (NSInteger i = 0; i < percentageNumber; i++) {
                NSInteger percentage = arc4random() % 100 + 1;
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 4:{
            NSInteger percentageNumber = arc4random() % 15 + 1;
            for (NSInteger i = 0; i < percentageNumber; i++) {
                NSInteger percentage = 0;
                if (i) {
                    percentage = arc4random() % 7 + 1;
                }else{
                    percentage = arc4random() % 150 + 1;
                }
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 5:{
            NSInteger percentageNumber = arc4random() % 35 + 1;
            for (NSInteger i = 0; i < percentageNumber; i++) {
                NSInteger percentage = 0;
                if (i) {
                    percentage = arc4random() % 7 + 1;
                }else{
                    percentage = arc4random() % 50 + 1;
                }
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        case 6:{
            NSInteger percentageNumber = arc4random() % 100 + 1;
            for (NSInteger i = 0; i < percentageNumber; i++) {
                NSInteger percentage = 0;
                if (i) {
                    percentage = arc4random() % 7 + 1;
                }else{
                    percentage = arc4random() % 50 + 1;
                }
                [percentageMArray addObject:@(percentage)];
            }
            break;
        }
        default:
            break;
    }
    return percentageMArray;
}


@end
