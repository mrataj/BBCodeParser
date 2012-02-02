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
    NSString *code = @"[user id=\"42\"]Kate Cameron[/user] has writen a hundred miles long exam about supermassive black holes, saved it to file [document id=\"89\" name=\"title\"]Seminar paper.pdf[/document] and finally sent it to her professor of physics [user id=\"75\"]dr. Gregory Watson[/user].";
    
    BBCodeParser *parser = [[BBCodeParser alloc] initWithString:code];
    
    STAssertNotNil(parser.elements, @"Elements cannot be nil!");
    STAssertTrue([parser.elements count] == 3, @"There must be 3 elements");
    for (BBElement *element in parser.elements)
    {
        NSInteger elementIndex = [parser.elements indexOfObject:element];
        if (elementIndex == 0)
        {
            STAssertTrue([element.tag isEqualToString:@"user"], @"First element's tag is not valid.");
            BBAttribute *attribute = [element attributeWithName:@"id"];
            STAssertNotNil(attribute, @"Attribute 'id' wasn't found.");
        }
        else if (elementIndex == 1)
        {
            STAssertTrue([element.tag isEqualToString:@"document"], @"Second element's tag is not valid.");
            BBAttribute *attribute1 = [element attributeWithName:@"id"];
            STAssertNotNil(attribute1, @"Attribute 'id' wasn't found.");
            BBAttribute *attribute2 = [element attributeWithName:@"name"];
            STAssertNotNil(attribute2, @"Attribute 'name' wasn't found.");
        }
        else
        {
            STAssertTrue([element.tag isEqualToString:@"user"], @"Third element's tag is not valid.");
            BBAttribute *attribute = [element attributeWithName:@"id"];
            STAssertNotNil(attribute, @"Attribute 'id' wasn't found.");          
        }
    }
    
    [parser release];
}

@end
