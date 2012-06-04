//
//  SequencerScrubberSelectionView.m
//  CocosBuilder
//
//  Created by Viktor Lidholt on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SequencerScrubberSelectionView.h"
#import "SequencerHandler.h"
#import "SequencerSequence.h"

@implementation SequencerScrubberSelectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return NULL;
    
    imgScrubHandle = [[NSImage imageNamed:@"seq-scrub-handle.png"] retain];
    imgScrubLine = [[NSImage imageNamed:@"seq-scrub-line.png"] retain];
    
    return self;
}

- (int) yMousePosToRow:(float)y
{
    NSOutlineView* outlineView = [SequencerHandler sharedHandler].outlineHierarchy;
    
    NSPoint convPoint = [outlineView convertPoint:NSMakePoint(0, y) fromView:self];
    
    int row = [outlineView rowAtPoint:convPoint];
    if (row == -1)
    {
        row = [outlineView numberOfRows] - 1;
    }
    
    return row;
}

- (void)drawRect:(NSRect)dirtyRect
{
    SequencerSequence* seq = [SequencerHandler sharedHandler].currentSequence;
    
    // Draw selection
    if (mouseState == kCCBSeqMouseStateSelecting
        && xStartSelectTime != xEndSelectTime)
    {
        // Determine min/max values for the selection
        float xMinTime = 0;
        float xMaxTime = 0;
        if (xStartSelectTime < xEndSelectTime)
        {
            xMinTime = xStartSelectTime;
            xMaxTime = xEndSelectTime;
        }
        else
        {
            xMinTime = xEndSelectTime;
            xMaxTime = xStartSelectTime;
        }
        
        int yMinRow = 0;
        int yMaxRow = 0;
        if (yStartSelectRow < yEndSelectRow)
        {
            yMinRow = yStartSelectRow;
            yMaxRow = yEndSelectRow;
        }
        else
        {
            yMinRow = yEndSelectRow;
            yMaxRow = yStartSelectRow;
        }
        
        // Calc x/width
        float x = [seq timeToPosition:xMinTime];
        float w = [seq timeToPosition:xMaxTime] - x;
        
        // Calc y/height
        NSOutlineView* outline = [SequencerHandler sharedHandler].outlineHierarchy;
        NSRect yStartRect = [self convertRect:[outline rectOfRow:yMinRow] fromView:outline]; 
        NSRect yEndRect = [self convertRect:[outline rectOfRow:yMaxRow] fromView:outline];
        
        float y = yEndRect.origin.y;
        float h = (yStartRect.origin.y + yStartRect.size.height) - y;
        
        // Draw the selection rectangle
        NSRect rect = NSMakeRect(x, y+1, w+1, h-1);
        
        [[NSColor colorWithDeviceRed:0.83f green:0.88f blue:1.00f alpha:0.50f] set];
        [NSBezierPath fillRect: rect];
        
        [[NSColor colorWithDeviceRed:0.45f green:0.55f blue:0.82f alpha:1.00f] set];
        NSFrameRect(rect);
    }
    
    // Draw scrubber
    float currentPos = [seq timeToPosition:seq.timelinePosition];
    float yPos = self.bounds.size.height - imgScrubHandle.size.height;
    
    // Handle
    [imgScrubHandle drawAtPoint:NSMakePoint(currentPos-3, yPos-1) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    // Line
    [imgScrubLine drawInRect:NSMakeRect(currentPos, 0, 2, yPos) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint mouseLocationInWindow = [theEvent locationInWindow];
    NSPoint mouseLocation = [self convertPoint: mouseLocationInWindow fromView: NULL];
    
    SequencerSequence* seq = [SequencerHandler sharedHandler].currentSequence;
    
    if (mouseLocation.y > self.bounds.size.height - 16)
    {
        // Scrubbing
        seq.timelinePosition = [seq positionToTime:mouseLocation.x];
        mouseState = kCCBSeqMouseStateScrubbing;
    }
    else
    {
        mouseState = kCCBSeqMouseStateSelecting;
        
        // Position in time
        xStartSelectTime = [seq positionToTime:mouseLocation.x];
        xEndSelectTime = xStartSelectTime;
        
        // Position in row
        yStartSelectRow = [self yMousePosToRow:mouseLocation.y];
        yEndSelectRow = yStartSelectRow;
        
        NSLog(@"clickedRow: %d", yStartSelectRow);
    }
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseLocationInWindow = [theEvent locationInWindow];
    NSPoint mouseLocation = [self convertPoint: mouseLocationInWindow fromView: NULL];
    
    SequencerSequence* seq = [SequencerHandler sharedHandler].currentSequence;
    
    if (mouseState == kCCBSeqMouseStateScrubbing)
    {
        seq.timelinePosition = [seq positionToTime:mouseLocation.x];
    }
    else if (mouseState == kCCBSeqMouseStateSelecting)
    {
        xEndSelectTime = [seq positionToTime:mouseLocation.x];
        yEndSelectRow = [self yMousePosToRow:mouseLocation.y];
        
        [self setNeedsDisplay:YES];
    }
}

- (void) mouseUp:(NSEvent *)theEvent
{
    mouseState = kCCBSeqMouseStateNone;
    [self setNeedsDisplay:YES];
}

- (void) dealloc
{
    [imgScrubHandle release];
    [imgScrubLine release];
    [super dealloc];
}

@end