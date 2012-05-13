#import <CoreData/CoreData.h>
#import "TestCoreDataStack.h"

@implementation TestCoreDataStack {
    NSString *objectModelName;  /**< filename of managedObjectModel */
}

@synthesize managedObjectContext = _managedObjectContext;

- (id)init {
    self = [super init];
    if (self) {
        
        if (objectModelName == nil) {
            objectModelName = @"SystemData";
        }
        
        NSURL *modelURL = [[NSBundle bundleForClass:TestCoreDataStack.class] URLForResource:objectModelName withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL] autorelease];

        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel] autorelease];
        [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];

        self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return self;
}

- (id)initWithManagedObjectModel: (NSString *) managedObjectModelName {
    
    objectModelName = managedObjectModelName;
    
    return [self init];

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
        
    @try {
        [self.managedObjectContext deleteObject: object];
        [self save];
    }
    @catch (NSException *exception) {
        @throw(exception); 
    }    
    
}

- (NSArray *)fetch: (Class) testClass {
    NSError *error = nil;
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

#include <stdio.h>
// Prototype declarations
FILE *fopen$UNIX2003( const char *filename, const char *mode );
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d );

FILE *fopen$UNIX2003( const char *filename, const char *mode ) {
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d ) {
    return fwrite(a, b, c, d);
}