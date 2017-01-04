//
//  Person.h
//  RealmDemo
//
//  Created by ray on 2016/12/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Realm/Realm.h>
#import "Car.h"

@interface Person : RLMObject
    
@property NSString *ID;
@property NSString *name;
@property int age;
@property float height;
    
@property RLMArray<Car> *cars;

- (instancetype)initWithID:(NSString *)ID;
    
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Person>
RLM_ARRAY_TYPE(Person)
