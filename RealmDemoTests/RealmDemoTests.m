//
//  RealmDemoTests.m
//  RealmDemoTests
//
//  Created by ray on 2016/12/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Realm/Realm.h>
#import "Person.h"
#import "RLMRealm+Help.h"
#import "RLMResults+Help.h"

@interface BaseTestCase : XCTestCase
@property (nonatomic, readonly) RLMRealm *realm;
@property (nonatomic, assign) NSTimeInterval waitTime;

@end

@implementation BaseTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (NSTimeInterval)waitTime { return 10.0; }

- (RLMRealm *)realm {
//    NSString *writeLabel = @"com.realmWrite.serialQueue";
//    dispatch_queue_t serialQueue = dispatch_queue_create(writeLabel, DISPATCH_QUEUE_SERIAL);
//    
    return [RLMRealm defaultRealm];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end


@interface RealmDemoTests : BaseTestCase
@property (nonatomic, strong) RLMNotificationToken *token;

@end

@implementation RealmDemoTests

//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAAAACreatDataBase
{
//    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [docPath objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:databaseName];
//    NSLog(@"数据库目录 = %@",filePath);
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.deleteRealmIfMigrationNeeded = true;
    //    config.fileURL = [NSURL URLWithString:filePath];
    //objectClasses这个属性是用来控制对哪个类能够存储在指定 Realm 数据库中做出限制
    //    config.objectClasses = @[Person.class];
    //readOnly是控制是否只读属性
    config.readOnly = NO;
    int currentVersion = 1.0;
    config.schemaVersion = currentVersion;
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    XCTAssertNotNil(self.realm.configuration.fileURL);
}

- (void)testAdd {
    Car *car = [[Car alloc] init];
    car.carName = @"Lamborghini";
    XCTAssertNoThrow([self.realm transactionWithBlock:^{
        [self.realm addObject:car];
    }], @"car没有设置必须值，不会报异常");
    
    Person *person = [[Person alloc] init];
    person.ID = @"1";
    person.name = @"hood";
    [self.realm transactionWithBlock:^{
        [self.realm addOrUpdateObject:person];
    }];
}

- (void)testWriteAction {
    //add
    Person *person = [[Person alloc] init];
    person.ID = @"2";
    NSString *name = @"⤵️";
    person.name = name;
    
    [self.realm transactionWithBlock:^{
        [self.realm addOrUpdateObject:person];
    }];
    XCTAssertTrue([[Person allObjects] indexOfObject:person] != NSNotFound);
    ;
    XCTestExpectation *expectation = [self expectationWithDescription:@"多线程读写Realm"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0),^(){
        Person *person2 = [Person objectForPrimaryKey:@"2"];
        XCTAssertThrows([person.name isEqualToString:person2.name], @"多线程读写Realm object会报异常");
        XCTAssertTrue([person2.name isEqualToString:name]);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
 
}

- (void)testDelete {
    Car *car1 = [[Car alloc] init];
    car1.carName = @"Lamborghini";
    XCTAssertNoThrow([self.realm transactionWithBlock:^{
        [self.realm addObject:car1];
    }], @"car没有设置必须值，不会报异常");
    
    //delete
    XCTestExpectation *expectation = [self expectationWithDescription:@"多线程读写Realm"];
    RLMRealm * (^realm)(void);
    realm = ^(void){
        return [RLMRealm defaultRealm];
    };
    [RLMRealm writeWithBlock:^{
        // 删除单条记录
        [realm() deleteObject:[Car allObjects].firstObject];
        // 删除多条记录
        [realm() deleteObjects:[Car allObjects]];
        // 删除所有记录
        [realm() deleteAllObjects];
        XCTAssertTrue([Car allObjects].realCount == 0);
        
        [expectation fulfill];
    } inRealm:realm];
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
    
    RLMResults *CarResult = [Car allObjects];
    Car *car = CarResult.firstObject;
    XCTAssertTrue(CarResult.realCount == 0 && car == nil);

}

- (void)testUpdate {
    //        addOrUpdateObject会去先查找有没有传入的Car相同的主键，如果有，就更新该条数据。这里需要注意，addOrUpdateObject这个方法不是增量更新，所有的值都必须有，如果有哪几个值是null，那么就会覆盖原来已经有的值，这样就会出现数据丢失的问题。
    //
    Person *person = [[Person alloc] initWithID:@"233"];
    person.name = @"277";
    [self.realm transactionWithBlock:^{
        [self.realm addOrUpdateObject:person];
    }];
    XCTAssertTrue([[Person objectForPrimaryKey:@"233"].ID isEqualToString:@"233"] && [Person objectForPrimaryKey:@"233"].age == 0);
    //        createOrUpdateInRealm：withValue：这个方法是增量更新的，后面传一个字典，使用这个方法的前提是有主键。方法会先去主键里面找有没有字典里面传入的主键的记录，如果有，就只更新字典里面的子集。如果没有，就新建一条记录。
    [self.realm transactionWithBlock:^{
        [Person createOrUpdateInRealm:self.realm withValue:@{@"ID" : @"233", @"age" : @(10)}];
    }];
    XCTAssertTrue([[Person objectForPrimaryKey:@"233"].ID isEqualToString:@"233"] && [Person objectForPrimaryKey:@"233"].age == 10);

}

- (void)testDefaultProperty {
    //defaultProperty将在初始化后被赋值
    Person *person = [[Person alloc] init];
    XCTAssert([person.ID isEqualToString:@"0"]);
    person = [[Person alloc] initWithID:@"1"];
    XCTAssert([person.ID isEqualToString:@"1"]);
    
    Car *car = [[Car alloc] init];
    XCTAssertNil(car.carName);
}

- (void)testInitObject {
    // (1) 创建一个Car对象，然后设置其属性
    Car *car = [[Car alloc] init];
    car.carName = @"Lamborghini";
    
    // (2) 通过字典创建Car对象
    Car *myOtherCar = [[Car alloc] initWithValue:@{@"carName" : @"Rolls-Royce"}];
    XCTAssertTrue([myOtherCar.carName isEqualToString:@"Rolls-Royce"]);
    // (3) 通过数组创建狗狗对象
    Car *myThirdcar = [[Car alloc] initWithValue:@[@"BMW"]];
    XCTAssertTrue([myThirdcar.carName isEqualToString:@"BMW"]);

}

- (void)testNotification {
    [self testAdd];
    Person *person = [[Person allObjects] firstObject];
    NSLog(@"person.cars.count: %zu", person.cars.count); // => 0
    XCTAssertTrue(person.cars.count == 0);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Realm Notification"];
    __weak typeof(person) weakPerson = person;
    self.token = [person.cars addNotificationBlock:^(RLMArray * _Nullable cars, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
        
        // Only fired once for the example
        NSLog(@"dogs.count: %zu", cars.count); // => 1
        XCTAssertTrue(weakPerson.cars.count > 0);
        XCTAssertTrue([weakPerson.name isEqualToString:@"jjjjkkkk"]);
        [expectation fulfill];
    }];
    [self.realm transactionWithBlock:^{
        person.name = @"jjjjkkkk";

        Car *dog = [[Car alloc] init];
        dog.carName = @"Rex";
        [person.cars addObject:dog];
    }];
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//把这个测试Z开头放到最后
- (void)testZZZRequiredProperty {
    //所有的必需属性都必须在对象添加到 Realm 前被赋值
    
    Person *person = [[Person alloc] init];
    person.ID = @"1";
    person.age = 10;
    XCTAssertThrows([self.realm transactionWithBlock:^{
        [self.realm addObject:person];
    }], @"Person设置必须值name，会报异常");
    
    XCTAssertTrue(self.realm.inWriteTransaction, @"报异常之后realm无法再继续写入");
}

@end
