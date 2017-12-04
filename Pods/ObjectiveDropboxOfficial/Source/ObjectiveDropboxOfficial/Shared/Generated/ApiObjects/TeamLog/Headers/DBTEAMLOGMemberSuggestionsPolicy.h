///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGMemberSuggestionsPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `MemberSuggestionsPolicy` union.
///
/// Member suggestions policy
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGMemberSuggestionsPolicy : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMLOGMemberSuggestionsPolicyTag` enum type represents the possible
/// tag states with which the `DBTEAMLOGMemberSuggestionsPolicy` union can
/// exist.
typedef NS_ENUM(NSInteger, DBTEAMLOGMemberSuggestionsPolicyTag) {
  /// (no description).
  DBTEAMLOGMemberSuggestionsPolicyDisabled,

  /// (no description).
  DBTEAMLOGMemberSuggestionsPolicyEnabled,

  /// (no description).
  DBTEAMLOGMemberSuggestionsPolicyOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMLOGMemberSuggestionsPolicyTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "disabled".
///
/// @return An initialized instance.
///
- (instancetype)initWithDisabled;

///
/// Initializes union class with tag state of "enabled".
///
/// @return An initialized instance.
///
- (instancetype)initWithEnabled;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "disabled".
///
/// @return Whether the union's current tag state has value "disabled".
///
- (BOOL)isDisabled;

///
/// Retrieves whether the union's current tag state has value "enabled".
///
/// @return Whether the union's current tag state has value "enabled".
///
- (BOOL)isEnabled;

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
/// The serialization class for the `DBTEAMLOGMemberSuggestionsPolicy` union.
///
@interface DBTEAMLOGMemberSuggestionsPolicySerializer : NSObject

///
/// Serializes `DBTEAMLOGMemberSuggestionsPolicy` instances.
///
/// @param instance An instance of the `DBTEAMLOGMemberSuggestionsPolicy` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGMemberSuggestionsPolicy` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGMemberSuggestionsPolicy *)instance;

///
/// Deserializes `DBTEAMLOGMemberSuggestionsPolicy` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGMemberSuggestionsPolicy` API object.
///
/// @return An instantiation of the `DBTEAMLOGMemberSuggestionsPolicy` object.
///
+ (DBTEAMLOGMemberSuggestionsPolicy *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
