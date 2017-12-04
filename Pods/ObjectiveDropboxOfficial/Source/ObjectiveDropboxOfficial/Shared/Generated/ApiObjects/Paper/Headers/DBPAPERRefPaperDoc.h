///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBPAPERRefPaperDoc;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `RefPaperDoc` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBPAPERRefPaperDoc : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The Paper doc ID.
@property (nonatomic, readonly, copy) NSString *docId;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param docId The Paper doc ID.
///
/// @return An initialized instance.
///
- (instancetype)initWithDocId:(NSString *)docId;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `RefPaperDoc` struct.
///
@interface DBPAPERRefPaperDocSerializer : NSObject

///
/// Serializes `DBPAPERRefPaperDoc` instances.
///
/// @param instance An instance of the `DBPAPERRefPaperDoc` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBPAPERRefPaperDoc` API object.
///
+ (nullable NSDictionary *)serialize:(DBPAPERRefPaperDoc *)instance;

///
/// Deserializes `DBPAPERRefPaperDoc` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBPAPERRefPaperDoc` API object.
///
/// @return An instantiation of the `DBPAPERRefPaperDoc` object.
///
+ (DBPAPERRefPaperDoc *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
