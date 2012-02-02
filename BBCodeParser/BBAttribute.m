//
//  BBAttribute.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBAttribute.h"

static NSString *__equalSign = @"=";

@implementation BBAttribute

@synthesize name=_name, value=_value;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (BBAttribute *)attributeFromString:(NSString *)attributeString
{
    return [[[BBAttribute alloc] initWithString:attributeString] autorelease];
}

- (id)initWithString:(NSString *)attributeString
{
    self = [self init];
    if (self)
    {
        NSInteger equalCharacterIndex = [attributeString rangeOfString:__equalSign].location;
        if (equalCharacterIndex < 0 || equalCharacterIndex > [attributeString length])
            @throw [NSException exceptionWithName:@"Invalid attribute!" reason:@"Attribute must have one equal sign (=) included." userInfo:nil];
        
        NSArray *components = [attributeString componentsSeparatedByString:__equalSign];
        if ([components count] != 2)
            @throw [NSException exceptionWithName:@"Invalid attribute!" reason:@"Attribute must have only one equal sign (=) included." userInfo:nil];
        
        NSString *name = [components objectAtIndex:0];       
        _name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // TODO: Remove quotes.
        NSString *value = [components objectAtIndex:1];
        _value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self;
}

- (void)dealloc
{
    [_name release];
    [_value release];
    [super dealloc];
}

@end
