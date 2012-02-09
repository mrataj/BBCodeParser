//
//  BBCodeParserTests.m
//  BBCodeParserTests
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
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

+ (NSArray *)getTags
{
    static NSArray *tags;
    if (tags == nil)
    {
        tags = [[NSArray alloc] initWithObjects:@"bold", @"quote", @"user", nil];
    }
    return tags;
}

- (void)testExamples
{
    NSString *code = @"This[d] is [bold]test[/bold] message. [quote user=\"23\" name=\"David Cole\"]Person [user]Johnny Newille[/user] created this.[/quote]. See you soon.";
    
    NSArray *tags = [BBCodeParserTests getTags];
    BBCodeParser *parser = [[BBCodeParser alloc] initWithTags:tags];
    [parser setCode:code];
    [parser parse];
    
    NSString *elementText = parser.element.text;
    
    STAssertNotNil(parser.element, @"Elements cannot be nil!");
    STAssertTrue([parser.element.elements count] == 2, @"There must be 2 elements");
    
    BBElement *quoteElement = [parser.element.elements objectAtIndex:1];
    STAssertTrue([quoteElement.attributes count] == 2, @"There must be two attributes.");
    
    [parser release];
}

@end
