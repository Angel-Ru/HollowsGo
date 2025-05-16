import '../imports.dart';

class MultiSkinRewardDialog extends StatefulWidget {
  final List<Map<String, dynamic>> results;

  const MultiSkinRewardDialog({required this.results, super.key});

  @override
  State<MultiSkinRewardDialog> createState() => _MultiSkinRewardDialogState();
}

class _MultiSkinRewardDialogState extends State<MultiSkinRewardDialog> {
  int currentPage = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.results.length,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemBuilder: (context, index) {
                final result = widget.results[index];
                final skin = result['skin'] as Map<String, dynamic>?;
                final isDuplicate = result['jaTenia'] == true;

                return SkinRewardDialog(
                  skin: skin,
                  isDuplicate: isDuplicate,
                );
              },
            ),
            Positioned(
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.results.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index
                          ? Colors.orangeAccent
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
