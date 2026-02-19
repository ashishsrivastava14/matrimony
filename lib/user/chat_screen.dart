import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';
import 'package:intl/intl.dart';
import '../widgets/user_bottom_navigation.dart';
import '../l10n/app_localizations.dart';

/// Individual chat conversation screen — matches screenshot reference
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(ChatProvider chat, String convId) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    chat.sendMessage(convId, text);
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentOptions(BuildContext context) {
    final conversation =
        ModalRoute.of(context)!.settings.arguments as ChatConversation;
    final chat = context.read<ChatProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _attachOption(
                      icon: Icons.photo_library,
                      color: Colors.purple,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _showGalleryPicker(context, chat, conversation.id);
                      },
                    ),
                    _attachOption(
                      icon: Icons.camera_alt,
                      color: Colors.blue,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _simulateCamera(context, chat, conversation.id);
                      },
                    ),
                    _attachOption(
                      icon: Icons.insert_drive_file,
                      color: Colors.orange,
                      label: 'Document',
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _showDocumentPicker(context, chat, conversation.id);
                      },
                    ),
                    _attachOption(
                      icon: Icons.location_on,
                      color: Colors.green,
                      label: 'Location',
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _showLocationPicker(context, chat, conversation.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ── Gallery: pick one of the mock profile images ────────────────────────
  void _showGalleryPicker(
      BuildContext context, ChatProvider chat, String convId) {
    const images = [
      'assets/images/profiles/profile_11.jpg',
      'assets/images/profiles/profile_12.jpg',
      'assets/images/profiles/profile_14.jpg',
      'assets/images/profiles/profile_15.jpg',
      'assets/images/profiles/profile_25.jpg',
      'assets/images/profiles/profile_32.jpg',
      'assets/images/profiles/profile_38.jpg',
      'assets/images/profiles/profile_44.jpg',
      'assets/images/profiles/profile_45.jpg',
      'assets/images/profiles/profile_47.jpg',
      'assets/images/profiles/profile_53.jpg',
      'assets/images/profiles/profile_59.jpg',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          builder: (_, scrollCtrl) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Select Photo',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: images.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetCtx);
                          chat.sendAttachment(
                            convId,
                            ChatMessageType.image,
                            images[i],
                            '📷 Photo',
                          );
                          _scrollToBottom();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(images[i], fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// ── Camera: show a "capturing" dialog then send a mock photo ─────────────
  void _simulateCamera(
      BuildContext context, ChatProvider chat, String convId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Opening camera…'),
          ],
        ),
      ),
    );

    final navigator = Navigator.of(context);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      navigator.pop(); // close dialog
      const mockPhoto = 'assets/images/profiles/profile_68.jpg';
      chat.sendAttachment(
          convId, ChatMessageType.image, mockPhoto, '📷 Photo');
      _scrollToBottom();
    });
  }

  /// ── Document: pick a mock document ──────────────────────────────────────
  void _showDocumentPicker(
      BuildContext context, ChatProvider chat, String convId) {
    final docs = [
      ('Bio Data.pdf', Icons.picture_as_pdf, Colors.red),
      ('Horoscope.pdf', Icons.picture_as_pdf, Colors.red),
      ('Wedding Invite.pdf', Icons.picture_as_pdf, Colors.red),
      ('Salary Certificate.pdf', Icons.picture_as_pdf, Colors.red),
      ('Education Certificate.pdf', Icons.picture_as_pdf, Colors.red),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Select Document',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const Divider(height: 1),
              ...docs.map((doc) {
                final (name, icon, color) = doc;
                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(name),
                  trailing: const Icon(Icons.send, color: AppColors.primary),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    chat.sendAttachment(
                      convId,
                      ChatMessageType.document,
                      name,
                      '📄 $name',
                    );
                    _scrollToBottom();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// ── Location: show a mock map card and confirm ───────────────────────────
  void _showLocationPicker(
      BuildContext context, ChatProvider chat, String convId) {
    const locations = [
      ('Current Location', 'Vijayawada, Andhra Pradesh', '16.5062° N, 80.6480° E'),
      ('Home', 'Guntur, Andhra Pradesh', '16.3067° N, 80.4365° E'),
      ('Work', 'Hyderabad, Telangana', '17.3850° N, 78.4867° E'),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Share Location',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const Divider(height: 1),
              ...locations.map((loc) {
                final (label, city, coords) = loc;
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.location_on, color: Colors.green),
                  ),
                  title: Text(label,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(city,
                      style: const TextStyle(fontSize: 12)),
                  trailing: Text(coords,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    chat.sendAttachment(
                      convId,
                      ChatMessageType.location,
                      '$city|$coords',
                      '📍 $city',
                    );
                    _scrollToBottom();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _attachOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final conversation =
        ModalRoute.of(context)!.settings.arguments as ChatConversation;

    return Scaffold(
      bottomNavigationBar: const UserBottomNavigation(),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00897B),
                Color(0xFF26A69A),
                Color(0xFF00796B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(conversation.recipientImage),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.recipientName,
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    if (conversation.isOnline)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    Text(
                      conversation.isOnline ? 'Active now' : 'Active 2h ago',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (conversation.isVerified)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 12, color: Colors.greenAccent),
                  const SizedBox(width: 3),
                  Text(l10n.idVerified,
                      style: const TextStyle(fontSize: 10, color: Colors.white)),
                ],
              ),
            ),
          if (conversation.isPremium)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 12, color: Colors.orangeAccent),
                  const SizedBox(width: 3),
                  Text(l10n.paidMember,
                      style: const TextStyle(fontSize: 10, color: Colors.white)),
                ],
              ),
            ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Date header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('d MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chat, _) {
                final messages = chat.getMessages(conversation.id);
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageBubble(message: messages[i]),
                );
              },
            ),
          ),

          // Masked contact notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: AppColors.warning.withValues(alpha: 0.1),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    size: 14, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Contact details are masked. Upgrade to Premium to view.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () => _showAttachmentOptions(context),
                        ),
                      ),
                      onSubmitted: (_) {
                        final chat = context.read<ChatProvider>();
                        _send(chat, conversation.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: _hasText
                        ? IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              final chat = context.read<ChatProvider>();
                              _send(chat, conversation.id);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.mic, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Hold to record a voice message'),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSentByMe;
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isSent ? 60 : 0,
          right: isSent ? 0 : 60,
        ),
        decoration: BoxDecoration(
          color: message.type == ChatMessageType.image
              ? Colors.transparent
              : (isSent ? AppColors.primary : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSent ? 16 : 4),
            bottomRight: Radius.circular(isSent ? 4 : 16),
          ),
          boxShadow: message.type == ChatMessageType.image
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: _buildContent(isSent),
      ),
    );
  }

  Widget _buildContent(bool isSent) {
    switch (message.type) {
      case ChatMessageType.image:
        return _ImageBubble(message: message, isSent: isSent);
      case ChatMessageType.document:
        return _DocumentBubble(message: message, isSent: isSent);
      case ChatMessageType.location:
        return _LocationBubble(message: message, isSent: isSent);
      case ChatMessageType.text:
        return _TextContent(message: message, isSent: isSent);
    }
  }
}

