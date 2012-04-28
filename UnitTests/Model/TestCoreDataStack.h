@class NSManagedObjectContext;

@interface TestCoreDataStack : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)insert: (Class) testClass;
- (void)save;
- (void)delete: (id) object;
- (NSArray *)fetch: (Class) testClass;

@end