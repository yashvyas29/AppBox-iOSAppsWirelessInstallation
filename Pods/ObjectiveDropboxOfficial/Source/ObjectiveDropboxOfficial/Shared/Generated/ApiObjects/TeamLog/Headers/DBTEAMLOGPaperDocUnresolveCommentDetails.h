///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGPaperDocUnresolveCommentDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `PaperDocUnresolveCommentDetails` struct.
///
/// Unresolved a Paper doc comment.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGPaperDocUnresolveCommentDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Event unique identifier.
@property (nonatomic, readonly, copy) NSString *eventUuid;

/// Comment text. Might be missing due to historical data gap.
@property (nonatomic, readonly, copy, nullable) NSString *commentText;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param eventUuid Event unique identifier.
/// @param commentText Comment text. Might be missing due to historical data
/// gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithEventUuid:(NSString *)eventUuid commentText:(nullable NSString *)commentText;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param eventUuid Event unique identifier.
///
/// @return An initialized instance.
///
- (instancetype)initWithEventUuid:(NSString *)eventUuid;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `PaperDocUnresolveCommentDetails` struct.
///
@interface DBTEAMLOGPaperDocUnresolveCommentDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGPaperDocUnresolveCommentDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGPaperDocUnresolveCommentDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGPaperDocUnresolveCommentDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGPaperDocUnresolveCommentDetails *)instance;

///
/// Deserializes `DBTEAMLOGPaperDocUnresolveCommentDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGPaperDocUnresolveCommentDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGPaperDocUnresolveCommentDetails`
/// object.
///
+ (DBTEAMLOGPaperDocUnresolveCommentDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
