//
//  BBCodeParserTests.m
//  BBCodeParserTests
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBCodeParserTests.h"
#import "BBCodeParser.h"

@implementation BBCodeParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExamples
{
    NSString *code = @"This is [bold]test[/bold] message. [quote]Person [user]Johnny Newille[/user] created this.[/quote]. See you soon.";
    
    BBCodeParser *parser = [[BBCodeParser alloc] initWithCode:code];
    [parser parse];
    
    STAssertNotNil(parser.element, @"Elements cannot be nil!");
    STAssertTrue([parser.element.elements count] == 2, @"There must be 2 elements");
    
    [parser release];
}

@end