class _TextContent extends StatelessWidget {
  final ChatMessage message;
  final bool isSent;
  const _TextContent({required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.message,
            style: TextStyle(
              fontSize: 14,
              color: isSent ? Colors.white : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          _Timestamp(message: message, isSent: isSent),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSent;
  const _ImageBubble({required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft: Radius.circular(isSent ? 16 : 4),
        bottomRight: Radius.circular(isSent ? 4 : 16),
      ),
      child: Stack(
        children: [
          Image.asset(
            message.attachmentData!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, _a, _b) => Container(
              width: 200,
              height: 200,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, size: 48),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 8,
            child: _Timestamp(
              message: message,
              isSent: isSent,
              onImage: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSent;
  const _DocumentBubble({required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: isSent ? Colors.white70 : Colors.red,
                size: 32,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message.attachmentData ?? 'Document',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSent ? Colors.white : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _Timestamp(message: message, isSent: isSent),
        ],
      ),
    );
  }
}

class _LocationBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSent;
  const _LocationBubble({required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    final parts = (message.attachmentData ?? '|').split('|');
    final city = parts[0];
    final coords = parts.length > 1 ? parts[1] : '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 200,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSent
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFE8F5E9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,
                    color: isSent ? Colors.white : Colors.green, size: 32),
                const SizedBox(height: 4),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSent ? Colors.white : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (coords.isNotEmpty)
                  Text(
                    coords,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSent
                          ? Colors.white70
                          : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _Timestamp(message: message, isSent: isSent),
        ],
      ),
    );
  }
}

class _Timestamp extends StatelessWidget {
  final ChatMessage message;
  final bool isSent;
  final bool onImage;
  const _Timestamp(
      {required this.message, required this.isSent, this.onImage = false});

  @override
  Widget build(BuildContext context) {
    final timeColor = onImage
        ? Colors.white
        : (isSent ? Colors.white.withValues(alpha: 0.7) : AppColors.textSecondary);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onImage)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('h:mm a').format(message.timestamp),
                    style: TextStyle(fontSize: 10, color: timeColor)),
                if (isSent) ...[
                  const SizedBox(width: 3),
                  Icon(Icons.done_all, size: 12, color: timeColor),
                ],
              ],
            ),
          )
        else ...[
          Text(DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(fontSize: 10, color: timeColor)),
          if (isSent) ...[
            const SizedBox(width: 4),
            Icon(Icons.done_all, size: 14, color: timeColor),
          ],
        ],
      ],
    );
  }
}
