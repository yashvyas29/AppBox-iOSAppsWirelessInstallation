//
//  Project+CoreDataClass.h
//  
//
//  Created by Vineet Choudhary on 17/10/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CISetting, UploadRecord;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SaveCIDetails,
    SaveUploadDetails,
} SaveDetailTypes;

@interface Project : NSManagedObject

+(Project *)addProjectWithXCProject:(XCProject *)xcProject andSaveDetails:(SaveDetailTypes)saveDetails;

@end

NS_ASSUME_NONNULL_END

#import "Project+CoreDataProperties.h"
