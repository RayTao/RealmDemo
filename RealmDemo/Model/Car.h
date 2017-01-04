//
//  Car.h
//  RealmDemo
//
//  Created by ray on 2016/12/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Realm/Realm.h>

@class Person;
@interface Car : RLMObject
@property NSString *carName;
//@property (readonly) Person *owner;
@property (readonly) RLMLinkingObjects *owners;

    
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Car>
RLM_ARRAY_TYPE(Car)
