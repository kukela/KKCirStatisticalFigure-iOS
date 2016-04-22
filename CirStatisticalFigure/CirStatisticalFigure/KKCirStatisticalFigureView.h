//
//  KKCirStatisticalFigureView.h
//  HaoCheZhu
//
//  Created by kukela on 16/4/15.
//  Copyright © 2016年 kukela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKCirStatisticalFigureView : UIView
//是否适配屏幕大小按照5s的屏幕计算
@property(nonatomic, assign)BOOL isAdapter;
//百分比数组，已经集成setNeedsDisplay，不需要手动刷新
@property(nonatomic, strong)NSArray * _Nonnull percentageArray;
//开始角度
@property(nonatomic, assign)CGFloat startAngle;
//是否顺时针
@property(nonatomic, assign)BOOL isClockwise;

//百分比圆环的半径
@property(nonatomic, assign)CGFloat percentageRadius;
@property(nonatomic, assign)CGFloat percentageAndThicknessRadius;
//百分比圆环的厚度
@property(nonatomic, assign)CGFloat percentageArcPathThickness;
//百分比圆环的颜色数组
@property(nonatomic, strong)NSArray * _Nullable percentageArcPathColorArray;

//标签连接百分比圆环⭕️path的半径
@property(nonatomic, assign)CGFloat percentagesLinkPointRadius;
//标签连接百分比圆环的⭕️path的厚度
@property(nonatomic, assign)CGFloat percentagesLinkPointPathThickness;
//标签连接百分比圆环的⭕️path的Fill颜色
@property(nonatomic, strong)UIColor * _Nullable percentagesLinkPointPathFillColor;
//标签连接百分比圆环的⭕️path的Stroke颜色
@property(nonatomic, strong)UIColor * _Nullable percentagesLinkPointPathStrokeColor;

//标签连接百分比圆环path的厚度
@property(nonatomic, assign)CGFloat labelLinkPathThickness;
//标签连接百分比圆环path的颜色
@property(nonatomic, strong)UIColor * _Nullable labelLinkPathColor;

//标签的size和间距
@property(nonatomic, assign)CGFloat labelAndLinkPointSpacing;
@property(nonatomic, assign)CGSize labelSize;
//标签的颜色数组
@property(nonatomic, strong)NSArray * _Nullable labelsColorArray;

//标签连接百分比圆环的y轴超出圆环最大距离百分比，默认0.5
@property(nonatomic, assign)CGFloat labelLinkYLimitSpacingPercentage;
//标签x,y轴随机部分
@property(nonatomic, assign)CGFloat labelLinkPointXConstRandom;
@property(nonatomic, assign)CGFloat labelLinkPointXPositiveRandom;
@property(nonatomic, assign)CGFloat labelLinkPointXNegativeRandom;
@property(nonatomic, assign)CGFloat labelLinkPointYMaxRandom;
//标签位置的最大边框
@property(nonatomic, assign)UIEdgeInsets edgeInsets;
//标签和百分比连接path中间point随机参数
@property(nonatomic, assign)CGFloat labelLinkOnePointXConstRandom;
@property(nonatomic, assign)CGFloat labelLinkOnePointXPNRandom;
//当labelLinkPointX超过一定值，labelLinkOnePointX变短，否则相反
@property(nonatomic, assign)CGFloat labelLinkPointXMax;

/**
 percentagesArcPathArray : 百分比弧度路径数组
 percentagesLinkPointArray : 在百分比弧度上链接标签的点数组
 labelsLinkPointArray : 标签的链接点数组
 labelsFrameArray : 标签的frame数组
 isLabelsLeftArray : 标签的是否左边数组
 labelsLinkPathArray : 标签的链接路径数组
*/
-(void)drawPercentagesArcPath:(void (^ _Nullable)(NSArray * _Nonnull percentagesArcPathArray))drawPercentagesArcPathBlock
 withDrawPercentagesLinkPoint:(void (^ _Nullable)(NSArray * _Nonnull percentagesLinkPointArray))drawPercentagesLinkPointBlock
      withDrawLabelsLinkPoint:(void (^ _Nullable)(NSArray * _Nonnull labelsLinkPointArray))drawLabelsLinkPointBlock
          withDrawLabelsFrame:(void (^ _Nullable)(NSArray * _Nonnull labelsFrameArray,
                                                  NSArray * _Nonnull isLabelsLeftArray))drawLabelsFrameArrayBlock
       withDrawLabelsLinkPath:(void (^ _Nullable)(NSArray * _Nonnull labelsLinkPathArray))drawLabelsLinkPathBlock;

@end
