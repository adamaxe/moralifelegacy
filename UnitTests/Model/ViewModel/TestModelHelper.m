/**
 Testing helper to create NSManagedObjects.
 */

#import "TestModelHelper.h"
#import "ModelManager.h"
#import "ConscienceAsset.h"
#import "ReferencePerson.h"
#import "ReferenceAsset.h"
#import "UserCollectable.h"
#import "Dilemma.h"
#import "Character.h"
#import "Moral.h"

@implementation TestModelHelper


+ (Character *)createCharacterWithName:(NSString *)characterName withModelManager:(ModelManager *)modelManager{

    Character *testCharacter = [modelManager create:Character.class];

    testCharacter.accessoryPrimaryCharacter = @"accessoryPrimary";
    testCharacter.accessorySecondaryCharacter = @"accessorySecondary";
    testCharacter.accessoryTopCharacter = @"accessoryTop";
    testCharacter.accessoryBottomCharacter = @"accessoryBottom";
    testCharacter.faceCharacter = @"face";
    testCharacter.nameCharacter = characterName;
    testCharacter.eyeCharacter = @"eye";
    testCharacter.mouthCharacter = @"mouth";
    testCharacter.ageCharacter = @1.0f;
    testCharacter.eyeColor = @"eyeColor";
    testCharacter.browColor = @"browColor";
    testCharacter.bubbleColor = @"bubbleColor";
    testCharacter.sizeCharacter = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    testCharacter.bubbleType = @1.0f;
    [modelManager saveContext];

    return testCharacter;
}

+ (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName withModelManager:(ModelManager *)modelManager{

    Dilemma *testDilemma = [modelManager create:Dilemma.class];

    testDilemma.rewardADilemma = @"dilemma";
    testDilemma.choiceB = @"choiceB";
    testDilemma.moodDilemma  = @1.0f;
    testDilemma.displayNameDilemma = @"displayName";
    testDilemma.surrounding = @"surrounding";
    testDilemma.nameDilemma = dilemmaName;
    testDilemma.rewardBDilemma = @"reward";
    testDilemma.choiceA = @"choice";
    testDilemma.enthusiasmDilemma = @1.0f;
    testDilemma.dilemmaText = @"text";

    [modelManager saveContext];

    return testDilemma;
}

+ (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager{

    NSString *imageNameGenerated = [NSString stringWithFormat:@"%@imageName", moralName];

    Moral *testMoral1 = [modelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageNameGenerated;
    testMoral1.colorMoral = @"FF0000";
    testMoral1.displayNameMoral = @"displayName";
    testMoral1.longDescriptionMoral = @"longDescription";
    testMoral1.component = @"component";
    testMoral1.linkMoral = @"link";
    testMoral1.definitionMoral = @"definition";

    [modelManager saveContext];

    return testMoral1;
}

+ (ReferencePerson *)createPersonWithName:(NSString *)personName withModelManager:(ModelManager *)modelManager{

    ReferencePerson *testPersonLocal1 = [modelManager create:ReferencePerson.class];

    testPersonLocal1.nameReference = personName;

    testPersonLocal1.imageNameReference = @"imageNamePerson";
    testPersonLocal1.displayNameReference = @"displayNamePerson";
    testPersonLocal1.longDescriptionReference = @"longDescriptionPerson";
    testPersonLocal1.originYear = @2012;
    testPersonLocal1.linkReference = @"linkPerson";
    testPersonLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionPerson", personName];

    [modelManager saveContext];

    return testPersonLocal1;
}

+ (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager{

    ConscienceAsset *testAssetLocal1 = [modelManager create:ConscienceAsset.class];

    testAssetLocal1.nameReference = assetName;

    testAssetLocal1.costAsset = @20;
    testAssetLocal1.imageNameReference = @"imageNameAsset";
    testAssetLocal1.displayNameReference = @"displayNameAsset";
    testAssetLocal1.longDescriptionReference = @"longDescriptionAsset";
    testAssetLocal1.originYear = @2011;
    testAssetLocal1.linkReference = @"linkAsset";
    testAssetLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionAsset", assetName];

    [modelManager saveContext];

    return testAssetLocal1;
}

@end

