/**
Implementation: Conscience Mind Collection.  Object to be populated state of emotion for Conscience.
Data derived from User's actions
 
@todo VERSION 2.0 implement CD interaction in setter/getter, see ConscienceAction, ChoiceView and Dilemma
@class ConscienceMind ConscienceMind.h
 */

#import "ConscienceMind.h"

float const MLConscienceEnthusiasmDefault = 50.0;
float const MLConscienceMoodDefault = 55.0;

int const MLExpressionInterval = 3;
float const MLBlinkInterval = 2;

@interface ConscienceMind () {
	NSTimer *mouthTimer;		/**< controls expression interval */
	NSTimer *eyeTimer;          /**< controls eye state interval */
	NSTimer *blinkTimer;		/**< controls blink/wink interval */

    NSArray *browExpressions;
    NSArray *lidExpressions;
    NSArray *lipsExpressions;
    NSArray *tongueExpressions;
    NSArray *teethExpressions;
    NSArray *dimplesExpressions;

}

@end

@implementation ConscienceMind

- (id)init {
    self = [super init];
    if (self) {
        //In case of first time run, or User does not supply configuration, default gradient        
        [self setEnthusiasm:MLConscienceEnthusiasmDefault];
        [self setMood:MLConscienceMoodDefault];
		_enthusiasmMemories = [[NSMutableDictionary alloc] init];
		_moodMemories = [[NSMutableDictionary alloc] init];

        lipsExpressions = @[@"layerLipsSadShock", @"layerLipsSadOpenAlt1", @"layerLipsSadOpen", @"layerLipsSadAlt1", @"layerLipsSad", @"layerLipsSadSmirk", @"layerLipsSadSilly", @"layerLipsNormalSad", @"layerLipsNormal", @"layerLipsNormalHappy", @"layerLipsHappySmirk", @"layerLipsHappy", @"layerLipsHappySilly", @"layerLipsHappyAlt1", @"layerLipsHappyOpen", @"layerLipsHappyOpenAlt1", @"layerLipsHappyShock"];
        dimplesExpressions = @[@"layerDimplesSad", @"layerDimplesNormal", @"layerDimplesHappy"];
        teethExpressions = @[@"layerTeethSadOpenAlt1", @"layerTeethSadOpen", @"layerTeethNormal", @"layerTeethHappyOpen", @"layerTeethHappyOpenAlt1"];
        tongueExpressions = @[@"layerTongueSadCenter", @"layerTongueSadLeft", @"layerTongueSadRight", @"layerTongueNormal", @"layerTongueHappyCenter", @"layerTongueHappyLeft", @"layerTongueHappyRight"];
        browExpressions = @[@"layerBrowNormal",@"layerBrowAngry", @"layerBrowConfused", @"layerBrowExcited"];
        lidExpressions = @[@"layerLidNormal", @"layerLidAngry", @"layerLidSquint", @"layerLidSleepy", @"layerLidUnder"];
        _isExpressionForced = FALSE;

        [self setTimers];
    }

    return self;
}

/**
Implemenation:  Determine prior state of mind for mood.  Retrieve top of Dictionary
@todo VERSION 2.0 implement
 */
- (CGFloat) priorMood{
	/*
	NSArray *myKeys = [myDictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	//get object for first (sorted) key:
	id firstObject = [moodMemories objectForKey: [sortedKeys objectAtIndex:0]];

	//get object for last (sorted) key:
	id lastObject = [enthusiasmMemories objectForKey: [sortedKeys lastObject];

	[return [(NSNumber*)lastObject floatValue]];
	*/
	
	return 0;

}

/**
Implemenation:  Determine prior state of mind for enthusiasm.  Retrieve top of Dictionary
@todo VERSION 2.0 implement
 */
