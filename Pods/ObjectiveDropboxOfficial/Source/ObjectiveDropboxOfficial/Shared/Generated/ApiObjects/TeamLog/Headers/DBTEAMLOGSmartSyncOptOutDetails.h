///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGSmartSyncOptOutDetails;
@class DBTEAMLOGSmartSyncOptOutPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SmartSyncOptOutDetails` struct.
///
/// Opted team out of Smart Sync.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSmartSyncOptOutDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Previous Smart Sync opt out policy.
@property (nonatomic, readonly) DBTEAMLOGSmartSyncOptOutPolicy *previousValue;

/// New Smart Sync opt out policy.
@property (nonatomic, readonly) DBTEAMLOGSmartSyncOptOutPolicy *dNewValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param previousValue Previous Smart Sync opt out policy.
/// @param dNewValue New Smart Sync opt out policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithPreviousValue:(DBTEAMLOGSmartSyncOptOutPolicy *)previousValue
                            dNewValue:(DBTEAMLOGSmartSyncOptOutPolicy *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SmartSyncOptOutDetails` struct.
///
@interface DBTEAMLOGSmartSyncOptOutDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSmartSyncOptOutDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGSmartSyncOptOutDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSmartSyncOptOutDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGSmartSyncOptOutDetails *)instance;

///
/// Deserializes `DBTEAMLOGSmartSyncOptOutDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSmartSyncOptOutDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGSmartSyncOptOutDetails` object.
///
+ (DBTEAMLOGSmartSyncOptOutDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
