import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatefulWidget {
  final String transcription;
  final bool isEditable;
  final Function(String) onTranscriptionChanged;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcription,
    required this.isEditable,
    required this.onTranscriptionChanged,
  }) : super(key: key);

  @override
  State<TranscriptionDisplayWidget> createState() =>
      _TranscriptionDisplayWidgetState();
}

class _TranscriptionDisplayWidgetState
    extends State<TranscriptionDisplayWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.transcription);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(TranscriptionDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transcription != oldWidget.transcription) {
      _controller.text = widget.transcription;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 15.h,
        maxHeight: 25.h,
      ),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'text_fields',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Transcripción',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.isEditable)
                CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: widget.isEditable
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Describe la joya que deseas crear...',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onTranscriptionChanged,
                  )
                : SingleChildScrollView(
                    child: Text(
                      widget.transcription.isEmpty
                          ? 'Mantén presionado el botón de grabación para comenzar...'
                          : widget.transcription,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: widget.transcription.isEmpty
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
