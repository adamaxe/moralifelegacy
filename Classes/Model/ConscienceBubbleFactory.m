/**
 Implementation: Take an outer and dymamic CGPathRef, and populate them with the appropriate drawing instructions
 
 @class ConsciencePath ConsciencePath.h
 */

#import "ConscienceBubbleFactory.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@implementation ConscienceBubbleFactory

+ (CGMutablePathRef)bubbleSurfaceWithType:(int)bubbleType{
    
    BOOL isBubbleDefault = TRUE;
    
    CGMutablePathRef outerPath = CGPathCreateMutable();
    CGAffineTransform outerTransform = CGAffineTransformMakeTranslation(-5.0, -5.0);

	//Puffy
    if ((bubbleType == kBubbleTypePuffyNormal) || (bubbleType == kBubbleTypePuffyShort) || (bubbleType == kBubbleTypePuffyTall)){
        
        CGPathMoveToPoint(outerPath, &outerTransform, 97.3125,12.1875);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 89.771357,12.1875, 83.35237,15.375279, 80.6875,19.875);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 75.505195,19.4937, 68.893223,19.075666, 64.28125,20.8125);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 58.956976,22.902322, 54.920954,26.462455, 52.90625,30.3125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 47.598266,28.352374, 40.044649,31.078071, 34.5625,37.40625);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 29.933308,42.74984, 28.067426,49.189506, 29.21875,54.0625);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 26.05323,56.763967, 23.472444,61.125673, 22.375,66.375);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 21.648726,69.848934, 21.665959,73.214061, 22.28125,76.1875);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 16.528386,77.914815, 12.519551,85.571097, 13.0625,94.5);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 13.513785,101.92147, 16.972022,108.1024, 21.53125,110.5625);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 20.53593,113.90019, 20.388645,117.91119, 21.25,122.03125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 22.538496,128.19442, 25.818689,133.14113, 29.75,135.59375);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 27.058134,140.5685, 28.707679,148.42451, 34.1875,154.75);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 40.321416,161.83053, 49.043386,164.43242, 54.3125,160.96875);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 56.556272,164.3568, 60.418597,167.38974, 65.28125,169.1875);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 69.730007,171.00186, 78.697863,170.52167, 80.898811,169.98826);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 83.714269,174.25392, 90.581683,177.875, 97.875,177.875);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 104.88513,177.875, 111.21238,174.4891, 114.17345,170.48826);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 117.77587,171.01301, 125.84853,171.42995, 130.09375,169.9375);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 134.43326,168.33315, 137.95054,165.75466, 140.25,162.8125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 145.51443,166.33188, 154.28257,163.76104, 160.4375,156.65625);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 165.66263,150.62476, 167.40172,143.17895, 165.21875,138.1875);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 170.11282,136.44888, 174.47063,130.84657, 176,123.53125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 177.00363,118.73066, 176.59325,114.12006, 175.125,110.5);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 179.59263,107.97326, 182.99257,101.87949, 183.4375,94.5625);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 183.96833,85.832891, 180.14069,78.321096, 174.59375,76.375);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 175.17968,73.451197, 175.21049,70.148461, 174.5,66.75);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 173.28401,60.933628, 170.26727,56.20504, 166.625,53.625);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 167.51024,48.691307, 165.28033,42.360767, 160.34375,37.28125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 154.66226,31.435264, 147.20818,29.095684, 142.03125,31.0625);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 140.36259,26.647718, 135.95148,22.391786, 129.9375,20.03125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 124.73973,18.445934, 117.59822,18.085355, 113.5625,19.28125);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 110.69384,15.104417, 104.50728,12.1875, 97.3125,12.1875);
                
        isBubbleDefault = FALSE;
        
    }
    
	//Gear
    if ((bubbleType == kBubbleTypeGearNormal) || (bubbleType == kBubbleTypeGearShort) || (bubbleType == kBubbleTypeGearTall)){
        
        CGPathMoveToPoint(outerPath, &outerTransform, 83.247996,13.876715);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 67.229297,16.850686, 52.83941,24.409978, 41.463755,35.118096);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 44.258948,38.031719, 46.015358,41.971782, 46.035891,46.326179);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 45.139403,56.334024, 37.313439,62.478653, 29.715906,62.709665);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 27.236727,62.709665, 24.89852,62.143102, 22.7942,61.153869);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 18.03702,71.596043, 15.364479,83.194509, 15.364479,95.413137);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 15.364479,109.36933, 18.814834,122.51182, 24.921513,134.05404);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 26.434971,133.59041, 28.050573,133.35552, 29.715906,133.35552);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 38.697476,133.35552, 45.993539,140.63053, 46.035891,149.612);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 45.818185,152.60575, 45.079339,155.64556, 43.813325,157.86724);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 54.8489,167.49479, 68.450866,174.26572, 83.470252,177.01306);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 85.557204,170.40608, 91.699562,168.69432, 98.996463,168.69432);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 106.23393,168.69432, 112.38845,170.32432, 114.52267,176.85431);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 129.1277,174.02893, 142.36527,167.38833, 153.16357,158.026);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 151.70111,155.58046, 150.84575,152.73216, 150.84575,149.6755);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 150.84575,140.66389, 158.15413,133.35552, 167.16574,133.35552);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 168.9208,133.35552, 170.59779,133.63628, 172.18238,134.14929);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 178.32377,122.58276, 181.80292,109.4108, 181.80292,95.413137);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 181.06658,83.458778, 178.78606,71.253142, 174.69071,61.85239);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 173.04665,62.409282, 171.28398,62.709665, 169.4518,62.709665);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 160.44019,62.709665, 153.13182,55.401284, 153.13182,46.389681);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 153.13182,42.504333, 154.51595,38.968127, 156.78318,36.165877);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 145.4343,25.089926, 130.93752,17.217036, 114.74493,14.03547);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 112.85368,20.954323, 106.13417,22.608224, 98.615453,22.608224);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 91.040182,22.608224, 85.08601,20.875197, 83.247996,13.876715);    
                
        isBubbleDefault = FALSE;
        
    }
    
    //Diamond
    if ((bubbleType == kBubbleTypeDiamondNormal) || (bubbleType == kBubbleTypeDiamondShort) || (bubbleType == kBubbleTypeDiamondTall)){
        
        CGPathMoveToPoint(outerPath, &outerTransform, 98.700171,12.386015);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 154.41884,31.662947, 166.74852,55.522583, 180.76773,95.494499);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 165.06839,146.09107, 142.48341,169.42908, 99.664129,178.46063);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 52.115249,169.37448, 31.363491,144.96334, 15.739283,96.399165);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 29.69846,54.31971, 39.388679,33.302043, 98.700171,12.386015);
                
        isBubbleDefault = FALSE;
        
    }
    
    //Star
    if ((bubbleType == kBubbleTypeStarNormal) || (bubbleType == kBubbleTypeStarShort) || (bubbleType == kBubbleTypeStarTall)){
    
        CGPathMoveToPoint(outerPath, &outerTransform, 188.17655,112.9759);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 179.20301,120.68764, 172.08713,128.05859, 167.46332,137.38865);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 162.83952,146.71869, 157.32453,156.07137, 157.39672,166.797);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 146.62076,166.20671, 134.40839,169.77805, 124.86911,173.95315);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 115.32984,178.12827, 106.18933,181.10566, 99.222461,188.24147);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 90.895244,181.3089, 79.696193,175.74846, 69.704976,172.81504);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 59.713758,169.88164, 51.275448,166.74877, 40.874165,167.2752);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 38.841324,157.10987, 36.31956,145.94477, 30.551409,137.27541);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 24.783257,128.60605, 19.388105,121.30048, 9.6536351,113.70853);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 15.976736,105.06692, 20.939181,93.100528, 22.093076,82.751718);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 23.24697,72.402907, 23.183605,62.390843, 20.169308,52.605913);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 30.997161,48.479306, 39.681203,41.670349, 48.287726,34.756228);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 54.692079,27.356798, 63.469472,21.143888, 67.500784,12.557938);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 78.507162,15.802531, 89.477004,16.722815, 100.51429,16.958459);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 110.17658,16.593325, 120.62987,16.228191, 129.50115,12.303498);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 132.37199,20.348886, 143.57699,30.721459, 151.96238,36.895167);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 160.34776,43.068873, 168.3651,50.499046, 177.15972,51.961645);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 174.65911,63.416342, 176.1036,75.1184, 178.5588,85.237758);    
        CGPathAddCurveToPoint(outerPath, &outerTransform, 181.01399,95.357116, 182.20208,105.31187, 188.17655,112.9759);    
                
        isBubbleDefault = FALSE;

    }    
    
    if (((bubbleType == kBubbleTypeRoundNormal) || (bubbleType == kBubbleTypeRoundShort) || (bubbleType == kBubbleTypeRoundTall)) ||isBubbleDefault){
        CGPathMoveToPoint(outerPath, &outerTransform, 130.59967,171.05272);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 101.14148,183.84373, 64.547682,177.22538, 41.566855,154.80468);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 18.279603,133.23266, 9.7828123,97.692812, 20.651667,67.934483);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 31.161917,37.089231, 61.554893,14.346881, 94.241502,13.12482);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 126.26539,11.054474, 158.25507,29.735571, 172.29013,58.469917);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 177.96222,69.720795, 181.07794,81.087624, 181.05328,94.471925);
        CGPathAddCurveToPoint(outerPath, &outerTransform, 181.43745,127.60968, 160.58597,158.80135, 130.59967,171.05272);
                
    }
    
    CGPathCloseSubpath(outerPath);
    return (CGMutablePathRef)[(NSObject*)outerPath autorelease];

    
}

