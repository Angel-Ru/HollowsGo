import '../imports.dart';
import '../service/audioservice.dart';

class PreHomeScreen extends StatefulWidget {
  @override
  _PreHomeScreenState createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<String> imagePaths = [/* ... */];

  late String randomBackground;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollControllerTop;
  late ScrollController _scrollControllerBottom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final random = Random();
    randomBackground = imagePaths[random.nextInt(imagePaths.length)];

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);

    _scrollControllerTop = ScrollController();
    _scrollControllerBottom = ScrollController();

    _startAutoScroll(_scrollControllerTop);
    _startAutoScroll(_scrollControllerBottom);

    /// 🔊 Nova crida unificada:
    AudioService.instance.playScreenMusic('prehome');

    Provider.of<DialogueProvider>(context, listen: false)
        .loadDialogueFromJson("ichigo");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _controller.dispose();
    _scrollControllerTop.dispose();
    _scrollControllerBottom.dispose();

    AudioService.instance.stop();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AudioService.instance.pause();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.instance.resume();
    }
  }

  void _startAutoScroll(ScrollController scrollController) {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 20));
      if (scrollController.hasClients) {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        if (currentScroll >= maxScroll) {
          scrollController.jumpTo(0);
        } else {
          scrollController.animateTo(
            currentScroll + 15,
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
      return true;
    });
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      await AudioService.instance.stop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () async {
          await AudioService.instance.pause();
          bool wentToHome = await _checkLogin();
          if (!wentToHome) {
            await _showLoginDialog(context);
            await AudioService.instance.resume();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                randomBackground,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  SizedBox(height: 70),
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          "CLICA A ON SIGUI PER COMENÇAR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 250),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 200),
                  Image.asset(
                    'lib/images/prehomescreen_images/HollowsGo_Remastered_LOGO.png',
                    width: 300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LoginScreen();
      },
    );

    if (result == true) {
      await AudioService.instance.stop();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } else {
      await AudioService.instance.resume();
    }
  }
}
