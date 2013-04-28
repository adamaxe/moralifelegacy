/**
 Testing helper to create NSManagedObjects.
 
 @class TestModelHelper
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/28/2013
 @file
 */

@class Character, ConscienceAsset, Dilemma, ModelManager, Moral, ReferencePerson;

@interface TestModelHelper : NSObject

+ (Character *)createCharacterWithName:(NSString *)characterName withModelManager:(ModelManager *)modelManager;
+ (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName withModelManager:(ModelManager *)modelManager;
+ (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager;
+ (ReferencePerson *)createPersonWithName:(NSString *)personName withModelManager:(ModelManager *)modelManager;
+ (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager;

@end

