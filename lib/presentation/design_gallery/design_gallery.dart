import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/context_menu_widget.dart';
import './widgets/design_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/trending_carousel_widget.dart';

class DesignGallery extends StatefulWidget {
  const DesignGallery({Key? key}) : super(key: key);

  @override
  State<DesignGallery> createState() => _DesignGalleryState();
}

class _DesignGalleryState extends State<DesignGallery>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Todos';
  String _searchQuery = '';
  bool _showCommunity = false;
  Map<String, dynamic>? _selectedDesign;

  final List<String> _filters = [
    'Todos',
    'Anillos',
    'Collares',
    'Aretes',
    'Pulseras'
  ];

  // Mock data for personal designs
  final List<Map<String, dynamic>> _personalDesigns = [
    {
      "id": 1,
      "title": "Anillo de Compromiso Clásico",
      "imageUrl":
          "https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&h=400&fit=crop",
      "date": "15/08/2024",
      "badges": ["3D Listo"],
      "category": "Anillos",
      "aspectRatio": 1.0,
    },
    {
      "id": 2,
      "title": "Collar de Perlas Elegante",
      "imageUrl":
          "https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&h=600&fit=crop",
      "date": "12/08/2024",
      "badges": ["En Progreso"],
      "category": "Collares",
      "aspectRatio": 0.8,
    },
    {
      "id": 3,
      "title": "Aretes de Diamante",
      "imageUrl":
          "https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400&h=400&fit=crop",
      "date": "10/08/2024",
      "badges": ["3D Listo", "Favorito"],
      "category": "Aretes",
      "aspectRatio": 1.2,
    },
    {
      "id": 4,
      "title": "Pulsera de Oro Rosa",
      "imageUrl":
          "https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=600&h=400&fit=crop",
      "date": "08/08/2024",
      "badges": ["Borrador"],
      "category": "Pulseras",
      "aspectRatio": 1.5,
    },
    {
      "id": 5,
      "title": "Anillo de Esmeralda Vintage",
      "imageUrl":
          "https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=400&h=400&fit=crop",
      "date": "05/08/2024",
      "badges": ["3D Listo"],
      "category": "Anillos",
      "aspectRatio": 1.0,
    },
    {
      "id": 6,
      "title": "Collar Minimalista",
      "imageUrl":
          "https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&h=600&fit=crop",
      "date": "03/08/2024",
      "badges": ["En Progreso"],
      "category": "Collares",
      "aspectRatio": 0.7,
    },
  ];

  // Mock data for trending designs
  final List<Map<String, dynamic>> _trendingDesigns = [
    {
      "id": 101,
      "title": "Anillo Geométrico Moderno",
      "imageUrl":
          "https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=400&h=400&fit=crop",
      "author": "María González",
      "likes": 245,
    },
    {
      "id": 102,
      "title": "Collar de Cadena Artística",
      "imageUrl":
          "https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=400&h=600&fit=crop",
      "author": "Carlos Ruiz",
      "likes": 189,
    },
    {
      "id": 103,
      "title": "Aretes Colgantes Elegantes",
      "imageUrl":
          "https://images.unsplash.com/photo-1588444837495-c6cfeb53f32d?w=400&h=400&fit=crop",
      "author": "Ana López",
      "likes": 156,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDesigns {
    List<Map<String, dynamic>> filtered = _personalDesigns;

    // Apply category filter
    if (_selectedFilter != 'Todos') {
      filtered = filtered
          .where((design) => design['category'] == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((design) => (design['title'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Búsqueda por voz activada')),
    );
  }

  void _onDesignTap(Map<String, dynamic> design) {
    // Navigate to design detail view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abriendo ${design['title']}')),
    );
  }

  void _onDesignLongPress(Map<String, dynamic> design) {
    setState(() {
      _selectedDesign = design;
    });
    _showContextMenu(design);
  }

  void _showContextMenu(Map<String, dynamic> design) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.all(4.w),
        child: ContextMenuWidget(
          design: design,
          onActionSelected: _onContextMenuAction,
        ),
      ),
    );
  }

  void _onContextMenuAction(String action) {
    Navigator.pop(context); // Close bottom sheet

    switch (action) {
      case 'edit':
        Navigator.pushNamed(context, '/sketch-and-draw-tool');
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diseño duplicado')),
        );
        break;
      case 'share':
        Navigator.pushNamed(context, '/stl-export-and-sharing');
        break;
      case 'favorite':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agregado a favoritos')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Diseño'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este diseño? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diseño eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.errorDark
                  : AppTheme.errorLight,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Galería actualizada')),
    );
  }

  void _onTrendingDesignTap(Map<String, dynamic> design) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viendo diseño de ${design['author']}')),
    );
  }

  void _navigateToCreateDesign() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.surfaceDark
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Crear Nuevo Diseño',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'text_fields',
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryDark
                    : AppTheme.primaryLight,
                size: 24,
              ),
              title: const Text('Texto a Joyería'),
              subtitle: const Text('Describe tu diseño con palabras'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ai-text-to-jewelry');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'mic',
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryDark
                    : AppTheme.primaryLight,
                size: 24,
              ),
              title: const Text('Voz a Joyería'),
              subtitle: const Text('Describe tu diseño hablando'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/voice-to-jewelry');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'draw',
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryDark
                    : AppTheme.primaryLight,
                size: 24,
              ),
              title: const Text('Dibujar y Bosquejar'),
              subtitle: const Text('Crea tu diseño dibujando'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sketch-and-draw-tool');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Galería de Diseños',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/3d-model-viewer'),
            icon: CustomIconWidget(
              iconName: 'view_in_ar',
              color: isDarkMode
                  ? AppTheme.textPrimaryDark
                  : AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export':
                  Navigator.pushNamed(context, '/stl-export-and-sharing');
                  break;
                case 'settings':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Exportar Lote'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Configuración'),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: isDarkMode
                  ? AppTheme.textPrimaryDark
                  : AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Galería'),
            Tab(text: 'Comunidad'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Personal Gallery Tab
          Column(
            children: [
              // Search bar
              SearchBarWidget(
                onSearchChanged: _onSearchChanged,
                onVoiceSearch: _onVoiceSearch,
              ),

              // Filter chips
              FilterChipsWidget(
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterSelected: _onFilterSelected,
              ),

              SizedBox(height: 1.h),

              // Designs grid
              Expanded(
                child: _filteredDesigns.isEmpty
                    ? EmptyStateWidget(
                        title: _searchQuery.isNotEmpty
                            ? 'Sin Resultados'
                            : 'Sin Diseños',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'No se encontraron diseños que coincidan con tu búsqueda'
                            : 'Comienza creando tu primer diseño de joyería',
                        buttonText: 'Crear Diseño',
                        onButtonPressed: _navigateToCreateDesign,
                        iconName: _searchQuery.isNotEmpty
                            ? 'search_off'
                            : 'design_services',
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 2.w,
                                  mainAxisSpacing: 2.w,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final design = _filteredDesigns[index];
                                    return DesignCardWidget(
                                      design: design,
                                      onTap: () => _onDesignTap(design),
                                      onLongPress: () =>
                                          _onDesignLongPress(design),
                                    );
                                  },
                                  childCount: _filteredDesigns.length,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(height: 10.h),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),

          // Community Tab
          Column(
            children: [
              // Community toggle
              Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: (isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'public',
                      color: isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Explorar diseños de la comunidad',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                      ),
                    ),
                    Switch(
                      value: _showCommunity,
                      onChanged: (value) {
                        setState(() {
                          _showCommunity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              if (_showCommunity) ...[
                // Trending carousel
                TrendingCarouselWidget(
                  trendingDesigns: _trendingDesigns,
                  onDesignTap: _onTrendingDesignTap,
                ),

                SizedBox(height: 2.h),

                // Community designs placeholder
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'groups',
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Más diseños de la comunidad\npronto disponibles',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                Expanded(
                  child: EmptyStateWidget(
                    title: 'Comunidad Deshabilitada',
                    subtitle:
                        'Activa el interruptor para explorar diseños de otros usuarios',
                    buttonText: 'Explorar Plantillas',
                    onButtonPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navegando a plantillas')),
                      );
                    },
                    iconName: 'toggle_off',
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateDesign,
        icon: CustomIconWidget(
          iconName: 'add',
          color: isDarkMode ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
          size: 24,
        ),
        label: Text(
          'Crear',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isDarkMode
                    ? AppTheme.onPrimaryDark
                    : AppTheme.onPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor:
            isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
      ),
    );
  }
}
