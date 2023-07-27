{{#add_multi_window}}
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';{{/add_multi_window}}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

{{#add_multi_window}}
Future<void> main(List<String> args) async {
  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    final arguments = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    await _configureMacosWindowUtils();
    runApp(
      AboutWindow(
        windowController: WindowController.fromWindowId(windowId),
        args: arguments,
      ));
  } else {
    await _configureMacosWindowUtils();
    runApp(const App());
  }
}
{{/add_multi_window}}
{{^add_multi_window}}
Future<void> main() async {
  await _configureMacosWindowUtils();
  runApp(const App());
}
{{/add_multi_window}}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: '{{ app_name }}',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MainView(),
      debugShowCheckedModeBanner: {{debug_label_on}},
    );
  }
}

{{#add_multi_window}}
class AboutWindow extends StatelessWidget {
  const AboutWindow({
    super.key,
    required this.windowController,
    required this.args,
  });

  final WindowController windowController;
  final Map? args;

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: '{{ app_name }}',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MacosWindow(
        child: MacosScaffold(
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About {{app_name}}',
                        style: MacosTheme.of(context).typography.largeTitle,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'This is a starter application generated by mason_cli.',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: {{debug_label_on}},
    );
  }
}
{{/add_multi_window}}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    {{#multi_window_no_system_menu}}
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) => SidebarItems(
          currentIndex: _pageIndex,
          onChanged: (index) {
            setState(() => _pageIndex = index);
          },
          items: const [
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.home),
              label: Text('Home'),
            ),
          ],
        ),
        bottom: MacosListTile(
          leading: const MacosIcon(CupertinoIcons.info_circle_fill),
          title: const Text('About'),
          onClick: () async {
          final windowController = await DesktopMultiWindow.createWindow(jsonEncode(
            {
              'args1': 'About {{app_name}}',
              'args2': 500,
              'args3': true,
            },
          ));
          debugPrint('$windowController');
          windowController
            ..setFrame(const Offset(0, 0) & const Size(350, 350))
            ..center()
            ..setTitle('About {{app_name}}')
            ..show();
          },
        ),
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: const [
          HomePage(),
        ],
      ),
    );
    {{/multi_window_no_system_menu}}
    {{^multi_window_no_system_menu}}
    {{#custom_system_menu_bar}}
    return PlatformMenuBar(
      menus: {{#custom_system_menu_bar}}{{#add_multi_window}}{{/add_multi_window}}{{^add_multi_window}}const{{/add_multi_window}}{{/custom_system_menu_bar}}[
        PlatformMenu(
          label: '{{app_name.pascalCase()}}',
          menus: [
            {{#add_multi_window}}
            PlatformMenuItem(
              label: 'About',
              onSelected: () async {
                final window = await DesktopMultiWindow.createWindow(jsonEncode(
                  {
                    'args1': 'About {{app_name}}',
                    'args2': 500,
                    'args3': true,
                  },
                ));
                debugPrint('$window');
                window
                  ..setFrame(const Offset(0, 0) & const Size(350, 350))
                  ..center()
                  ..setTitle('About {{app_name}}')
                  ..show();
              },
            ),
            {{/add_multi_window}}
            {{^add_multi_window}}
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            {{/add_multi_window}}
            {{#add_multi_window}}const{{/add_multi_window}} PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
      ],
      child: MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (context, scrollController) => SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() => _pageIndex = index);
            },
            items: const [
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.home),
                label: Text('Home'),
              ),
            ],
          ),
        ),
        child: IndexedStack(
          index: _pageIndex,
          children: const [
            HomePage(),
          ],
        ),
      ),
    );
    {{/custom_system_menu_bar}}
    {{^custom_system_menu_bar}}
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) => SidebarItems(
          currentIndex: _pageIndex,
          onChanged: (index) {
            setState(() => _pageIndex = index);
          },
          items: const [
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.home),
              label: Text('Home'),
            ),
          ],
        ),
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: const [
          HomePage(),
        ],
      ),
    );
    {{/custom_system_menu_bar}}
    {{/multi_window_no_system_menu}}
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
          leading: MacosTooltip(
            message: 'Toggle Sidebar',
            useMousePosition: false,
            child: MacosIconButton(
              icon: MacosIcon(
                CupertinoIcons.sidebar_left,
                color: MacosTheme.brightnessOf(context).resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: 20.0,
              ),
              boxConstraints: const BoxConstraints(
                minHeight: 20,
                minWidth: 20,
                maxWidth: 48,
                maxHeight: 38,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              ),
            ),
            title: const Text('Home'),
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return const Center(
                  child: Text('Home'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
