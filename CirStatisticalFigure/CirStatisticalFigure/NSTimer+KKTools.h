//
//  NSTimer+KKTools.h
//  HomeOfMJ
//
//  Created by yons on 15/11/9.
//  Copyright © 2015年 kukela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (KKTools)

//用block执行scheduledTimerWithTimeIntervalf方法
+(NSTimer *)kkScheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
