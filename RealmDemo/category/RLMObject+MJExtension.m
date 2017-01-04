//
//  RLMObject+MJExtension.m
//  WeimiSP
//
//  Created by ray on 16/4/26.
//  Copyright © 2016年 XKJH. All rights reserved.
//

#import "RLMObject+MJExtension.h"

@implementation RLMObject (MJExtension)

+ (NSMutableArray *)mj_totalIgnoredPropertyNames
{
    return @[@"realm",@"objectSchema",@"invalidated"].mutableCopy;
}

@end
