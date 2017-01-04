//
//  RLMResults+Help.m
//  RealmDemo
//
//  Created by ray on 2016/12/30.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "RLMResults+Help.h"

@implementation RLMResults (Help)

- (NSUInteger)realCount {
    return self.count > 0 ? self.count : 0;
}

- (NSArray *)rt_toArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (RLMObject *object in self) {
        [array addObject:object];
    }
    return array;
}

- (NSArray *)rt_arrayOfRange:(NSRange )range {
    if (self.firstObject == nil || range.location > self.count) {
        NSLog(@"wrong range:%@ of count %ld",NSStringFromRange(range),(unsigned long)self.count);
        return @[];
    } else {
        if (range.location + range.length > self.count) range.length = self.count - range.location;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
        for (NSUInteger i = range.location; i < range.location + range.length; i++) {
            RLMObject *object = self[i];
            [array addObject:object];
        }
        return array;
    }
    
}

@end
