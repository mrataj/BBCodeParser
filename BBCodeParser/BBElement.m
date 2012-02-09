//
//  BBElement.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBElement.h"

@implementation BBElement

@synthesize tag=_tag, format=_format, attributes=_attributes, elements=_elements, parent=_parent;

- (id)init
{
    self = [super init];
    if (self)
    {
        _tag = [[NSString alloc] init];
        _format = [[NSString alloc] init];
        _attributes = [[NSArray alloc] init];
        _elements = [[NSArray alloc] init];
        _parent = nil;
    }
    
    return self;
}

- (NSString *)text
{
    NSMutableString *format = [[NSMutableString alloc] initWithString:_format];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\{[0-9]+\\})"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    [regex replaceMatchesInString:format options:0 range:NSMakeRange(0, [_format length]) withTemplate:@""];
    
    return [format autorelease];
}

- (BBAttribute *)attributeWithName:(NSString *)name
{
    for (BBAttribute *attribute in _attributes)
        if ([attribute.name isEqualToString:name])
            return attribute;
    
    return nil;
}

- (void)setElements:(NSArray *)elements
{
    if (elements == _elements)
        return;
    
    [_elements release];
    _elements = [elements retain];
    
    for (BBElement *subelement in _elements)
        [subelement setParent:self];
}

- (void)dealloc
{
    [_tag release];
    [_format release];
    [_attributes release];
    [_elements release];
    _parent = nil;
    [super dealloc];
}

@end
