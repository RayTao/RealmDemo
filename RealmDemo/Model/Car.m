//
//  Car.m
//  RealmDemo
//
//  Created by ray on 2016/12/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "Car.h"
#import "Person.h"

@implementation Car

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

    
+ (NSDictionary *)linkingObjectsProperties {
    /*.cars链接了一个 Car实例，而这个实例的对一关系属性 Car.owner又链接到了对应的这个 Person实例，那么实际上这些链接仍然是互相独立的。*/

    return @{
             @"owners": [RLMPropertyDescriptor descriptorWithClass:Person.class propertyName:@"cars"],
             };
}
    
@end
