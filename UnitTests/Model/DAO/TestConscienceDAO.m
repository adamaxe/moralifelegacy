#import "ModelManager.h"
#import "ConscienceAsset.h"
#import "ConscienceAssetDAO.h"

@interface TestConscienceDAO: SenTestCase {
    ModelManager *testModelManager;

    ConscienceAssetDAO *testingSubject;
    
    ConscienceAsset *testConscienceAsset1;
    ConscienceAsset *testConscienceAsset2;
    ConscienceAsset *testConscienceAsset3;
    
    NSNumber *costAsset;
    NSString *orientationAsset;
    NSNumber *moralValueAsset;    
}

@end

@implementation TestConscienceDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    

    costAsset = [[NSNumber alloc]initWithFloat:1.0];
    moralValueAsset = [[NSNumber alloc]initWithFloat:2.0];    
    
    testConscienceAsset1 = [testModelManager create:ConscienceAsset.class];
    testConscienceAsset2 = [testModelManager create:ConscienceAsset.class];
    testConscienceAsset3 = [testModelManager create:ConscienceAsset.class];

    testConscienceAsset1.costAsset = costAsset;
    testConscienceAsset1.orientationAsset = orientationAsset;
    testConscienceAsset1.moralValueAsset = moralValueAsset;

    testConscienceAsset2.costAsset = costAsset;
    testConscienceAsset2.orientationAsset = orientationAsset;
    testConscienceAsset2.moralValueAsset = moralValueAsset;

    testConscienceAsset3.costAsset = costAsset;
    testConscienceAsset3.orientationAsset = orientationAsset;
    testConscienceAsset3.moralValueAsset = moralValueAsset;


    [testModelManager saveContext];
    
}

@end