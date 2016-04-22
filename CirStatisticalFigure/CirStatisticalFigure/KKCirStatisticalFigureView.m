//
//  KKCirStatisticalFigureView.m
//  HaoCheZhu
//
//  Created by kukela on 16/4/15.
//  Copyright © 2016年 kukela. All rights reserved.
//

#import "KKCirStatisticalFigureView.h"

#define DOUBLE_PI 6.28318530717958623199592693708837032

@implementation KKCirStatisticalFigureView{
    __block void (^ _Nullable drawPercentagesArcPath)(NSArray * _Nonnull percentagesArcPathArray);
    __block void (^ _Nullable drawPercentagesLinkPoint)(NSArray * _Nonnull percentagesLinkPointArray);
    __block void (^ _Nullable drawLabelsLinkPoint)(NSArray * _Nonnull labelsLinkPointArray);
    __block void (^ _Nullable drawLabelsFrameArray)(NSArray * _Nonnull labelsFrameArray,
                                                         NSArray * _Nonnull isLabelsLeftArray);
    __block void (^ _Nullable drawLabelsLinkPath)(NSArray * _Nonnull labelsLinkPathArray);
    CGFloat screenProportion;
    BOOL isSmallSize;
    BOOL isFirstRun;
    CGFloat labelsLinkPointCenterXDiffMax;
    CGFloat labelsLinkPointCenterXConstRandom;
    CGFloat labelsLinkPointCenterXPositiveRandom;
}

#pragma mark - Set

-(void)setPercentageArray:(NSArray *)percentageArray{
     _percentageArray = percentageArray;
    [self setNeedsDisplay];
}

#pragma mark - Get

-(CGFloat)percentageRadius{
    if (!_percentageRadius) {
        _percentageRadius = 40;
    }
    return _percentageRadius;
}

-(CGFloat)percentageAndThicknessRadius{
    if (!_percentageAndThicknessRadius) {
        if (self.isAdapter) {
            self.percentageRadius = [self getProportionValue:self.percentageRadius isConsiderSmallSize:NO];
            self.percentageArcPathThickness = [self getProportionValue:self.percentageArcPathThickness isConsiderSmallSize:NO];
        }
        _percentageAndThicknessRadius = self.percentageRadius + self.percentageArcPathThickness / 2.0f;
    }
    return _percentageAndThicknessRadius;
}

-(CGFloat)percentageArcPathThickness{
    if (!_percentageArcPathThickness) {
        _percentageArcPathThickness = 9;
    }
    return _percentageArcPathThickness;
}

-(NSArray *)percentageArcPathColorArray{
    if (!_percentageArcPathColorArray) {
        _percentageArcPathColorArray =
        @[[UIColor colorWithRed:0.7647059f green:0.8980392f blue:0.9450980f alpha:1],
          [UIColor colorWithRed:0.6509804f green:0.8549020f blue:0.9294118f alpha:1],
          [UIColor colorWithRed:0.4666667f green:0.8078431f blue:0.9294118f alpha:1],
          [UIColor colorWithRed:0.2784314f green:0.7568627f blue:0.9294118f alpha:1],
          [UIColor colorWithRed:0.0941176f green:0.7058824f blue:0.9294118f alpha:1]];
    }
    return _percentageArcPathColorArray;
}

-(CGFloat)percentagesLinkPointRadius{
    if (!_percentagesLinkPointRadius) {
        _percentagesLinkPointRadius = 2.5f;
    }
    return _percentagesLinkPointRadius;
}

-(CGFloat)percentagesLinkPointPathThickness{
    if (!_percentagesLinkPointPathThickness) {
        _percentagesLinkPointPathThickness = 1.5f;
    }
    return _percentagesLinkPointPathThickness;
}

-(UIColor *)percentagesLinkPointPathFillColor{
    if (!_percentagesLinkPointPathFillColor) {
        _percentagesLinkPointPathFillColor = [UIColor colorWithRed:0.0941176f green:0.7058824f blue:0.9294118f alpha:1];
    }
    return _percentagesLinkPointPathFillColor;
}

-(UIColor *)percentagesLinkPointPathStrokeColor{
    if (!_percentagesLinkPointPathStrokeColor) {
        _percentagesLinkPointPathStrokeColor = [UIColor whiteColor];
    }
    return _percentagesLinkPointPathStrokeColor;
}

-(CGFloat)labelLinkPathThickness{
    if (!_labelLinkPathThickness) {
        _labelLinkPathThickness = 1;
    }
    return _labelLinkPathThickness;
}

-(UIColor *)labelLinkPathColor{
    if (!_labelLinkPathColor) {
        _labelLinkPathColor = [UIColor colorWithRed:0.0941176f green:0.7058824f blue:0.9294118f alpha:1];
    }
    return _labelLinkPathColor;
}

-(CGFloat)labelAndLinkPointSpacing{
    if (!_labelAndLinkPointSpacing) {
        _labelAndLinkPointSpacing = 8;
    }
    return _labelAndLinkPointSpacing;
}

-(CGSize)labelSize{
    if (!_labelSize.width || !_labelSize.height) {
        _labelSize = CGSizeMake(65, 15);
    }
    return _labelSize;
}

