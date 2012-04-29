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
    
    NSError *error = nil;
    
    @try {
        [self.managedObjectContext save: &error];
    }
    @catch (NSException *exception) {
        @throw(exception); 
    }    
    
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Test Core Data save failed: %@\n\n", [error description]];
        [NSException raise:@"CoreDataSaveError" format:errorMessage];
    }

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
        @throw(exception);
    }    
    
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Test Core Data fetch failed: %@\n\n", [error description]];
        [NSException raise:@"CoreDataFetchError" format:errorMessage];
    }
    
    return results;
}

- (void)dealloc {
    
    [super dealloc];
}
@end