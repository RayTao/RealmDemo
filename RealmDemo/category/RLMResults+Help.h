//
//  RLMResults+Help.h
//  RealmDemo
//
//  Created by ray on 2016/12/30.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMResults (Help)
@property (nonatomic, readonly) NSUInteger realCount;

- (NSArray *)rt_toArray;
- (NSArray *)rt_arrayOfRange:(NSRange )range;



@end