-(NSArray *)labelsColorArray{
    if (!_labelsColorArray) {
        _labelsColorArray = self.percentageArcPathColorArray;
    }
    return _labelsColorArray;
}

-(CGFloat)labelLinkYLimitSpacingPercentage{
    if (!_labelLinkYLimitSpacingPercentage) {
        _labelLinkYLimitSpacingPercentage = 0.4f;
    }
    return _labelLinkYLimitSpacingPercentage;
}

-(CGFloat)labelLinkPointXConstRandom{
    if (!_labelLinkPointXConstRandom) {
        _labelLinkPointXConstRandom = self.percentageAndThicknessRadius * 0.54f;
    }
    return _labelLinkPointXConstRandom;
}

-(CGFloat)labelLinkPointXPositiveRandom{
    if (!_labelLinkPointXPositiveRandom) {
        _labelLinkPointXPositiveRandom = self.labelLinkPointXConstRandom * 0.28f;
    }
    return _labelLinkPointXPositiveRandom;
}

-(CGFloat)labelLinkPointXNegativeRandom{
    if (!_labelLinkPointXNegativeRandom) {
        _labelLinkPointXNegativeRandom = self.labelLinkPointXConstRandom * 0.2f;
    }
    return _labelLinkPointXNegativeRandom;
}

-(CGFloat)labelLinkPointYMaxRandom{
    if (!_labelLinkPointYMaxRandom) {
        _labelLinkPointYMaxRandom = self.percentageAndThicknessRadius * 0.44f;
    }
    return _labelLinkPointYMaxRandom;
}

-(CGFloat)labelLinkOnePointXConstRandom{
    if (!_labelLinkOnePointXConstRandom) {
        _labelLinkOnePointXConstRandom = self.percentageAndThicknessRadius * 0.25f;
    }
    return _labelLinkOnePointXConstRandom;
}

-(CGFloat)labelLinkOnePointXPNRandom{
    if (!_labelLinkOnePointXPNRandom) {
        _labelLinkOnePointXPNRandom = self.percentageAndThicknessRadius * 0.07f;
    }
    return _labelLinkOnePointXPNRandom;
}

-(CGFloat)labelLinkPointXMax{
    if (!_labelLinkPointXMax) {
        _labelLinkPointXMax = self.percentageAndThicknessRadius * 0.65f;
    }
    return _labelLinkPointXMax;
}

#pragma mark - Init

