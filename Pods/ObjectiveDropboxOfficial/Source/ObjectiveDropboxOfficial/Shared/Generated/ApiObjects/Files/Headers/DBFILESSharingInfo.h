///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBFILESSharingInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharingInfo` struct.
///
/// Sharing info for a file or folder.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBFILESSharingInfo : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// True if the file or folder is inside a read-only shared folder.
@property (nonatomic, readonly) NSNumber *readOnly;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param readOnly True if the file or folder is inside a read-only shared
/// folder.
///
/// @return An initialized instance.
///
- (instancetype)initWithReadOnly:(NSNumber *)readOnly;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SharingInfo` struct.
///
@interface DBFILESSharingInfoSerializer : NSObject

///
/// Serializes `DBFILESSharingInfo` instances.
///
/// @param instance An instance of the `DBFILESSharingInfo` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBFILESSharingInfo` API object.
///
+ (nullable NSDictionary *)serialize:(DBFILESSharingInfo *)instance;

///
/// Deserializes `DBFILESSharingInfo` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBFILESSharingInfo` API object.
///
/// @return An instantiation of the `DBFILESSharingInfo` object.
///
+ (DBFILESSharingInfo *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
