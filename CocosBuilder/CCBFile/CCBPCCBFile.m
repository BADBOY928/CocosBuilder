/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCBPCCBFile.h"
#import "ResourceManager.h"
#import "CCBReaderInternal.h"
#import "CCBGlobals.h"
#import "CCBDocument.h"
#import "CocosBuilderAppDelegate.h"

@implementation CCBPCCBFile

@synthesize ccbFile;

- (void) setCcbFile:(CCNode *)cf
{
    ccbFile = cf;
    
    [self removeAllChildrenWithCleanup:YES];
    if (cf)
    {
        [self addChild:cf];
    }
    /*
    [ccbFile release];
    ccbFile = [cf retain];
    
    CCBGlobals* g = [CCBGlobals globals];
    CocosBuilderAppDelegate* ad = [g appDelegate];
    
    [self removeAllChildrenWithCleanup:YES];
    
    // Get absolut file path to ccb file
    NSString* filePath = [[ResourceManager sharedManager] toAbsolutePath:cf];
    
    // Check that it's not the current document (or we get an inifnite loop)
    if ([ad.currentDocument.fileName isEqualToString:filePath]) return;
    
    // Load document dictionary
    NSMutableDictionary* doc = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    // Verify doc type and version
    if (![[doc objectForKey:@"fileType"] isEqualToString:@"CocosBuilder"]) return;
    if ([[doc objectForKey:@"fileVersion"] intValue] != kCCBFileFormatVersion) return;
    
    // Parse the node graph
    CCNode* nodeGraph = [CCBReaderInternal nodeGraphFromDictionary:[doc objectForKey:@"nodeGraph"]];
    
    // Add the node graph as a child
    [self addChild:nodeGraph];*/
}

@end