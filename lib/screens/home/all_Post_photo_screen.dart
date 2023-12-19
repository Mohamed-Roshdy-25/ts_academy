import 'package:cached_network_image/cached_network_image.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/stutent_posts.dart';
import '/constants/color_constants.dart';

class OpenImage extends StatefulWidget {
  const OpenImage({super.key, required this.imageUrl});

  final String imageUrl;
  @override
  State<OpenImage> createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder: (a, x) {
              return const Center(child: CircularProgressIndicator());
            },
            errorWidget: (a, b, c) => const Center(
                child: Icon(
              Icons.error,
              color: Colors.red,
            )),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        toolbarOpacity: .5,
        bottomOpacity: .5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class AllPostsPhoto extends StatefulWidget {
  const AllPostsPhoto(
      {Key? key, required this.postImagesCount, required this.postImages})
      : super(key: key);
  final int postImagesCount;
  final List<ImagePostModel> postImages;

  @override
  State<AllPostsPhoto> createState() => _AllPostsPhotoState();
}

class _AllPostsPhotoState extends State<AllPostsPhoto> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightBlue,
        title: Text(tr(StringConstants.allPostImages)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView.separated(
        itemCount: widget.postImages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OpenImage(
                          imageUrl: widget.postImages[index].imageUrl)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    // image: DecorationImage(
                    //     image: NetworkImage(widget.postImages[index].imageUrl),
                    //     fit: BoxFit.cover),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.postImages[index].imageUrl,
                    placeholder: (ctx, builder) {
                      return const SizedBox();
                    },
                    errorWidget: (a, b, c) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20,
          );
        },
      )),
    );
  }
}