- (CGFloat) priorEnthusiasm{
	/*
	NSArray *myKeys = [myDictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	//get object for first (sorted) key:
	id firstObject = [enthusiasmMemoryDictionary objectForKey: [sortedKeys objectAtIndex:0]];

	//get object for last (sorted) key:
	id lastObject = [enthusiasmMemoryDictionary objectForKey: [sortedKeys lastObject]];

	[return [(NSNumber*)lastObject floatValue]];
	*/
	return 0;
}

#pragma mark -
#pragma mark Timed Changes

/**
 Implementation: Determine if Conscience is awake.  Set timers to change eye and lip expresssions.
 */
- (void) setTimers{

    //Put Conscience to sleep if enthusiasm is 0
    if (self.enthusiasm > 0) {

        //Restart Conscience movement after User has moved it
        [self timedEyeChanges];
        [self timedMouthExpressionChanges];

        if(![mouthTimer isValid]){
            mouthTimer = [NSTimer scheduledTimerWithTimeInterval:MLExpressionInterval target:self selector:@selector(timedMouthExpressionChanges) userInfo:nil repeats:YES];
        }
        if(![eyeTimer isValid]){
            eyeTimer = [NSTimer scheduledTimerWithTimeInterval:MLBlinkInterval target:self selector:@selector(timedEyeChanges) userInfo:nil repeats:YES];
        }

    } else {
        [self.delegate changeEyeState:MLEyeStateClose forEye:MLEyePlacementBoth];
    }

}

/**
 Implementation: Cancel timers handling mouth/eye expressions and any transient blinks.
 */
- (void) stopTimers {

    if(mouthTimer != nil){

        [mouthTimer invalidate];
        mouthTimer = nil;
    }

    if(blinkTimer != nil){

        [blinkTimer invalidate];
        blinkTimer = nil;
    }

    if(eyeTimer != nil){

        [eyeTimer invalidate];
        eyeTimer = nil;
    }

}

/**
 Implementation: Determine which mouth expression to enable along with teeth, dimple and tongue selection
 */
- (void) timedMouthExpressionChanges{

    CGFloat conscienceMood = self.mood;
    CGFloat conscienceEnthusiasm = self.enthusiasm;

    int randomIndex = 16 * (conscienceMood/100);


    if (conscienceEnthusiasm > 50) {
        randomIndex += 1;
    } else {
        randomIndex -= 1;
    }

    randomIndex += arc4random() %2;

    if (randomIndex > 16) {
        randomIndex = 16;
    }

    if (randomIndex < 0) {
        randomIndex = 0;
    }

	int randomSwitch = arc4random() % 2;
	int randomTongueHappy = 3 + arc4random() % 3;
	int randomTongueSad = arc4random() % 3;
	int dimpleIndex = 1;
	int teethIndex = 2;
	int tongueIndex = 3;

	if ((randomSwitch < 1) || _isExpressionForced) {

		[self.delegate changeLipsExpressions:lipsExpressions[randomIndex]];
	}

	_isExpressionForced = FALSE;

	if(randomSwitch < 1){

        switch(randomIndex){
			case 0:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;
			case 1:dimpleIndex = 0;teethIndex = 0;tongueIndex = 3;break;
			case 2:dimpleIndex = 0;teethIndex = 1;tongueIndex = 3;break;
			case 3:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;
			case 4:dimpleIndex = 0;teethIndex = 2;tongueIndex = randomTongueSad;break;
			case 5:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;
			case 6:dimpleIndex = 0;teethIndex = 2;tongueIndex = randomTongueSad;break;
			case 7:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 8:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 9:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 10:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;
			case 11:dimpleIndex = 2;teethIndex = 2;tongueIndex = randomTongueHappy;break;
			case 12:dimpleIndex = 2;teethIndex = 2;tongueIndex = randomTongueHappy;break;
            case 13:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;
			case 14:dimpleIndex = 2;teethIndex = 3;tongueIndex = 3;break;
			case 15:dimpleIndex = 2;teethIndex = 4;tongueIndex = 3;break;
            case 16:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;
			default:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;

        }

	}else{
		dimpleIndex = 1;
		teethIndex = 2;
		tongueIndex = 3;

	}

	[self.delegate changeDimplesExpressions:dimplesExpressions[dimpleIndex]];

    if (conscienceEnthusiasm > 40) {

        [self.delegate changeTeethExpressions:teethExpressions[teethIndex]];
        [self.delegate changeTongueExpressions:tongueExpressions[tongueIndex]];

    }

}

