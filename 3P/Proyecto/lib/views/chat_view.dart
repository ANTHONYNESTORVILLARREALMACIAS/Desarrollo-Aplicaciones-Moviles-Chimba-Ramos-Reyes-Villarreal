import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../models/search_result.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    // ✅ OPTIMIZADO: Mostrar app inmediatamente, sin esperar configuraciones
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.tealAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<SettingsViewModel>(
                builder: (context, settingsViewModel, child) {
                  return Text(
                    settingsViewModel.getText('appTitle'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          // Avatar del usuario
          if (authViewModel.currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Colors.tealAccent,
                child: Text(
                  authViewModel.currentUser!.initials,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, child) {
          return _buildDrawer(context, authViewModel, searchViewModel, settingsViewModel);
        },
      ),
      body: Column(
        children: [
          // Mostrar error si existe
          Consumer<SearchViewModel>(
            builder: (context, searchViewModel, child) {
              if (searchViewModel.errorMessage != null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          searchViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        onPressed: () => searchViewModel.clearError(),
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Área de mensajes
          Expanded(
            child:
                _messages.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessage(_messages[index], theme);
                      },
                    ),
          ),

          // Indicador de carga
          Consumer<SettingsViewModel>(
            builder: (context, settingsViewModel, child) {
              if (searchViewModel.isLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        settingsViewModel.getText('thinking'),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Input de texto
          _buildTextInput(theme, searchViewModel),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.tealAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                settingsViewModel.getText('hello'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                settingsViewModel.getText('subtitle'),
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSuggestionChip(settingsViewModel.getText('publicContracts')),
                  _buildSuggestionChip(settingsViewModel.getText('dataProtection')),
                  _buildSuggestionChip(settingsViewModel.getText('environmentalNorms')),
                  _buildSuggestionChip(settingsViewModel.getText('humanResources')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendMessage(text),
      backgroundColor: Colors.deepPurple.withOpacity(0.1),
    );
  }

  Widget _buildMessage(ChatMessage message, ThemeData theme) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, child) {
        final isUserMessage = message.isUser;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: isUserMessage 
                ? MainAxisAlignment.end      // Usuario a la derecha
                : MainAxisAlignment.start,   // IA a la izquierda
            children: [
              // Avatar de IA solo si NO es mensaje del usuario
              if (!isUserMessage) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              
              // Contenedor del mensaje
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75, // Máximo 75% del ancho
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUserMessage 
                        ? Colors.tealAccent.withOpacity(0.2)     // Verde para usuario
                        : theme.cardColor,                       // Gris para IA
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUserMessage 
                          ? const Radius.circular(16)       // Usuario: esquina izquierda redondeada
                          : const Radius.circular(4),       // IA: esquina izquierda cuadrada
                      bottomRight: isUserMessage 
                          ? const Radius.circular(4)        // Usuario: esquina derecha cuadrada
                          : const Radius.circular(16),      // IA: esquina derecha redondeada
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Etiqueta de quién escribió
                      Text(
                        isUserMessage ? settingsViewModel.getText('you') : settingsViewModel.getText('appTitle'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isUserMessage 
                              ? Colors.tealAccent.shade700
                              : theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Texto del mensaje
                      if (message.text != null)
                        Text(
                          message.text!,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      
                      // Mostrar resultados solo si es respuesta de IA
                      if (!isUserMessage && message.results != null) ...[
                        const SizedBox(height: 12),
                        ...message.results!.map((result) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildResultCard(result, theme, settingsViewModel),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Avatar del usuario solo si ES mensaje del usuario
              if (isUserMessage) ...[
                const SizedBox(width: 12),
                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, child) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          authViewModel.currentUser?.initials ?? 'U',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultCard(SearchResult result, ThemeData theme, SettingsViewModel settingsViewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, size: 16, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                result.documentId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Chip(
                label: Text(
                  '${settingsViewModel.getText('relevance')}: ${result.distance.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result.summary,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(ThemeData theme, SearchViewModel searchViewModel) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
                Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: InputDecoration(
                  hintText: settingsViewModel.getText('typeQuery'),
                  hintStyle: GoogleFonts.inter(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  ),
                  style: GoogleFonts.inter(),
                  onSubmitted: (value) => _sendMessage(value),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.tealAccent],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed:
                      searchViewModel.isLoading
                          ? null
                          : () => _sendMessage(_controller.text),
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AuthViewModel authViewModel,
    SearchViewModel searchViewModel,
    SettingsViewModel settingsViewModel,
  ) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.tealAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Text(
                      authViewModel.currentUser?.initials ?? 'U',
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    authViewModel.currentUser?.displayName ?? 'Usuario',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    authViewModel.currentUser?.email ?? '',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Menú con Google Fonts
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, size: 22),
                  title: Text(
                    settingsViewModel.getText('newConversation'),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _messages.clear();
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, size: 22),
                  title: Text(
                    settingsViewModel.getText('history'),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showHistoryModal(context, searchViewModel, settingsViewModel);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, size: 22),
                  title: Text(
                    settingsViewModel.getText('settings'),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsModal(context, settingsViewModel);
                  },
                ),
                const Divider(thickness: 1, height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 22,
                  ),
                  title: Text(
                    settingsViewModel.getText('logout'),
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  onTap: () async {
                    await authViewModel.logout();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final searchViewModel = Provider.of<SearchViewModel>(
      context,
      listen: false,
    );
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
    });

    _scrollToBottom();

    await searchViewModel.search(
      text,
      authViewModel.currentUser?.id ?? 'anonymous',
    );

    if (searchViewModel.errorMessage == null &&
        searchViewModel.results.isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                '${settingsViewModel.getText('foundResults')} ${searchViewModel.results.length} ${settingsViewModel.getText('relevantDocuments')}',
            isUser: false,
            results: searchViewModel.results,
          ),
        );
      });
    } else if (searchViewModel.errorMessage != null) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                '${settingsViewModel.getText('errorOccurred')} ${searchViewModel.errorMessage}',
            isUser: false,
          ),
        );
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showHistoryModal(
    BuildContext context,
    SearchViewModel searchViewModel,
    SettingsViewModel settingsViewModel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                settingsViewModel.getText('queryHistory'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    searchViewModel.history.isEmpty
                        ? Center(
                          child: Text(
                            settingsViewModel.getText('noSearches'),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: searchViewModel.history.length,
                          itemBuilder: (context, index) {
                            final history = searchViewModel.history[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(history.query),
                              subtitle: Text(
                                '${history.resultsCount} ${settingsViewModel.getText('results')}',
                              ),
                              trailing: Text(
                                '${history.timestamp.day}/${history.timestamp.month}',
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _sendMessage(history.query);
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsModal(BuildContext context, SettingsViewModel settingsViewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                settingsViewModel.getText('settings'),
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(
                  settingsViewModel.getText('darkTheme'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Switch(
                  value: settingsViewModel.isDarkMode,
                  onChanged: (value) {
                    settingsViewModel.toggleTheme();
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  settingsViewModel.getText('language'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  settingsViewModel.languageCode == 'es' 
                      ? settingsViewModel.getText('spanish')
                      : settingsViewModel.getText('english'),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                onTap: () {
                  _showLanguageDialog(context, settingsViewModel);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(
                  settingsViewModel.getText('about'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context, settingsViewModel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsViewModel settingsViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            settingsViewModel.getText('selectLanguage'),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                title: Text(
                  settingsViewModel.getText('spanish'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: settingsViewModel.languageCode == 'es' 
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  settingsViewModel.setLanguage('es');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: Text(
                  settingsViewModel.getText('english'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: settingsViewModel.languageCode == 'en' 
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  settingsViewModel.setLanguage('en');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, SettingsViewModel settingsViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.tealAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  settingsViewModel.getText('appTitle'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settingsViewModel.getText('version'),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                settingsViewModel.getText('description'),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                settingsViewModel.getText('close'),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChatMessage {
  final String? text;
  final bool isUser;
  final List<SearchResult>? results;
  final DateTime timestamp;

  ChatMessage({
    this.text, 
    required this.isUser, 
    this.results,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
