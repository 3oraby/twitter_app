import 'package:flutter/material.dart';
import 'dart:io';

class CustomImageLoader extends StatefulWidget {
  final dynamic imageSource;
  final double height;
  final double width;
  final BoxFit fit;
  final Widget? loadingWidget; 
  final Widget? errorWidget; 
  
  const CustomImageLoader({
    super.key,
    required this.imageSource,
    this.height = 200,
    this.width = 200,
    this.fit = BoxFit.cover,
    this.loadingWidget, 
    this.errorWidget,
  });

  @override
  State<CustomImageLoader> createState() => _CustomImageLoaderState();
}

class _CustomImageLoaderState extends State<CustomImageLoader> {
  bool _isLoading = true; 

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Builder(
        builder: (context) {
          if (widget.imageSource is String &&
              Uri.tryParse(widget.imageSource)?.isAbsolute == true) {
            return _buildNetworkImage(context);
          } else if (widget.imageSource is String) {
            return _buildAssetImage(context);
          } else if (widget.imageSource is File) {
            return _buildFileImage(context);
          } else {
            return _buildErrorWidget();
          }
        },
      ),
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Image.network(
        widget.imageSource,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            setState(() {
              _isLoading = false;
            });
            return child;
          } else {
            return _isLoading
                ? (widget.loadingWidget ??
                    const Center(
                      child: CircularProgressIndicator(),
                    )) 
                : child;
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? _buildErrorPlaceholder();
        },
      ),
    );
  }

  Widget _buildFileImage(BuildContext context) {
    return FutureBuilder<File>(
      future: _loadFileImage(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: widget.loadingWidget ??
                const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Error while loading file
          return widget.errorWidget ?? _buildErrorPlaceholder();
        } else if (snapshot.hasData) {
          // File loaded successfully
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: Image.file(
              snapshot.data!,
              fit: widget.fit,
            ),
          );
        } else {
          // Fallback error widget
          return widget.errorWidget ?? _buildErrorPlaceholder();
        }
      },
    );
  }

  Widget _buildAssetImage(BuildContext context) {
    return FutureBuilder(
      future: _loadAssetImage(), // Simulate asset loading
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: widget.loadingWidget ??
                const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return widget.errorWidget ?? _buildErrorPlaceholder();
        } else {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: Image.asset(
              widget.imageSource,
              fit: widget.fit,
            ),
          );
        }
      },
    );
  }

  Future<File> _loadFileImage() async {
    await Future.delayed(const Duration(seconds: 2));
    return File(widget.imageSource.path); 
  }

  Future<void> _loadAssetImage() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ?? _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Container(
        color: Colors.grey[300],
        child: Icon(Icons.error, color: Colors.red, size: widget.height * 0.4),
      ),
    );
  }
}