- (void) timedEyeChanges{

	//Randomize blinks
	int randomSwitch = arc4random() % 3;
	//Random direction
	//5 removes cross-eyed and crazy
	int randomDirection = arc4random() % 6;

	//Generate int between 0 - 240;
	int randomInterval = arc4random() %100;
	//Generate random float range between 0.1 and
	float blinkDuration = 0.1 + (float)randomInterval/100;

    CGFloat conscienceEnthusiasm = self.enthusiasm;
    CGFloat conscienceMood = self.mood;

	if(conscienceMood < 0) {

		if(randomSwitch == 0) {
			randomDirection = 5;
		} else if (randomSwitch ==1) {
			randomDirection = 6;
		}
	}

	//Create Invocation in order to re-open eyes after random interval
	// get an Objective-C selector variable for the method
	SEL eyeTimerSelector = @selector(reopenEyes);

	// create a signature from the selector
	NSMethodSignature *eyeTimerSignature = [[self class] instanceMethodSignatureForSelector:eyeTimerSelector];

	NSInvocation *eyeTimerInvocation = [NSInvocation invocationWithMethodSignature:eyeTimerSignature];
	[eyeTimerInvocation setTarget:self];
	[eyeTimerInvocation setSelector:eyeTimerSelector];

    int eyeNumber = MLEyePlacementBoth;

	if (randomSwitch < 2)  {
		[self.delegate changeEyeState:MLEyeStateClose forEye:eyeNumber];
		blinkTimer = [NSTimer scheduledTimerWithTimeInterval:blinkDuration invocation:eyeTimerInvocation repeats:NO];
	}

    /** @todo lessen confused frequency */
    eyeNumber = MLEyePlacementBoth;

    if ((randomSwitch < 1) || _isExpressionForced){
        int randomBrow = 0;

        if (conscienceEnthusiasm > 60) {
            if (conscienceMood > 50) {
                randomBrow = 3;
            }else {
                randomBrow = 1;
            }

        } else {
            randomBrow = 2;
            eyeNumber = MLEyePlacementRandom;
        }

		[self.delegate changeBrowExpressions:browExpressions[randomBrow] forEye:eyeNumber];

	} else {
        [self.delegate changeBrowExpressions:browExpressions[0] forEye:eyeNumber];

    }

    eyeNumber = MLEyePlacementBoth;

	if ((randomSwitch == 2) || _isExpressionForced) {

        int randomLid = 0;

        if (conscienceEnthusiasm > 70) {

            if ((arc4random() %3) > 1) {
                randomLid = 4;
            } else {

                if (conscienceMood <= 15) {
                    randomLid = 2;
                }
            }

        } else if (conscienceEnthusiasm > 30) {

            if (conscienceMood > 50) {
                randomLid = 0;
            }else {
                randomLid = 1;
            }

        } else {
            randomLid = 3;
        }

        if (randomLid > 2) {

            if ((arc4random() %3) > 2) {

                eyeNumber = MLEyePlacementRandom;
            }

		}

		[self.delegate changeLidExpressions:lidExpressions[randomLid] forEye:eyeNumber];

	} else {
        [self.delegate changeLidExpressions:lidExpressions[0] forEye:eyeNumber];
        
    }
    
	_isExpressionForced = FALSE;
	[self.delegate changeEyeDirection:randomDirection forEye:MLEyePlacementBoth];
	
}

-(void)reopenEyes {

    [self.delegate changeEyeState:MLEyeStateOpen forEye:MLEyePlacementBoth];
}

-(void)dealloc {
    [self stopTimers];
}

@end