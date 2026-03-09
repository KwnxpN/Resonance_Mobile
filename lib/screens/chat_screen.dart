import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

// --- Simple Chat Message Model ---
class ChatMessage {
  final String userId;
  final String content;

  ChatMessage({required this.userId, required this.content});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      userId: json['UserID'] ?? json['user_id'] ?? '',
      content: json['Content'] ?? json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'content': content,
  };
}

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String matchId;       // Used as room_id
  final String currentUserId; // Required for backend identity

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.matchId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel _channel;
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    final wsUrl = Uri.parse(
      'ws://10.0.2.2:8000/ws/chat/${widget.matchId}?user_id=${widget.currentUserId}',
    );

    debugPrint('🔄 Attempting to connect to WebSocket...');
    debugPrint('🔗 URL: $wsUrl');

    try {
      _channel = WebSocketChannel.connect(wsUrl);

      // Await the ready getter to confirm the connection is established
      await _channel.ready;
      debugPrint(
        '✅ WebSocket connected successfully to room: ${widget.matchId}!',
      );

      _channel.stream.listen(
        (message) {
          debugPrint('📥 Received message: $message');
          final decoded = jsonDecode(message);
          setState(() {
            _messages.add(ChatMessage.fromJson(decoded));
          });
        },
        onError: (error) => debugPrint('❌ WebSocket error: $error'),
        onDone: () => debugPrint('⚠️ WebSocket connection closed'),
      );
    } catch (e) {
      // This will catch immediate connection failures (e.g., server offline)
      debugPrint('🚨 Failed to connect to WebSocket: $e');
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final msgContent = _textController.text.trim();

    // Updated to match index.html logic: only send 'content'
    final message = {'content': msgContent};

    // Send the message to the Go backend
    _channel.sink.add(jsonEncode(message));
    _textController.clear();
  }

  @override
  void dispose() {
    _channel.sink.close();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, colors),
      body: Column(
        children: [
          Expanded(child: _buildChatBody(context, colors)),
          _buildMessageInput(context, colors),
        ],
      ),
    );
  }

  // ─────────────────── App Bar ───────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, AppColors colors) {
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.onBackground),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          widget.userImage.isNotEmpty
              ? Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.primary, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(widget.userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : _buildAvatar(colors, 38, widget.userName),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: AppTextStyles.textMd(context).copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.headphones, color: colors.primary, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'Listening to Daft Punk',
                    style: AppTextStyles.textXs(context).copyWith(color: colors.muted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────── Chat Body ───────────────────
  Widget _buildChatBody(BuildContext context, AppColors colors) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isMe = msg.userId == widget.currentUserId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: isMe
              ? _buildOutgoingMessage(context, colors, msg.content)
              : _buildIncomingMessage(context, colors, msg.content),
        );
      },
    );
  }

  Widget _buildIncomingMessage(BuildContext context, AppColors colors, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.userImage.isNotEmpty
            ? Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.userImage),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : _buildAvatar(colors, 28, widget.userName),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.textSm(context).copyWith(color: colors.onSurface),
            ),
          ),
        ),
        const SizedBox(width: 60),
      ],
    );
  }

  Widget _buildOutgoingMessage(BuildContext context, AppColors colors, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 60),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.textSm(context).copyWith(color: colors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────── Avatar Placeholder ───────────────────
  Widget _buildAvatar(AppColors colors, double size, String name) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary.withValues(alpha: 0.2),
        border: Border.all(color: colors.primary, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }

  // ─────────────────── Message Input ───────────────────
  Widget _buildMessageInput(BuildContext context, AppColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
            child: Icon(Icons.music_note, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                style: AppTextStyles.textSm(context).copyWith(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: AppTextStyles.textSm(context).copyWith(color: colors.muted),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
              child: Icon(Icons.send, color: colors.onPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}