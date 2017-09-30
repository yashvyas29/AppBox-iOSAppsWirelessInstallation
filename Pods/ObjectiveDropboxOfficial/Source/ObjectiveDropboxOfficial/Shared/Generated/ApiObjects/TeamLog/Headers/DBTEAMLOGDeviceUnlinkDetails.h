///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGDeviceLogInfo;
@class DBTEAMLOGDeviceUnlinkDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `DeviceUnlinkDetails` struct.
///
/// Disconnected a device.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGDeviceUnlinkDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Device information.
@property (nonatomic, readonly) DBTEAMLOGDeviceLogInfo *deviceInfo;

/// True if the user requested to delete data after device unlink, false
/// otherwise.
@property (nonatomic, readonly) NSNumber *deleteData;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param deviceInfo Device information.
/// @param deleteData True if the user requested to delete data after device
/// unlink, false otherwise.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceInfo:(DBTEAMLOGDeviceLogInfo *)deviceInfo deleteData:(NSNumber *)deleteData;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DeviceUnlinkDetails` struct.
///
@interface DBTEAMLOGDeviceUnlinkDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGDeviceUnlinkDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGDeviceUnlinkDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceUnlinkDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGDeviceUnlinkDetails *)instance;

///
/// Deserializes `DBTEAMLOGDeviceUnlinkDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceUnlinkDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGDeviceUnlinkDetails` object.
///
+ (DBTEAMLOGDeviceUnlinkDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
