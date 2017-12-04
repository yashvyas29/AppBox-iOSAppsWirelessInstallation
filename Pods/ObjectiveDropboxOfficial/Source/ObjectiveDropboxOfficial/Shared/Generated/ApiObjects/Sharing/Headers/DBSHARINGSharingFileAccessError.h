///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGSharingFileAccessError;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharingFileAccessError` union.
///
/// User could not access this file.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGSharingFileAccessError : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBSHARINGSharingFileAccessErrorTag` enum type represents the possible
/// tag states with which the `DBSHARINGSharingFileAccessError` union can exist.
typedef NS_ENUM(NSInteger, DBSHARINGSharingFileAccessErrorTag) {
  /// Current user does not have sufficient privileges to perform the desired
  /// action.
  DBSHARINGSharingFileAccessErrorNoPermission,

  /// File specified was not found.
  DBSHARINGSharingFileAccessErrorInvalidFile,

  /// A folder can't be shared this way. Use folder sharing or a shared link
  /// instead.
  DBSHARINGSharingFileAccessErrorIsFolder,

  /// A file inside a public folder can't be shared this way. Use a public
  /// link instead.
  DBSHARINGSharingFileAccessErrorInsidePublicFolder,

  /// A Mac OS X package can't be shared this way. Use a shared link instead.
  DBSHARINGSharingFileAccessErrorInsideOsxPackage,

  /// (no description).
  DBSHARINGSharingFileAccessErrorOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBSHARINGSharingFileAccessErrorTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "no_permission".
///
/// Description of the "no_permission" tag state: Current user does not have
/// sufficient privileges to perform the desired action.
///
/// @return An initialized instance.
///
- (instancetype)initWithNoPermission;

///
/// Initializes union class with tag state of "invalid_file".
///
/// Description of the "invalid_file" tag state: File specified was not found.
///
/// @return An initialized instance.
///
- (instancetype)initWithInvalidFile;

///
/// Initializes union class with tag state of "is_folder".
///
/// Description of the "is_folder" tag state: A folder can't be shared this way.
/// Use folder sharing or a shared link instead.
///
/// @return An initialized instance.
///
- (instancetype)initWithIsFolder;

///
/// Initializes union class with tag state of "inside_public_folder".
///
/// Description of the "inside_public_folder" tag state: A file inside a public
/// folder can't be shared this way. Use a public link instead.
///
/// @return An initialized instance.
///
- (instancetype)initWithInsidePublicFolder;

///
/// Initializes union class with tag state of "inside_osx_package".
///
/// Description of the "inside_osx_package" tag state: A Mac OS X package can't
/// be shared this way. Use a shared link instead.
///
/// @return An initialized instance.
///
- (instancetype)initWithInsideOsxPackage;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "no_permission".
///
/// @return Whether the union's current tag state has value "no_permission".
///
- (BOOL)isNoPermission;

///
/// Retrieves whether the union's current tag state has value "invalid_file".
///
/// @return Whether the union's current tag state has value "invalid_file".
///
- (BOOL)isInvalidFile;

///
/// Retrieves whether the union's current tag state has value "is_folder".
///
/// @return Whether the union's current tag state has value "is_folder".
///
- (BOOL)isIsFolder;

///
/// Retrieves whether the union's current tag state has value
/// "inside_public_folder".
///
/// @return Whether the union's current tag state has value
/// "inside_public_folder".
///
- (BOOL)isInsidePublicFolder;

///
/// Retrieves whether the union's current tag state has value
/// "inside_osx_package".
///
/// @return Whether the union's current tag state has value
/// "inside_osx_package".
///
- (BOOL)isInsideOsxPackage;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBSHARINGSharingFileAccessError` union.
///
@interface DBSHARINGSharingFileAccessErrorSerializer : NSObject

///
/// Serializes `DBSHARINGSharingFileAccessError` instances.
///
/// @param instance An instance of the `DBSHARINGSharingFileAccessError` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGSharingFileAccessError` API object.
///
+ (nullable NSDictionary *)serialize:(DBSHARINGSharingFileAccessError *)instance;

///
/// Deserializes `DBSHARINGSharingFileAccessError` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGSharingFileAccessError` API object.
///
/// @return An instantiation of the `DBSHARINGSharingFileAccessError` object.
///
+ (DBSHARINGSharingFileAccessError *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