-(void)drawRect:(CGRect)rect{
    if (!isFirstRun) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (size.height > size.width) {
            screenProportion = size.width / 320.0f;
            if (size.height < 500) {
                isSmallSize = YES;
            }
        }else{
            screenProportion = size.height / 320.0f;
            if (size.width < 500) {
                isSmallSize = YES;
            }
        }
        
        if (self.isAdapter) {
            [self adapterScreen];
        }
        isFirstRun = YES;
        CGFloat percentageRadius = self.percentageRadius + self.percentageArcPathThickness / 2.0f;
        labelsLinkPointCenterXDiffMax = percentageRadius * 0.2625f;
        labelsLinkPointCenterXConstRandom = self.percentageRadius * 0.3f;
        labelsLinkPointCenterXPositiveRandom = self.percentageRadius * 0.125f;
    }
    NSArray *percentageArray = self.percentageArray;
    if (percentageArray.count) {
        NSMutableArray *percentagesArcPathMArray = [NSMutableArray array];
//        NSMutableArray *percentagesLinkPointAngleMArray = [NSMutableArray array];
        NSMutableArray *percentagesLinkPointMArray = [NSMutableArray array];
        NSMutableArray *labelsLinkPointMArray = [NSMutableArray array];
        NSMutableArray *labelsFrameMArray = [NSMutableArray array];
        NSMutableArray *isLabelsLinkLeftMArray = [NSMutableArray array];
        NSMutableArray *isLabelsLinkTopMArray = [NSMutableArray array];
        NSMutableArray *labelsLinkPathMArray = [NSMutableArray array];
        
        CGSize size = rect.size;
        CGPoint center = CGPointMake(size.width / 2.0f,
                                     size.height / 2.0f);
        CGFloat percentageAndThicknessRadius = self.percentageAndThicknessRadius;
        CGFloat percentageArcStartAngle = 0;
        
        NSMutableArray *labelsLinkLeftTopCenterYMArray = [NSMutableArray array];
        NSInteger labelsLinkLeftTopNumber = 0;
        NSMutableArray *labelsLinkLeftBottomCenterYMArray = [NSMutableArray array];
        NSInteger labelsLinkLeftBottomNumber = 0;
        
        NSMutableArray *labelsLinkRightTopCenterYMArray = [NSMutableArray array];
        NSInteger labelsLinkRightTopNumber = 0;
        NSMutableArray *labelsLinkRightBottomCenterYMArray = [NSMutableArray array];
        NSInteger labelsLinkRightBottomNumber = 0;
        
        CGFloat startAngle = self.startAngle;
        BOOL isClockwise = self.isClockwise;
        
        NSInteger percentageMax = 0;
        for (NSNumber *percentageNumber in percentageArray) {
            NSInteger percentage = [percentageNumber integerValue];
            percentageMax += percentage;
        }
        
        for (NSInteger i = 0; i < percentageArray.count; i++) {
            //计算圆弧
            CGFloat percentage = [percentageArray[i] floatValue];
            if (percentage > 0) {
                CGFloat percentageArcEndAngle =
                [self accordingPercentageCalculateEndAngle:percentageMax
                                              withProgress:percentage
                                            withStartAngle:&percentageArcStartAngle
                                            withTotalAngle:0
                                           withisClockwise:isClockwise];
                UIBezierPath *percentageArcPath =
                [UIBezierPath bezierPathWithArcCenter:center
                                               radius:self.percentageRadius
                                           startAngle:percentageArcStartAngle + startAngle
                                             endAngle:percentageArcEndAngle + startAngle
                                            clockwise:isClockwise];
                percentageArcPath.lineWidth = self.percentageArcPathThickness;
                [percentagesArcPathMArray addObject:percentageArcPath];
                
                //计算圆弧上的点
                CGFloat percentageArcAngle = percentageArcEndAngle - percentageArcStartAngle;
//                NSLog(@"%.0f %f %f", percentage, percentageArcStartAngle, percentageArcEndAngle);
                
                CGFloat percentagesLinkPointAngle = percentageArcStartAngle + startAngle + percentageArcAngle / 2.0f;
                if (i) {
                    percentagesLinkPointAngle += [self randomAngle:percentageArcAngle withProportion:45 withIsPN:YES];
                }
//                [percentagesLinkPointAngleMArray addObject:@(percentagesLinkPointAngle)];
                
                CGPoint percentagesLinkPoint =
                CGPointMake(percentageAndThicknessRadius *
                            cos(percentagesLinkPointAngle) + center.x,
                            percentageAndThicknessRadius *
                            sin(percentagesLinkPointAngle) + center.y);
                [percentagesLinkPointMArray addObject:[NSValue valueWithCGPoint:percentagesLinkPoint]];
                
                BOOL isLabelLinkLeft = NO;
                BOOL isLabelLinkTop = NO;
                if (percentagesLinkPoint.y < center.y) {
                    isLabelLinkTop = YES;
                }
                if (percentagesLinkPoint.x < center.x) {
                    isLabelLinkLeft = YES;
                    if (isLabelLinkTop) {
                        [labelsLinkLeftTopCenterYMArray addObject:@(percentagesLinkPoint.y)];
                        labelsLinkLeftTopNumber++;
                    }else{
                        [labelsLinkLeftBottomCenterYMArray addObject:@(percentagesLinkPoint.y)];
                        labelsLinkLeftBottomNumber++;
                    }
                }else{
                    if (isLabelLinkTop) {
                        [labelsLinkRightTopCenterYMArray addObject:@(percentagesLinkPoint.y)];
                        labelsLinkRightTopNumber++;
                    }else{
                        [labelsLinkRightBottomCenterYMArray addObject:@(percentagesLinkPoint.y)];
                        labelsLinkRightBottomNumber++;
                    }
                }
                [isLabelsLinkLeftMArray addObject:@(isLabelLinkLeft)];
                [isLabelsLinkTopMArray addObject:@(isLabelLinkTop)];
                
                percentageArcStartAngle = percentageArcEndAngle;
            }
        }
        
        NSArray *labelsLinkLeftTopCenterYArray =
        [labelsLinkLeftTopCenterYMArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        NSArray *labelsLinkLeftBottomCenterYArray =
        [labelsLinkLeftBottomCenterYMArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        
        NSArray *labelsLinkRightTopCenterYArray =
        [labelsLinkRightTopCenterYMArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        NSArray *labelsLinkRightBottomCenterYArray =
        [labelsLinkRightBottomCenterYMArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        
        CGSize labelSize = self.labelSize;
        CGFloat labelTopSpacing = labelSize.height / 2.0f;
        UIEdgeInsets edgeInsets = self.edgeInsets;
        CGFloat labelLinkYLimitSpacing = percentageAndThicknessRadius * self.labelLinkYLimitSpacingPercentage;
        CGFloat bottomSpacing = size.height - edgeInsets.bottom;
//        CGFloat xShapeRightBottomAngle = M_PI_2;
//        CGFloat xShapeLeftBottomAngle = xShapeRightBottomAngle + M_PI;
//        CGFloat xShapeLeftTopAngle = xShapeLeftBottomAngle + M_PI;
//        CGFloat xShapeRightTopAngle = xShapeLeftTopAngle + M_PI;
        
        CGFloat labelsLinkLeftTopY = [[labelsLinkLeftTopCenterYArray lastObject] floatValue] + labelLinkYLimitSpacing;
        if (labelsLinkLeftTopY > center.y) {
            labelsLinkLeftTopY = center.y;
        }
        CGFloat labelsLinkLeftTopLimitHeight = (labelsLinkLeftTopY - edgeInsets.top) / labelsLinkLeftTopNumber;
        CGFloat labelsLinkLeftTopLimitHeightCenter = labelsLinkLeftTopLimitHeight / 2.0f;
        
        CGFloat labelsLinkLeftBottomY = [[labelsLinkLeftBottomCenterYArray firstObject] floatValue] - labelLinkYLimitSpacing;
        if (labelsLinkLeftBottomY < center.y) {
            labelsLinkLeftBottomY = center.y;
        }
        CGFloat labelsLinkLeftBottomLimitHeight = (bottomSpacing - labelsLinkLeftBottomY) / labelsLinkLeftBottomNumber;
        CGFloat labelsLinkLeftBottomLimitHeightCenter = labelsLinkLeftBottomLimitHeight / 2.0f;
        
        CGFloat labelsLinkRightTopY = [[labelsLinkRightTopCenterYArray lastObject] floatValue] + labelLinkYLimitSpacing;
        if (labelsLinkRightTopY > center.y) {
            labelsLinkRightTopY = center.y;
        }
        CGFloat labelsLinkRightTopLimitHeight = (labelsLinkRightTopY - edgeInsets.top) / labelsLinkRightTopNumber;
        CGFloat labelsLinkRightTopLimitHeightCenter = labelsLinkRightTopLimitHeight / 2.0f;
        
        CGFloat labelsLinkRightBottomY = [[labelsLinkRightBottomCenterYArray firstObject] floatValue] - labelLinkYLimitSpacing;
        if (labelsLinkRightBottomY < center.y) {
            labelsLinkRightBottomY = center.y;
        }
        CGFloat labelsLinkRightBottomLimitHeight = (bottomSpacing - labelsLinkRightBottomY) / labelsLinkRightBottomNumber;
        CGFloat labelsLinkRightBottomLimitHeightCenter = labelsLinkRightBottomLimitHeight / 2.0f;
        
        CGFloat labelAndLinkPointSpacing = self.labelAndLinkPointSpacing;
        CGFloat labelPointTopSpacing = edgeInsets.top;
        CGFloat labelPointLeftSpacing = edgeInsets.left;
        CGFloat labelPointBottomSpacing = size.height - labelTopSpacing - edgeInsets.bottom;
        CGFloat labelPointRightSpacing = size.width - edgeInsets.right - labelSize.width - labelAndLinkPointSpacing;
        
        CGFloat labelLinkPointYRandomConstProportion = 0.65f;
        CGFloat labelLinkPointYRandomNegativeProportion = 0.7f;
        
        CGFloat labelLinkPointLeftTopYConstRandom = (labelsLinkLeftTopLimitHeight - labelSize.height) / 2.0f * labelLinkPointYRandomConstProportion;
        CGFloat labelLinkPointLeftTopYNegativeRandom = labelLinkPointLeftTopYConstRandom * labelLinkPointYRandomNegativeProportion;
        
        CGFloat labelLinkPointLeftBottomYConstRandom = (labelsLinkLeftBottomLimitHeight - labelSize.height) / 2.0f * labelLinkPointYRandomConstProportion;
        CGFloat labelLinkPointLeftBottomYNegativeRandom = labelLinkPointLeftBottomYConstRandom * labelLinkPointYRandomNegativeProportion;
        
        CGFloat labelLinkPointRightTopYConstRandom = (labelsLinkRightTopLimitHeight - labelSize.height) / 2.0f * labelLinkPointYRandomConstProportion;
        CGFloat labelLinkPointRightTopYNegativeRandom = labelLinkPointRightTopYConstRandom * labelLinkPointYRandomNegativeProportion;
        
        CGFloat labelLinkPointRightBottomYConstRandom = (labelsLinkRightBottomLimitHeight - labelSize.height) / 2.0f * labelLinkPointYRandomConstProportion;
        CGFloat labelLinkPointRightBottomYNegativeRandom = labelLinkPointRightBottomYConstRandom * labelLinkPointYRandomNegativeProportion;

        for (NSInteger i = 0; i < percentagesLinkPointMArray.count; i++) {
            BOOL isLabelLinkLeft = [isLabelsLinkLeftMArray[i] boolValue];
            BOOL isLabelLinkTop = [isLabelsLinkTopMArray[i] boolValue];
//            CGFloat percentagesLinkPointAngle = [percentagesLinkPointAngleMArray[i] floatValue];
            CGPoint percentagesLinkPoint = [percentagesLinkPointMArray[i] CGPointValue];
            CGPoint labelLinkPoint = CGPointZero;
            CGRect labelFrame = CGRectZero;
            labelFrame.size = self.labelSize;
            CGPoint labelLinkOnePoint = CGPointZero;
            
            NSInteger labelLinkPointXRandom =
            [self randomLength:self.labelLinkPointXConstRandom
            withPositiveLength:self.labelLinkPointXPositiveRandom
            withNegativeLength:self.labelLinkPointXNegativeRandom];

            CGFloat labelLinkPointYPositiveConstRandom = 0;
            CGFloat labelLinkPointYPositiveNegativeRandom = 0;
            
            CGFloat labelLinkOnePointXRandom = 0;
            if (labelLinkPointXRandom > self.labelLinkPointXMax) {
                labelLinkOnePointXRandom =
                [self randomLength:self.labelLinkOnePointXConstRandom
                withPositiveLength:0
                withNegativeLength:self.labelLinkOnePointXPNRandom];
            }else{
                labelLinkOnePointXRandom =
                [self randomLength:self.labelLinkOnePointXConstRandom
                withPositiveLength:self.labelLinkOnePointXPNRandom
                withNegativeLength:0];
            }
            BOOL isOneLabel = NO;
            if (isLabelLinkLeft) {
                BOOL isCenterLabel = NO;
                if (isLabelLinkTop) {
                    NSInteger labelLeftTopIndex = [labelsLinkLeftTopCenterYArray indexOfObject:@(percentagesLinkPoint.y)];
                    if (!labelLeftTopIndex) {
                        isCenterLabel = YES;
                    }
                    if (labelsLinkLeftTopNumber == 1) {
                        isOneLabel = YES;
                    }
                    labelLinkPoint.y = edgeInsets.top + labelsLinkLeftTopLimitHeight * labelLeftTopIndex + labelsLinkLeftTopLimitHeightCenter;
                    
                    labelLinkPointYPositiveConstRandom = labelLinkPointLeftTopYConstRandom;
                    labelLinkPointYPositiveNegativeRandom = labelLinkPointLeftTopYNegativeRandom;
                }else{
                    NSInteger labelLeftBottomIndex = [labelsLinkLeftBottomCenterYArray indexOfObject:@(percentagesLinkPoint.y)];
                    if (labelLeftBottomIndex == labelsLinkLeftBottomCenterYArray.count - 1) {
                        isCenterLabel = YES;
                    }
                    if (labelsLinkLeftBottomNumber == 1) {
                        isOneLabel = YES;
                    }
                    labelLinkPoint.y = labelsLinkLeftBottomY + labelsLinkLeftBottomLimitHeight * labelLeftBottomIndex + labelsLinkLeftBottomLimitHeightCenter;
                    
                    labelLinkPointYPositiveConstRandom = labelLinkPointLeftBottomYConstRandom;
                    labelLinkPointYPositiveNegativeRandom = labelLinkPointLeftBottomYNegativeRandom;
                }
                
                if (isCenterLabel) {
                    [self calculateLabelLinkPointXRandomWithCenterX:center.x
                                          withPercentagesLinkPointX:percentagesLinkPoint.x
                                                         withIsLeft:isLabelLinkLeft
                                          withLabelLinkPointXRandom:&labelLinkPointXRandom];
                }
                labelLinkPoint.x = percentagesLinkPoint.x - labelLinkPointXRandom;
                if (labelLinkPoint.x < labelPointLeftSpacing) {
                    labelLinkPoint.x = labelPointLeftSpacing;
                }
                
                labelFrame.origin.x = labelLinkPoint.x - labelAndLinkPointSpacing - labelSize.width;

                labelLinkOnePoint.x = labelLinkPoint.x + labelLinkOnePointXRandom;
            }else{
                BOOL isCenterLabel = NO;
                if (isLabelLinkTop) {
                    NSInteger labelRightTopIndex = [labelsLinkRightTopCenterYArray indexOfObject:@(percentagesLinkPoint.y)];
                    if (!labelRightTopIndex) {
                        isCenterLabel = YES;
                    }
                    if (labelsLinkRightTopNumber == 1) {
                        isOneLabel = YES;
                    }
                    labelLinkPoint.y = edgeInsets.top + labelsLinkRightTopLimitHeight * labelRightTopIndex + labelsLinkRightTopLimitHeightCenter;
                    
                    labelLinkPointYPositiveConstRandom = labelLinkPointRightTopYConstRandom;
                    labelLinkPointYPositiveNegativeRandom = labelLinkPointRightTopYNegativeRandom;
                }else{
                    NSInteger labelRightBottomIndex = [labelsLinkRightBottomCenterYArray indexOfObject:@(percentagesLinkPoint.y)];
                    if (labelRightBottomIndex == labelsLinkRightBottomCenterYArray.count - 1) {
                        isCenterLabel = YES;
                    }
                    if (labelsLinkRightBottomNumber == 1) {
                        isOneLabel = YES;
                    }
                    labelLinkPoint.y = labelsLinkRightBottomY + labelsLinkRightBottomLimitHeight * labelRightBottomIndex + labelsLinkRightBottomLimitHeightCenter;
                    
                    labelLinkPointYPositiveConstRandom = labelLinkPointRightBottomYConstRandom;
                    labelLinkPointYPositiveNegativeRandom = labelLinkPointRightBottomYNegativeRandom;
                }
                
                if (isCenterLabel) {
                    [self calculateLabelLinkPointXRandomWithCenterX:center.x
                                          withPercentagesLinkPointX:percentagesLinkPoint.x
                                                         withIsLeft:isLabelLinkLeft
                                          withLabelLinkPointXRandom:&labelLinkPointXRandom];
                }
                labelLinkPoint.x = percentagesLinkPoint.x + labelLinkPointXRandom;
                if (labelLinkPoint.x > labelPointRightSpacing) {
                    labelLinkPoint.x = labelPointRightSpacing;
                }
                
                labelFrame.origin.x = labelLinkPoint.x + labelAndLinkPointSpacing;
                
                labelLinkOnePoint.x = labelLinkPoint.x - labelLinkOnePointXRandom;
            }
            CGFloat labelLinkPointYRandom =
            [self randomLength:labelLinkPointYPositiveConstRandom
            withPositiveLength:0
            withNegativeLength:labelLinkPointYPositiveNegativeRandom];
            if (isOneLabel) {
                CGFloat labelsLinkPointYRandomDiff = 0;
                if (isLabelLinkTop) {
                    labelsLinkPointYRandomDiff = percentagesLinkPoint.y - (labelLinkPoint.y - labelLinkPointYRandom);
                }else{
                    labelsLinkPointYRandomDiff = (labelLinkPoint.y + labelLinkPointYRandom) - percentagesLinkPoint.y;
                }
                if (labelsLinkPointYRandomDiff > self.labelLinkPointYMaxRandom) {
                    if (isLabelLinkTop) {
                        labelLinkPointYRandom = self.labelLinkPointYMaxRandom - (percentagesLinkPoint.y - labelLinkPoint.y);
                    }else{
                        labelLinkPointYRandom = self.labelLinkPointYMaxRandom - (labelLinkPoint.y - percentagesLinkPoint.y);
                    }
                }
            }
            if (isLabelLinkTop) {
                labelLinkPoint.y -= labelLinkPointYRandom;
                if (labelLinkPoint.y < labelPointTopSpacing) {
                    labelLinkPoint.y = labelPointTopSpacing;
                }
            }else{
                labelLinkPoint.y += labelLinkPointYRandom;
                if (labelLinkPoint.y > labelPointBottomSpacing) {
                    labelLinkPoint.y = labelPointBottomSpacing;
                }
            }
            
            labelFrame.origin.y = labelLinkPoint.y - labelTopSpacing;
            [labelsLinkPointMArray addObject:[NSValue valueWithCGPoint:labelLinkPoint]];
            [labelsFrameMArray addObject:[NSValue valueWithCGRect:labelFrame]];
            
            labelLinkOnePoint.y = labelLinkPoint.y;
            
            UIBezierPath *labelsLinkPath = [UIBezierPath bezierPath];
            [labelsLinkPath moveToPoint:percentagesLinkPoint];
            [labelsLinkPath addLineToPoint:labelLinkOnePoint];
            [labelsLinkPath addLineToPoint:labelLinkPoint];
            [labelsLinkPathMArray addObject:labelsLinkPath];
        }
        
        if (!drawPercentagesArcPath &&
            !drawPercentagesLinkPoint &&
            !drawLabelsLinkPoint &&
            !drawLabelsFrameArray &&
            !drawLabelsLinkPath) {
            [self drawPercentagesArcPath:nil
            withDrawPercentagesLinkPoint:nil
                 withDrawLabelsLinkPoint:nil
                     withDrawLabelsFrame:nil
                  withDrawLabelsLinkPath:nil];
        }
        drawPercentagesArcPath(percentagesArcPathMArray);
        drawPercentagesLinkPoint(percentagesLinkPointMArray);
        drawLabelsLinkPoint(labelsLinkPointMArray);
        drawLabelsFrameArray(labelsFrameMArray,
                             isLabelsLinkLeftMArray);
        drawLabelsLinkPath(labelsLinkPathMArray);
    }
}

-(void)drawPercentagesArcPath:(void (^ _Nullable)(NSArray * _Nonnull percentagesArcPathArray))drawPercentagesArcPathBlock
 withDrawPercentagesLinkPoint:(void (^ _Nullable)(NSArray * _Nonnull percentagesLinkPointArray))drawPercentagesLinkPointBlock
      withDrawLabelsLinkPoint:(void (^ _Nullable)(NSArray * _Nonnull labelsLinkPointArray))drawLabelsLinkPointBlock
          withDrawLabelsFrame:(void (^ _Nullable)(NSArray * _Nonnull labelsFrameArray,
                                                  NSArray * _Nonnull isLabelsLeftArray))drawLabelsFrameArrayBlock
       withDrawLabelsLinkPath:(void (^ _Nullable)(NSArray * _Nonnull labelsLinkPathArray))drawLabelsLinkPathBlock{
    
    if (drawPercentagesArcPathBlock) {
        drawPercentagesArcPath = drawPercentagesArcPathBlock;
    }else{
        __block KKCirStatisticalFigureView *weakSelf = self;
        drawPercentagesArcPath = ^(NSArray * _Nonnull percentagesArcPathArray){
            CGContextRef context = UIGraphicsGetCurrentContext();
            //绘制百分比弧度路径
            NSArray *percentageArcPathColorArray = weakSelf.percentageArcPathColorArray;
            NSInteger percentageArcPathColorArrayCount = percentageArcPathColorArray.count;
            NSInteger percentagesArcPathArrayCount = percentagesArcPathArray.count;
            for (NSInteger i = 0; i < percentagesArcPathArrayCount; i++) {
                UIColor *percentageArcPathColor = nil;
                if (i > percentageArcPathColorArrayCount - 1) {
                    CGFloat hue = 1.0f / (percentagesArcPathArrayCount - percentageArcPathColorArrayCount) *
                    (i - percentageArcPathColorArrayCount);
                    percentageArcPathColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
                }else{
                    percentageArcPathColor = percentageArcPathColorArray[i];
                }
                CGContextSetStrokeColorWithColor(context,
                                                 percentageArcPathColor.CGColor);
                UIBezierPath *percentageArcPath = percentagesArcPathArray[i];
                [percentageArcPath stroke];
            }
        };
    }
    
    if (drawLabelsLinkPathBlock) {
        drawLabelsLinkPath = drawLabelsLinkPathBlock;
    }else{
        __block KKCirStatisticalFigureView *weakSelf = self;
        drawLabelsLinkPath = ^(NSArray * _Nonnull labelsLinkPathArray){
            CGContextRef context = UIGraphicsGetCurrentContext();
            //标签和百分比圆环连接path
            CGFloat labelLinkPathThickness = weakSelf.labelLinkPathThickness;
            CGFloat lengths[] = {labelLinkPathThickness, labelLinkPathThickness};
            CGContextSetLineDash(context, 0, lengths, 2);
            CGContextSetStrokeColorWithColor(context, weakSelf.labelLinkPathColor.CGColor);
            for (UIBezierPath *labelsLinkPath in labelsLinkPathArray) {
                labelsLinkPath.lineWidth = labelLinkPathThickness;
                [labelsLinkPath stroke];
            }
            CGContextSetLineDash(context, 0, 0, 0);
        };
    }
    
    if (drawPercentagesLinkPointBlock) {
        drawPercentagesLinkPoint = drawPercentagesLinkPointBlock;
    }else{
        __block KKCirStatisticalFigureView *weakSelf = self;
        drawPercentagesLinkPoint = ^(NSArray * _Nonnull percentagesLinkPointArray){
            CGContextRef context = UIGraphicsGetCurrentContext();
            //标签和百分比圆环连接⭕️
            CGContextSetFillColorWithColor(context, weakSelf.percentagesLinkPointPathFillColor.CGColor);
            CGContextSetStrokeColorWithColor(context, weakSelf.percentagesLinkPointPathStrokeColor.CGColor);
            for (NSValue *percentagesLinkPointValue in percentagesLinkPointArray) {
                CGPoint percentagesLinkPoint = [percentagesLinkPointValue CGPointValue];
                UIBezierPath *percentagesLinkPointPath =
                [UIBezierPath bezierPathWithArcCenter:percentagesLinkPoint
                                               radius:weakSelf.percentagesLinkPointRadius
                                           startAngle:0
                                             endAngle:DOUBLE_PI
                                            clockwise:YES];
                percentagesLinkPointPath.lineWidth = weakSelf.percentagesLinkPointPathThickness;
                [percentagesLinkPointPath fill];
                [percentagesLinkPointPath stroke];
            }
        };
    }
    
    if (drawLabelsFrameArrayBlock) {
        drawLabelsFrameArray = drawLabelsFrameArrayBlock;
    }else{
        __block KKCirStatisticalFigureView *weakSelf = self;
        drawLabelsFrameArray = ^(NSArray * _Nonnull labelsFrameArray,
                                 NSArray * _Nonnull isLabelsLeftArray){
            CGContextRef context = UIGraphicsGetCurrentContext();
            //标签部分
            NSArray *labelsColorArray = weakSelf.labelsColorArray;
            NSInteger labelsColorArrayCount = labelsColorArray.count;
            NSInteger labelsFrameArrayCount = labelsFrameArray.count;
            for (NSInteger i = 0; i < labelsFrameArrayCount; i++) {
                UIColor *percentageArcPathColor = nil;
                if (i > labelsColorArrayCount - 1) {
                    CGFloat hue = 1.0f / (labelsFrameArrayCount - labelsColorArrayCount) *
                    (i - labelsColorArrayCount);
                    percentageArcPathColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
                }else{
                    percentageArcPathColor = labelsColorArray[i];
                }
                CGContextSetFillColorWithColor(context,
                                               percentageArcPathColor.CGColor);
                CGRect labelsFrame = [labelsFrameArray[i] CGRectValue];
                CGContextFillRect(context, labelsFrame);
            }
        };
    }
    
    if (drawLabelsLinkPointBlock) {
        drawLabelsLinkPoint = drawLabelsLinkPointBlock;
    }else{
        drawLabelsLinkPoint = ^(NSArray * _Nonnull labelsLinkPointArray){
            
        };
    }
}

#pragma mark - private

//获取适配屏幕过后的值
-(CGFloat)getProportionValue:(CGFloat)value isConsiderSmallSize:(BOOL)isConsiderSmallSize{
    if (isConsiderSmallSize) {
        if (isSmallSize) {
            return 0.845f * value;
        }
        return screenProportion * value;
    }else{
        return screenProportion * value;
    }
}

//适配屏幕
-(void)adapterScreen{
//    self.percentageRadius = [self getProportionValue:self.percentageRadius isConsiderSmallSize:NO];
//    self.percentageArcPathThickness = [self getProportionValue:self.percentageArcPathThickness isConsiderSmallSize:NO];
    self.percentagesLinkPointRadius = [self getProportionValue:self.percentagesLinkPointRadius isConsiderSmallSize:NO];
    self.percentagesLinkPointPathThickness = [self getProportionValue:self.percentagesLinkPointPathThickness isConsiderSmallSize:NO];
    self.labelLinkPathThickness = [self getProportionValue:self.labelLinkPathThickness isConsiderSmallSize:NO];
    self.labelLinkPointXConstRandom = [self getProportionValue:self.labelLinkPointXConstRandom isConsiderSmallSize:NO];
    self.labelLinkPointXPositiveRandom = [self getProportionValue:self.labelLinkPointXPositiveRandom isConsiderSmallSize:NO];
    self.labelLinkPointXNegativeRandom = [self getProportionValue:self.labelLinkPointXNegativeRandom isConsiderSmallSize:NO];
    self.labelLinkPointYMaxRandom = [self getProportionValue:self.labelLinkPointYMaxRandom isConsiderSmallSize:NO];
    self.labelAndLinkPointSpacing = [self getProportionValue:self.labelAndLinkPointSpacing isConsiderSmallSize:NO];
    
    CGSize labelSize = self.labelSize;
    labelSize.width = [self getProportionValue:labelSize.width isConsiderSmallSize:NO];
    labelSize.height = [self getProportionValue:labelSize.height isConsiderSmallSize:NO];
    self.labelSize = labelSize;
}

/**
 根据百分比计算结束角度
 percentage 最大进度
 progress 进度
 startAngle 开始角度
 totalAngle 总共角度 如果为0默认两倍PI
 isClockwise 是否顺时针
 */
-(CGFloat)accordingPercentageCalculateEndAngle:(CGFloat)percentage
                                  withProgress:(CGFloat)progress
                                withStartAngle:(CGFloat *)startAngle
                                withTotalAngle:(CGFloat)totalAngle
                               withisClockwise:(BOOL)isClockwise{
    CGFloat endAngle = 0;
    if (progress == percentage) {
        if (isClockwise) {
            endAngle = *startAngle - 0.0000001;
        }else{
            endAngle = 0.0000001;
        }
        return endAngle;
    }
    if (!totalAngle) {
        totalAngle = DOUBLE_PI;
    }
    if (isClockwise) {
        endAngle = *startAngle + progress * (totalAngle / percentage);
        if (endAngle > DOUBLE_PI) {
            endAngle = DOUBLE_PI;
        }
    }else{
        if (*startAngle <= 0.0) {
            *startAngle += DOUBLE_PI;
        }
        endAngle = *startAngle - progress * (totalAngle / percentage);
        if (endAngle < 0.0) {
            endAngle = 0;
        }
    }
    return endAngle;
}

/**
 随机生成函数 如果angle不是0，那么proportion最大360，否则最大100，
 isPN：是否正负判断
 */
#define ONE_ANGLE_PI 0.01745329251994329547437168059786927
-(CGFloat)randomAngle:(CGFloat)angle withProportion:(NSInteger)proportion withIsPN:(BOOL)isPN{
    CGFloat cAngle = 0;
    if (angle) {
        cAngle = arc4random() % proportion + 1;
        cAngle *= angle / 200.0f;
    }else{
        cAngle = arc4random() % proportion + 1;
        cAngle *= ONE_ANGLE_PI;
    }
    if (isPN) {
        BOOL isNegative = arc4random() % 2;
        cAngle = isNegative ? -cAngle : cAngle;
    }
    return cAngle;
}

//随机生成连接线的长度
-(NSInteger)randomLength:(NSInteger)length withPositiveLength:(NSInteger)positiveLength withNegativeLength:(NSInteger)negativeLength{
    NSInteger rLength = 0;
    BOOL isNegative = arc4random() % 2;
    if (!positiveLength) {
        positiveLength = 1;
        isNegative = YES;
    }
    if (!negativeLength) {
        negativeLength = 1;
        isNegative = NO;
    }
    if (isNegative) {
        rLength = arc4random() % negativeLength + 1;
        rLength = -rLength;
    }else{
        rLength = arc4random() % positiveLength + 1;
    }
    return length + rLength;
}

//计算靠近中间的lable的x轴坐标随机参数
-(void)calculateLabelLinkPointXRandomWithCenterX:(CGFloat)centerX
                       withPercentagesLinkPointX:(CGFloat)percentagesLinkPointX
                                      withIsLeft:(BOOL)isLeft
                       withLabelLinkPointXRandom:(NSInteger *)labelLinkPointXRandom{
    CGFloat labelsLinkPointCenterXDiff = 0;
    if (isLeft) {
        labelsLinkPointCenterXDiff = centerX - percentagesLinkPointX;
    }else{
        labelsLinkPointCenterXDiff = percentagesLinkPointX - centerX;
    }
    if (labelsLinkPointCenterXDiff < labelsLinkPointCenterXDiffMax) {
        *labelLinkPointXRandom = [self randomLength:labelsLinkPointCenterXConstRandom
                                withPositiveLength:labelsLinkPointCenterXPositiveRandom
                                withNegativeLength:0];
    }
}

@end
