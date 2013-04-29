/**
 Testing helper to create NSManagedObjects.
 */

#import "TestModelHelper.h"
#import "ModelManager.h"
#import "ConscienceAsset.h"
#import "ReferenceAsset.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"
#import "UserCollectable.h"
#import "Dilemma.h"
#import "Character.h"
#import "Moral.h"
#import "UserChoice.h"
#import "UserDilemma.h"

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

+ (Moral *)readMoralWithName:(NSString *)moralName fromModelManager:(ModelManager *)modelManager{
    return [modelManager read:Moral.class withKey:@"nameMoral" andValue:moralName];
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

+ (ReferenceBelief *)createBeliefWithName:(NSString *)beliefName withModelManager:(ModelManager *)modelManager {

    ReferenceBelief *testBeliefLocal1 = [modelManager create:ReferenceBelief.class];
    testBeliefLocal1.typeBelief = @"typeBelief";
    testBeliefLocal1.shortDescriptionReference = @"short description";
    testBeliefLocal1.originYear = @2010;
    testBeliefLocal1.nameReference = beliefName;
    testBeliefLocal1.longDescriptionReference = @"long description";
    testBeliefLocal1.linkReference = @"http://www.teamaxe.org";
    testBeliefLocal1.displayNameReference = @"display name";
    testBeliefLocal1.imageNameReference = @"image name";

    return testBeliefLocal1;
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

+ (ReferenceText *)createTextWithName:(NSString *)textName withModelManager:(ModelManager *)modelManager {

    ReferenceText *testTextLocal1 = [modelManager create:ReferenceText.class];
    testTextLocal1.shortDescriptionReference = @"short description";
    testTextLocal1.originYear = @2010;
    testTextLocal1.nameReference = textName;
    testTextLocal1.longDescriptionReference = @"long description";
    testTextLocal1.linkReference = @"http://www.teamaxe.org";
    testTextLocal1.displayNameReference = @"display name";
    testTextLocal1.imageNameReference = @"image name";

    return testTextLocal1;
}

+ (ReferenceAsset *)createReferenceAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager {
    ReferenceAsset *testAssetLocal1 = [modelManager create:ReferenceAsset.class];

    testAssetLocal1.nameReference = assetName;

    testAssetLocal1.imageNameReference = @"imageNameAsset";
    testAssetLocal1.displayNameReference = @"displayNameAsset";
    testAssetLocal1.longDescriptionReference = @"longDescriptionAsset";
    testAssetLocal1.originYear = @2011;
    testAssetLocal1.linkReference = @"http://`linkAsset";
    testAssetLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionAsset", assetName];

    [modelManager saveContext];

    return testAssetLocal1;
}


+ (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager{

    ConscienceAsset *testAssetLocal1 = [modelManager create:ConscienceAsset.class];

    testAssetLocal1.nameReference = assetName;

    testAssetLocal1.costAsset = @20;
    testAssetLocal1.moralValueAsset = @2.0f;
    testAssetLocal1.orientationAsset = @"left";
    testAssetLocal1.imageNameReference = @"imageNameAsset";
    testAssetLocal1.displayNameReference = @"displayNameAsset";
    testAssetLocal1.longDescriptionReference = @"longDescriptionAsset";
    testAssetLocal1.originYear = @2011;
    testAssetLocal1.linkReference = @"http://`linkAsset";
    testAssetLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionAsset", assetName];

    [modelManager saveContext];

    return testAssetLocal1;
}

+ (UserCollectable *)createUserCollectableWithName:(NSString *)userCollectableName withModelManager:(ModelManager *)modelManager{

    UserCollectable *testUserCollectableLocal1 = [modelManager create:UserCollectable.class];

    testUserCollectableLocal1.collectableName = userCollectableName;
    testUserCollectableLocal1.collectableKey = userCollectableName;
    testUserCollectableLocal1.collectableCreationDate = [NSDate date];

    [modelManager saveContext];

    return testUserCollectableLocal1;
}

+ (UserDilemma *)createUserDilemmaWithName:(NSString *)userDilemmaName withModelManager:(ModelManager *)modelManager{

    UserDilemma *testUserDilemmaLocal1 = [modelManager create:UserDilemma.class];

    testUserDilemmaLocal1.entryKey = userDilemmaName;
    testUserDilemmaLocal1.entryShortDescription = @"entryShortDescription";
    testUserDilemmaLocal1.entryIsGood = @1;
    testUserDilemmaLocal1.entryLongDescription = @"entryLongDescription";
    testUserDilemmaLocal1.entrySeverity = @5.0f;
    testUserDilemmaLocal1.entryCreationDate = [NSDate date];

    [modelManager saveContext];

    return testUserDilemmaLocal1;
}

+ (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andSeverity:(CGFloat) severity andShortDescription:(NSString *) moralChoiceShort andLongDescription:(NSString *) moralChoiceLong withModelManager:(ModelManager *)modelManager{

    UserChoice *testChoice1 = [modelManager create:UserChoice.class];

    testChoice1.entryShortDescription = moralChoiceShort;
    testChoice1.entryLongDescription = moralChoiceLong;
    testChoice1.choiceMoral = moral.nameMoral;
    testChoice1.entryCreationDate = [NSDate date];
    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
    testChoice1.entryIsGood = ([moral.shortDescriptionMoral isEqualToString:@"Virtue"]) ? @1 : @0;
    testChoice1.choiceWeight = @(severity * 2);
    testChoice1.entryModificationDate = [NSDate date];
    testChoice1.entrySeverity = @(severity);

    [modelManager saveContext];

    return testChoice1;
    
}

@end

