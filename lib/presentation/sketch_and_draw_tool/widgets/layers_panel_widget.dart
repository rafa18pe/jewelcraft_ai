import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LayersPanelWidget extends StatefulWidget {
  final List<LayerData> layers;
  final int selectedLayerIndex;
  final Function(int) onLayerSelected;
  final Function(int) onLayerVisibilityToggled;
  final Function(int, double) onLayerOpacityChanged;
  final VoidCallback onAddLayer;
  final Function(int) onDeleteLayer;
  final Function(int, int) onReorderLayers;

  const LayersPanelWidget({
    Key? key,
    required this.layers,
    required this.selectedLayerIndex,
    required this.onLayerSelected,
    required this.onLayerVisibilityToggled,
    required this.onLayerOpacityChanged,
    required this.onAddLayer,
    required this.onDeleteLayer,
    required this.onReorderLayers,
  }) : super(key: key);

  @override
  State<LayersPanelWidget> createState() => _LayersPanelWidgetState();
}

class _LayersPanelWidgetState extends State<LayersPanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capas',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onAddLayer,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        size: 20,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      tooltip: 'Agregar capa',
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Layers list
          Expanded(
            child: ReorderableListView.builder(
              itemCount: widget.layers.length,
              onReorder: widget.onReorderLayers,
              itemBuilder: (context, index) {
                final layer = widget.layers[index];
                final isSelected = index == widget.selectedLayerIndex;

                return Container(
                  key: ValueKey(layer.id),
                  margin:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline
                              .withOpacity(0.3),
                    ),
                  ),
                  child: ListTile(
                    onTap: () => widget.onLayerSelected(index),
                    leading: GestureDetector(
                      onTap: () => widget.onLayerVisibilityToggled(index),
                      child: CustomIconWidget(
                        iconName:
                            layer.isVisible ? 'visibility' : 'visibility_off',
                        size: 20,
                        color: layer.isVisible
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withOpacity(0.5),
                      ),
                    ),
                    title: Text(
                      layer.name,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opacidad: ${(layer.opacity * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Slider(
                          value: layer.opacity,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          onChanged: (value) =>
                              widget.onLayerOpacityChanged(index, value),
                        ),
                      ],
                    ),
                    trailing: widget.layers.length > 1
                        ? IconButton(
                            onPressed: () =>
                                _showDeleteConfirmation(context, index),
                            icon: CustomIconWidget(
                              iconName: 'delete',
                              size: 20,
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'drag_handle',
                            size: 20,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar capa',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar la capa "${widget.layers[index].name}"?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDeleteLayer(index);
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LayerData {
  final String id;
  final String name;
  final bool isVisible;
  final double opacity;

  LayerData({
    required this.id,
    required this.name,
    this.isVisible = true,
    this.opacity = 1.0,
  });

  LayerData copyWith({
    String? id,
    String? name,
    bool? isVisible,
    double? opacity,
  }) {
    return LayerData(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
    );
  }
}
