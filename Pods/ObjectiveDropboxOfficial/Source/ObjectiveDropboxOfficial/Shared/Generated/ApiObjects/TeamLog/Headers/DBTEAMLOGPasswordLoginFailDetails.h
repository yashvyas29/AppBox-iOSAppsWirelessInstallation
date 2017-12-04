///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGFailureDetailsLogInfo;
@class DBTEAMLOGPasswordLoginFailDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `PasswordLoginFailDetails` struct.
///
/// Failed to sign in using a password.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGPasswordLoginFailDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Login failure details.
@property (nonatomic, readonly) DBTEAMLOGFailureDetailsLogInfo *errorDetails;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param errorDetails Login failure details.
///
/// @return An initialized instance.
///
- (instancetype)initWithErrorDetails:(DBTEAMLOGFailureDetailsLogInfo *)errorDetails;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `PasswordLoginFailDetails` struct.
///
@interface DBTEAMLOGPasswordLoginFailDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGPasswordLoginFailDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGPasswordLoginFailDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGPasswordLoginFailDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGPasswordLoginFailDetails *)instance;

///
/// Deserializes `DBTEAMLOGPasswordLoginFailDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGPasswordLoginFailDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGPasswordLoginFailDetails` object.
///
+ (DBTEAMLOGPasswordLoginFailDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
