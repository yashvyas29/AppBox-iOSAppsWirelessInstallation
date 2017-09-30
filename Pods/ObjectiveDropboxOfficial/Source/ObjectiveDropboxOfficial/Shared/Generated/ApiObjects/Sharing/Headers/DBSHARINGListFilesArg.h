///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGFileAction;
@class DBSHARINGListFilesArg;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `ListFilesArg` struct.
///
/// Arguments for `listReceivedFiles`.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGListFilesArg : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Number of files to return max per query. Defaults to 100 if no limit is
/// specified.
@property (nonatomic, readonly) NSNumber *limit;

/// A list of `FileAction`s corresponding to `FilePermission`s that should
/// appear in the  response's `permissions` in `DBSHARINGSharedFileMetadata`
/// field describing the actions the  authenticated user can perform on the
/// file.
@property (nonatomic, readonly, nullable) NSArray<DBSHARINGFileAction *> *actions;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param limit Number of files to return max per query. Defaults to 100 if no
/// limit is specified.
/// @param actions A list of `FileAction`s corresponding to `FilePermission`s
/// that should appear in the  response's `permissions` in
/// `DBSHARINGSharedFileMetadata` field describing the actions the
/// authenticated user can perform on the file.
///
/// @return An initialized instance.
///
- (instancetype)initWithLimit:(nullable NSNumber *)limit actions:(nullable NSArray<DBSHARINGFileAction *> *)actions;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `ListFilesArg` struct.
///
@interface DBSHARINGListFilesArgSerializer : NSObject

///
/// Serializes `DBSHARINGListFilesArg` instances.
///
/// @param instance An instance of the `DBSHARINGListFilesArg` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGListFilesArg` API object.
///
+ (NSDictionary *)serialize:(DBSHARINGListFilesArg *)instance;

///
/// Deserializes `DBSHARINGListFilesArg` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGListFilesArg` API object.
///
/// @return An instantiation of the `DBSHARINGListFilesArg` object.
///
+ (DBSHARINGListFilesArg *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
