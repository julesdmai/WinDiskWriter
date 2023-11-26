//
//  LogView.m
//  WinDiskWriter GUI
//
//  Created by Macintosh on 26.11.2023.
//  Copyright © 2023 TechUnRestricted. All rights reserved.
//

#import "LogView.h"
#import "NSColor+Common.h"
#import "VibrantTableView.h"
#import "NSMutableAttributedString+Common.h"

ASLogType const ASLogTypeStart = @"Start";
ASLogType const ASLogTypeSuccess = @"Success";
ASLogType const ASLogTypeFailure = @"Failure";
ASLogType const ASLogTypeSkipped = @"Skipped";

ASLogType const ASLogTypeLog = @"Log";
ASLogType const ASLogTypeWarning = @"Warning";
ASLogType const ASLogTypeFatal = @"Fatal";
ASLogType const ASLogTypeAssertionError = @"AssertionFailure";

@implementation LogView {
    NSDateFormatter *dateFormatter;
    NSTextField *dummyTextField;
}

- (instancetype)init {
    self = [super init];
    
    _tableViewInstance = [[VibrantTableView alloc] init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    
    dummyTextField = [[NSTextField alloc] init];
    [dummyTextField setFont: ((VibrantTableView *)self.tableViewInstance).requiredFont];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    [self setHasVerticalScroller: YES];
    [self setHasHorizontalScroller: YES];

    [self setAutohidesScrollers: YES];
    [self setDrawsBackground: NO];
    
    [self setDocumentView: self.tableViewInstance];
    
    [self.contentView setWantsLayer: YES];
    [self.contentView.layer setCornerRadius: 10.0f];
    
    [self.contentView.layer setBorderColor: [NSColor.textColor colorWithAlphaComponent: 0.25].toCGColor];
    
    [self.contentView.layer setBorderWidth: 1.5f];
    
    return self;
}

- (NSString *)timeString {    
    return [dateFormatter stringFromDate: NSDate.date];
}

- (void)appendRow: (NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        VibrantTableView *childView = (VibrantTableView *)self.tableViewInstance;
        
        [self->dummyTextField setStringValue: string];
        
        CGFloat requiredCellWidth = self->dummyTextField.cell.cellSize.width;
        CGFloat currentColumnWidth = [childView.mainColumn width];
        
        if (requiredCellWidth > currentColumnWidth) {
            [childView.mainColumn setWidth:requiredCellWidth];
        }
        
        [childView.rowData addObject: string];
        [childView reloadData];
        
        if ([childView numberOfRows] > 0) {
            [childView scrollRowToVisible: [childView numberOfRows] - 1];
        }
        //[childView.mainColumn setWidth: 5000];
    });
}

- (void)appendTimestampedRow: (NSString *)string
                     logType: (ASLogType)logType {
    NSString *timestampedString = [NSString stringWithFormat: @"[(%@) %@] %@", logType, [self timeString], string];
    
    [self appendRow: timestampedString];
}

- (void)appendRow: (NSString *)string
          logType: (ASLogType)logType {
    NSString *logTypedString = [NSString stringWithFormat: @"[%@] %@", logType, string];
    
    [self appendRow:logTypedString];
}

- (void)appendTimestampedRow: (NSString *)string {
    NSString *finalString = [NSString stringWithFormat: @"[%@] %@", [self timeString], string];
    
    [self appendRow: finalString];
}

- (BOOL)allowsVibrancy {
    return YES;
}

@end
