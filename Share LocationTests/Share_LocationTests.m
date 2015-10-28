#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface Share_LocationTests : XCTestCase

@end

@implementation Share_LocationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTAssertEqualObjects(@"dupa", @"/search?q=%24%26%3F%40");
    NSMutableArray *mockArray = mock([NSMutableArray class]);
    
    // using mock object
    [mockArray addObject:@"one"];
    [mockArray removeAllObjects];
    
    // verification
    [verify(mockArray) addObject:@"one"];
    [verify(mockArray) removeAllObjects];
}

@end
