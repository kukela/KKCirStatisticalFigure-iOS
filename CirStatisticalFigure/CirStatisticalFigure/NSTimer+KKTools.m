//
//  NSTimer+KKTools.m
//  HomeOfMJ
//
//  Created by yons on 15/11/9.
//  Copyright © 2015年 kukela. All rights reserved.
//

#import "NSTimer+KKTools.h"

@implementation NSTimer (KKTools)

+(NSTimer *)kkScheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(kkBlackInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+(void)kkBlackInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
