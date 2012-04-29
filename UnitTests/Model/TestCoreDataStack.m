#import <CoreData/CoreData.h>
#import "TestCoreDataStack.h"

@implementation TestCoreDataStack

@synthesize managedObjectContext = _managedObjectContext;

- (id)init {
    self = [super init];
    if (self) {
        
        
        NSURL *modelURL = [[NSBundle bundleForClass:TestCoreDataStack.class] URLForResource:@"SystemData" withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL] autorelease];

        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel] autorelease];
        [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];

        self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return self;
}

- (id)insert: (Class) testClass {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(testClass) inManagedObjectContext:self.managedObjectContext];
}

- (void)save {
    NSError *error;
    
    @try {
        [self.managedObjectContext save: &error];
    }
    @catch (NSException *exception) {
        
        @throw([[[NSException alloc] initWithName: @"AssertionFailed" reason: [NSString stringWithFormat: @"ManagedObjectContext save failed %@", error] userInfo: nil] autorelease]);

    }    
    
//    [self.managedObjectContext save: &error];
//    if (error) {
//        @throw([[[NSException alloc] initWithName: @"AssertionFailed" reason: [NSString stringWithFormat: @"ManagedObjectContext save failed %@", error] userInfo: nil] autorelease]);
//    }
}

- (void)delete: (id) object {
    [self.managedObjectContext deleteObject: object];
}

- (NSArray *)fetch: (Class) testClass {
    NSError *error;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(testClass)];

    NSArray *results;
    
    @try {
        results = [self.managedObjectContext executeFetchRequest: fetch error: &error];
    }
    @catch (NSException *exception) {
        @throw([[[NSException alloc] initWithName: @"AssertionFailed" reason: [NSString stringWithFormat: @"ManagedObjectContext fetch failed %@", error] userInfo: nil] autorelease]);

    }    
//    NSArray *results = [self.managedObjectContext executeFetchRequest: fetch error: &error];
//    if (error) {
//        @throw([[[NSException alloc] initWithName: @"AssertionFailed" reason: [NSString stringWithFormat: @"ManagedObjectContext fetch failed %@", error] userInfo: nil] autorelease]);
//    }    
    return results;
}

- (void)dealloc {
    
    [super dealloc];
}
@end