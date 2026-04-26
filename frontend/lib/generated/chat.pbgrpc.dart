// This is a generated file - do not edit.
//
// Generated from chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pb.dart' as $0;

export 'chat.pb.dart';

@$pb.GrpcServiceName('chat.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateChatResponse> createChat(
    $0.CreateChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createChat, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteChatResponse> deleteChat(
    $0.DeleteChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteChat, request, options: options);
  }

  $grpc.ResponseFuture<$0.MessageActionResponse> sendMessage(
    $0.SendMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.MessageActionResponse> updateMessage(
    $0.UpdateMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.MessageActionResponse> deleteMessage(
    $0.DeleteMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncResponse> sync(
    $0.SyncRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sync, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkReadResponse> markRead(
    $0.MarkReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markRead, request, options: options);
  }

  // method descriptors

  static final _$createChat =
      $grpc.ClientMethod<$0.CreateChatRequest, $0.CreateChatResponse>(
          '/chat.ChatService/CreateChat',
          ($0.CreateChatRequest value) => value.writeToBuffer(),
          $0.CreateChatResponse.fromBuffer);
  static final _$deleteChat =
      $grpc.ClientMethod<$0.DeleteChatRequest, $0.DeleteChatResponse>(
          '/chat.ChatService/DeleteChat',
          ($0.DeleteChatRequest value) => value.writeToBuffer(),
          $0.DeleteChatResponse.fromBuffer);
  static final _$sendMessage =
      $grpc.ClientMethod<$0.SendMessageRequest, $0.MessageActionResponse>(
          '/chat.ChatService/SendMessage',
          ($0.SendMessageRequest value) => value.writeToBuffer(),
          $0.MessageActionResponse.fromBuffer);
  static final _$updateMessage =
      $grpc.ClientMethod<$0.UpdateMessageRequest, $0.MessageActionResponse>(
          '/chat.ChatService/UpdateMessage',
          ($0.UpdateMessageRequest value) => value.writeToBuffer(),
          $0.MessageActionResponse.fromBuffer);
  static final _$deleteMessage =
      $grpc.ClientMethod<$0.DeleteMessageRequest, $0.MessageActionResponse>(
          '/chat.ChatService/DeleteMessage',
          ($0.DeleteMessageRequest value) => value.writeToBuffer(),
          $0.MessageActionResponse.fromBuffer);
  static final _$sync = $grpc.ClientMethod<$0.SyncRequest, $0.SyncResponse>(
      '/chat.ChatService/Sync',
      ($0.SyncRequest value) => value.writeToBuffer(),
      $0.SyncResponse.fromBuffer);
  static final _$markRead =
      $grpc.ClientMethod<$0.MarkReadRequest, $0.MarkReadResponse>(
          '/chat.ChatService/MarkRead',
          ($0.MarkReadRequest value) => value.writeToBuffer(),
          $0.MarkReadResponse.fromBuffer);
}

@$pb.GrpcServiceName('chat.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateChatRequest, $0.CreateChatResponse>(
        'CreateChat',
        createChat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateChatRequest.fromBuffer(value),
        ($0.CreateChatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteChatRequest, $0.DeleteChatResponse>(
        'DeleteChat',
        deleteChat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteChatRequest.fromBuffer(value),
        ($0.DeleteChatResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendMessageRequest, $0.MessageActionResponse>(
            'SendMessage',
            sendMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SendMessageRequest.fromBuffer(value),
            ($0.MessageActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateMessageRequest, $0.MessageActionResponse>(
            'UpdateMessage',
            updateMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateMessageRequest.fromBuffer(value),
            ($0.MessageActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteMessageRequest, $0.MessageActionResponse>(
            'DeleteMessage',
            deleteMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteMessageRequest.fromBuffer(value),
            ($0.MessageActionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncRequest, $0.SyncResponse>(
        'Sync',
        sync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncRequest.fromBuffer(value),
        ($0.SyncResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkReadRequest, $0.MarkReadResponse>(
        'MarkRead',
        markRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MarkReadRequest.fromBuffer(value),
        ($0.MarkReadResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateChatResponse> createChat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateChatRequest> $request) async {
    return createChat($call, await $request);
  }

  $async.Future<$0.CreateChatResponse> createChat(
      $grpc.ServiceCall call, $0.CreateChatRequest request);

  $async.Future<$0.DeleteChatResponse> deleteChat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteChatRequest> $request) async {
    return deleteChat($call, await $request);
  }

  $async.Future<$0.DeleteChatResponse> deleteChat(
      $grpc.ServiceCall call, $0.DeleteChatRequest request);

  $async.Future<$0.MessageActionResponse> sendMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.MessageActionResponse> sendMessage(
      $grpc.ServiceCall call, $0.SendMessageRequest request);

  $async.Future<$0.MessageActionResponse> updateMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateMessageRequest> $request) async {
    return updateMessage($call, await $request);
  }

  $async.Future<$0.MessageActionResponse> updateMessage(
      $grpc.ServiceCall call, $0.UpdateMessageRequest request);

  $async.Future<$0.MessageActionResponse> deleteMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteMessageRequest> $request) async {
    return deleteMessage($call, await $request);
  }

  $async.Future<$0.MessageActionResponse> deleteMessage(
      $grpc.ServiceCall call, $0.DeleteMessageRequest request);

  $async.Future<$0.SyncResponse> sync_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SyncRequest> $request) async {
    return sync($call, await $request);
  }

  $async.Future<$0.SyncResponse> sync(
      $grpc.ServiceCall call, $0.SyncRequest request);

  $async.Future<$0.MarkReadResponse> markRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkReadRequest> $request) async {
    return markRead($call, await $request);
  }

  $async.Future<$0.MarkReadResponse> markRead(
      $grpc.ServiceCall call, $0.MarkReadRequest request);
}

@$pb.GrpcServiceName('chat.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.NotificationResponse> sendTelegramType(
    $0.NotificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendTelegramType, request, options: options);
  }

  // method descriptors

  static final _$sendTelegramType =
      $grpc.ClientMethod<$0.NotificationRequest, $0.NotificationResponse>(
          '/chat.NotificationService/SendTelegramType',
          ($0.NotificationRequest value) => value.writeToBuffer(),
          $0.NotificationResponse.fromBuffer);
}

@$pb.GrpcServiceName('chat.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.NotificationService';

  NotificationServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.NotificationRequest, $0.NotificationResponse>(
            'SendTelegramType',
            sendTelegramType_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.NotificationRequest.fromBuffer(value),
            ($0.NotificationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.NotificationResponse> sendTelegramType_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.NotificationRequest> $request) async {
    return sendTelegramType($call, await $request);
  }

  $async.Future<$0.NotificationResponse> sendTelegramType(
      $grpc.ServiceCall call, $0.NotificationRequest request);
}
