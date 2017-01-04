//
//  RLMObject+MJExtension.h
//  WeimiSP
//
//  Created by ray on 16/4/26.
//  Copyright © 2016年 XKJH. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMObject (MJExtension)

/**
 *  RLMObject的property无法使用kvc
 *
 *  @return @[@"realm",@"objectSchema",@"invalidated"]
 */
+ (NSMutableArray *)mj_totalIgnoredPropertyNames;


@end
