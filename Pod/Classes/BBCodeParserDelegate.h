//
//  BBCodeParserDelegate.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2.2.12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBCodeParser;
@class BBElement;

@protocol BBCodeParserDelegate <NSObject>

@optional
- (void)parser:(BBCodeParser *)parser didStartElementTag:(NSString *)tag attributes:(NSArray *)attributes;
- (void)parser:(BBCodeParser *)parser didEndElement:(BBElement *)element;
- (void)parser:(BBCodeParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(BBCodeParser *)parser didStartParsingCode:(NSString *)code;
- (void)parser:(BBCodeParser *)parser didFinishParsingCode:(NSString *)code;

@end