/**
 Testing helper to create NSManagedObjects.
 
 @class TestModelHelper
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/28/2013
 @file
 */

@class Character, ConscienceAsset, Dilemma, ModelManager, Moral, ReferenceAsset, ReferenceBelief, ReferencePerson, ReferenceText, UserChoice, UserCollectable, UserDilemma;

@interface TestModelHelper : NSObject

+ (Character *)createCharacterWithName:(NSString *)characterName withModelManager:(ModelManager *)modelManager;
+ (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager;
+ (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName withModelManager:(ModelManager *)modelManager;
+ (Moral *)readMoralWithName:(NSString *)moralName fromModelManager:(ModelManager *)modelManager;
+ (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager;
+ (ReferenceAsset *)createReferenceAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager;
+ (ReferenceBelief *)createBeliefWithName:(NSString *)beliefName withModelManager:(ModelManager *)modelManager;
+ (ReferencePerson *)createPersonWithName:(NSString *)personName withModelManager:(ModelManager *)modelManager;
+ (ReferenceText *)createTextWithName:(NSString *)textName withModelManager:(ModelManager *)modelManager;
+ (UserCollectable *)createUserCollectableWithName:(NSString *)userCollectableName withModelManager:(ModelManager *)modelManager;
+ (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andWeight:(CGFloat)weight withModelManager:(ModelManager *)modelManager;
+ (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andSeverity:(CGFloat) severity andShortDescription:(NSString *) moralChoiceShort andLongDescription:(NSString *) moralChoiceLong andWeight:(CGFloat)weight withModelManager:(ModelManager *)modelManager;
+ (UserDilemma *)createUserDilemmaWithName:(NSString *)userDilemmaName withModelManager:(ModelManager *)modelManager;

@end

