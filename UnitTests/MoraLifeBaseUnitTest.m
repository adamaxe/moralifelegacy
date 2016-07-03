@interface MoraLifeBaseUnitTest : XCTestCase

@end

@implementation MoraLifeBaseUnitTest

//Needed to avoid problems in setting up gcovr
//Project -> Instrument Program Flow : YES
//Project -> Generate Test Coverage Files : YES
#include <stdio.h>
FILE *fopen$UNIX2003( const char *filename, const char *mode );
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d );

FILE *fopen$UNIX2003( const char *filename, const char *mode ) {
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d ) {
    return fwrite(a, b, c, d);
}

@end
