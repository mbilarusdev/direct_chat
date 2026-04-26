// This is a generated file - do not edit.
//
// Generated from chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use createChatRequestDescriptor instead')
const CreateChatRequest$json = {
  '1': 'CreateChatRequest',
  '2': [
    {'1': 'admin_id', '3': 1, '4': 1, '5': 9, '10': 'adminId'},
    {'1': 'client_id', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `CreateChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVDaGF0UmVxdWVzdBIZCghhZG1pbl9pZBgBIAEoCVIHYWRtaW5JZBIbCgljbGllbn'
    'RfaWQYAiABKAlSCGNsaWVudElkEhQKBXRpdGxlGAMgASgJUgV0aXRsZQ==');

@$core.Deprecated('Use createChatResponseDescriptor instead')
const CreateChatResponse$json = {
  '1': 'CreateChatResponse',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `CreateChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatResponseDescriptor =
    $convert.base64Decode(
        'ChJDcmVhdGVDaGF0UmVzcG9uc2USFwoHY2hhdF9pZBgBIAEoCVIGY2hhdElk');

@$core.Deprecated('Use deleteChatRequestDescriptor instead')
const DeleteChatRequest$json = {
  '1': 'DeleteChatRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `DeleteChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChatRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVDaGF0UmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQ=');

@$core.Deprecated('Use deleteChatResponseDescriptor instead')
const DeleteChatResponse$json = {
  '1': 'DeleteChatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChatResponseDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVDaGF0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use sendMessageRequestDescriptor instead')
const SendMessageRequest$json = {
  '1': 'SendMessageRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'sender_id', '3': 2, '4': 1, '5': 9, '10': 'senderId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `SendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageRequestDescriptor = $convert.base64Decode(
    'ChJTZW5kTWVzc2FnZVJlcXVlc3QSFwoHY2hhdF9pZBgBIAEoCVIGY2hhdElkEhsKCXNlbmRlcl'
    '9pZBgCIAEoCVIIc2VuZGVySWQSEgoEdGV4dBgDIAEoCVIEdGV4dA==');

@$core.Deprecated('Use updateMessageRequestDescriptor instead')
const UpdateMessageRequest$json = {
  '1': 'UpdateMessageRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'new_text', '3': 3, '4': 1, '5': 9, '10': 'newText'},
  ],
};

/// Descriptor for `UpdateMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMessageRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVNZXNzYWdlUmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQSHQoKbWVzc2'
    'FnZV9pZBgCIAEoCVIJbWVzc2FnZUlkEhkKCG5ld190ZXh0GAMgASgJUgduZXdUZXh0');

@$core.Deprecated('Use deleteMessageRequestDescriptor instead')
const DeleteMessageRequest$json = {
  '1': 'DeleteMessageRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
  ],
};

/// Descriptor for `DeleteMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMessageRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVNZXNzYWdlUmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQSHQoKbWVzc2'
    'FnZV9pZBgCIAEoCVIJbWVzc2FnZUlk');

@$core.Deprecated('Use messageActionResponseDescriptor instead')
const MessageActionResponse$json = {
  '1': 'MessageActionResponse',
  '2': [
    {'1': 'pts', '3': 1, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'receiver_id', '3': 2, '4': 1, '5': 9, '10': 'receiverId'},
    {'1': 'chat_id', '3': 3, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `MessageActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageActionResponseDescriptor = $convert.base64Decode(
    'ChVNZXNzYWdlQWN0aW9uUmVzcG9uc2USEAoDcHRzGAEgASgDUgNwdHMSHwoLcmVjZWl2ZXJfaW'
    'QYAiABKAlSCnJlY2VpdmVySWQSFwoHY2hhdF9pZBgDIAEoCVIGY2hhdElk');

@$core.Deprecated('Use markReadRequestDescriptor instead')
const MarkReadRequest$json = {
  '1': 'MarkReadRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'pts', '3': 3, '4': 1, '5': 3, '10': 'pts'},
  ],
};

/// Descriptor for `MarkReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markReadRequestDescriptor = $convert.base64Decode(
    'Cg9NYXJrUmVhZFJlcXVlc3QSFwoHY2hhdF9pZBgBIAEoCVIGY2hhdElkEhcKB3VzZXJfaWQYAi'
    'ABKAlSBnVzZXJJZBIQCgNwdHMYAyABKANSA3B0cw==');

@$core.Deprecated('Use markReadResponseDescriptor instead')
const MarkReadResponse$json = {
  '1': 'MarkReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `MarkReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markReadResponseDescriptor = $convert.base64Decode(
    'ChBNYXJrUmVhZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use syncRequestDescriptor instead')
const SyncRequest$json = {
  '1': 'SyncRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'last_pts', '3': 2, '4': 1, '5': 3, '10': 'lastPts'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `SyncRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncRequestDescriptor = $convert.base64Decode(
    'CgtTeW5jUmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQSGQoIbGFzdF9wdHMYAiABKA'
    'NSB2xhc3RQdHMSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklk');

@$core.Deprecated('Use syncResponseDescriptor instead')
const SyncResponse$json = {
  '1': 'SyncResponse',
  '2': [
    {'1': 'current_pts', '3': 1, '4': 1, '5': 3, '10': 'currentPts'},
    {'1': 'read_pts', '3': 2, '4': 1, '5': 3, '10': 'readPts'},
    {'1': 'full_reload', '3': 3, '4': 1, '5': 8, '10': 'fullReload'},
    {
      '1': 'messages',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.chat.Message',
      '10': 'messages'
    },
    {'1': 'chat_id', '3': 5, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `SyncResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncResponseDescriptor = $convert.base64Decode(
    'CgxTeW5jUmVzcG9uc2USHwoLY3VycmVudF9wdHMYASABKANSCmN1cnJlbnRQdHMSGQoIcmVhZF'
    '9wdHMYAiABKANSB3JlYWRQdHMSHwoLZnVsbF9yZWxvYWQYAyABKAhSCmZ1bGxSZWxvYWQSKQoI'
    'bWVzc2FnZXMYBCADKAsyDS5jaGF0Lk1lc3NhZ2VSCG1lc3NhZ2VzEhcKB2NoYXRfaWQYBSABKA'
    'lSBmNoYXRJZA==');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'sender_id', '3': 2, '4': 1, '5': 9, '10': 'senderId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'pts', '3': 4, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'chat_id', '3': 5, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBIbCglzZW5kZXJfaWQYAiABKAlSCHNlbmRlcklkEh'
    'IKBHRleHQYAyABKAlSBHRleHQSEAoDcHRzGAQgASgDUgNwdHMSFwoHY2hhdF9pZBgFIAEoCVIG'
    'Y2hhdElk');

@$core.Deprecated('Use notificationRequestDescriptor instead')
const NotificationRequest$json = {
  '1': 'NotificationRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'message_text', '3': 2, '4': 1, '5': 9, '10': 'messageText'},
  ],
};

/// Descriptor for `NotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationRequestDescriptor = $convert.base64Decode(
    'ChNOb3RpZmljYXRpb25SZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIhCgxtZXNzYW'
    'dlX3RleHQYAiABKAlSC21lc3NhZ2VUZXh0');

@$core.Deprecated('Use notificationResponseDescriptor instead')
const NotificationResponse$json = {
  '1': 'NotificationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `NotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationResponseDescriptor =
    $convert.base64Decode(
        'ChROb3RpZmljYXRpb25SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');