+ (CGMutablePathRef)bubbleAccentWithType:(int)bubbleType {
    
    BOOL isBubbleDefault = TRUE;
    
    CGMutablePathRef dynamicPath = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-5.0, -5.0);

	//Puffy
    if ((bubbleType == kBubbleTypePuffyNormal) || (bubbleType == kBubbleTypePuffyShort) || (bubbleType == kBubbleTypePuffyTall)){
                
        CGPathMoveToPoint(dynamicPath, &transform, 49.772043,85.807275);
        CGPathAddCurveToPoint(dynamicPath, &transform, 44.954268,85.143469, 43.480141,68.330355, 49.394172,57.474822);
        CGPathAddCurveToPoint(dynamicPath, &transform, 55.308203,46.619289, 68.970977,41.877699, 70.957647,45.735991);
        CGPathAddCurveToPoint(dynamicPath, &transform, 72.918557,49.544257, 63.088385,51.738518, 56.96062,62.685543);
        CGPathAddCurveToPoint(dynamicPath, &transform, 50.832854,73.632568, 56.463678,86.729267, 49.772043,85.807275);
        
        isBubbleDefault = FALSE;
        
    }
    
	//Gear
    if ((bubbleType == kBubbleTypeGearNormal) || (bubbleType == kBubbleTypeGearShort) || (bubbleType == kBubbleTypeGearTall)){
                
        CGPathMoveToPoint(dynamicPath, &transform, 54.035547,122.8622);
        CGPathAddCurveToPoint(dynamicPath, &transform, 48.841308,116.70674, 41.713064,115.2702, 35.51987,115.00433);
        CGPathAddCurveToPoint(dynamicPath, &transform, 30.618016,101.76511, 32.830083,92.020372, 35.897741,86.585233);
        CGPathAddCurveToPoint(dynamicPath, &transform, 42.824699,86.802806, 48.5728,84.585024, 52.524063,81.516711);
        CGPathAddCurveToPoint(dynamicPath, &transform, 45.41401,95.298541, 47.655185,109.08037, 54.035547,122.8622);
        
        isBubbleDefault = FALSE;
        
    }    
    
    //Diamond
    if ((bubbleType == kBubbleTypeDiamondNormal) || (bubbleType == kBubbleTypeDiamondShort) || (bubbleType == kBubbleTypeDiamondTall)){
                
        CGPathMoveToPoint(dynamicPath, &transform, 77.131517, 41.164534);
        CGPathAddCurveToPoint(dynamicPath, &transform, 58.402992,47.037226, 42.916954,59.396467, 39.298579,82.104262);
        CGPathAddCurveToPoint(dynamicPath, &transform, 48.422285,67.803822, 56.942545,53.390236, 77.131517,41.164534);
        
        isBubbleDefault = FALSE;
        
    }
    
    //Star
    if ((bubbleType == kBubbleTypeStarNormal) || (bubbleType == kBubbleTypeStarShort) || (bubbleType == kBubbleTypeStarTall)){

        CGPathMoveToPoint(dynamicPath, &transform, 42.321547,94.196133);
        CGPathAddCurveToPoint(dynamicPath, &transform, 44.885925,82.169095, 45.585874,70.142057, 41.943676,61.32136);
        CGPathAddCurveToPoint(dynamicPath, &transform, 49.126566,60.601033, 58.718364,54.298673, 66.505288,46.584392);
        CGPathAddCurveToPoint(dynamicPath, &transform, 66.505288,46.584392, 56.032857,65.298225, 48.551394,65.298225);
        CGPathAddCurveToPoint(dynamicPath, &transform, 53.093711,71.443712, 42.321547,94.196133, 42.321547,94.196133);
        
        isBubbleDefault = FALSE;
    }

    
    if (((bubbleType == kBubbleTypeRoundNormal) || (bubbleType == kBubbleTypeRoundShort) || (bubbleType == kBubbleTypeRoundTall)) || isBubbleDefault){
        
        CGPathMoveToPoint(dynamicPath, &transform, 100.56817, 30.166705);
        CGPathAddCurveToPoint(dynamicPath, &transform, 66.791491, 37.335987, 36.124184, 69.452376, 33.144898, 112.51362);
        CGPathAddCurveToPoint(dynamicPath, &transform, 25.42531, 72.733457,  64.4555, 27.727181, 100.56817, 30.166705);
        
    }
    
    CGPathCloseSubpath(dynamicPath);
    return (CGMutablePathRef)[(NSObject*)dynamicPath autorelease];    
    
}

@end
