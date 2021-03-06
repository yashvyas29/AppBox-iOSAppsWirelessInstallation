///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGAccountCaptureAvailability;
@class DBTEAMLOGAccountCaptureChangeAvailabilityDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `AccountCaptureChangeAvailabilityDetails` struct.
///
/// Granted or revoked the option to enable account capture on domains belonging
/// to the team.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGAccountCaptureChangeAvailabilityDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// New account capture availabilty value.
@property (nonatomic, readonly) DBTEAMLOGAccountCaptureAvailability *dNewValue;

/// Previous account capture availabilty value. Might be missing due to
/// historical data gap.
@property (nonatomic, readonly, nullable) DBTEAMLOGAccountCaptureAvailability *previousValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New account capture availabilty value.
/// @param previousValue Previous account capture availabilty value. Might be
/// missing due to historical data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGAccountCaptureAvailability *)dNewValue
                    previousValue:(nullable DBTEAMLOGAccountCaptureAvailability *)previousValue;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New account capture availabilty value.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGAccountCaptureAvailability *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `AccountCaptureChangeAvailabilityDetails`
/// struct.
///
@interface DBTEAMLOGAccountCaptureChangeAvailabilityDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGAccountCaptureChangeAvailabilityDetails *)instance;

///
/// Deserializes `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGAccountCaptureChangeAvailabilityDetails` object.
///
+ (DBTEAMLOGAccountCaptureChangeAvailabilityDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
