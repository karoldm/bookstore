import 'dart:typed_data';
import 'dart:ui';

import 'package:bookstore/ui/_core/widgets/custom_cached_image_network.dart';
import 'package:bookstore/ui/_core/widgets/error_image_placeholder.dart';
import 'package:bookstore/ui/books/widgets/color_picker_widget.dart';
import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/data/models/request_book_model.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:bookstore/ui/books/widgets/select_card_widget.dart';
import 'package:image_picker/image_picker.dart';

class BookFormScreen extends StatefulWidget {
  final int storeId;
  final BookModel? initialBook;
  const BookFormScreen({super.key, required this.storeId, this.initialBook});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _boundaryKey = GlobalKey();
  int _index = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _releasedAtController = TextEditingController();
  int _rating = 1;
  bool _available = false;
  Uint8List? _coverImage;
  Color _coverColor = Colors.black;

  bool _editCover = false;
  XFile? imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialBook != null) {
      _titleController.text = widget.initialBook!.title;
      _authorController.text = widget.initialBook!.author;
      _summaryController.text = widget.initialBook!.summary;
      _releasedAtController.text = widget.initialBook!.releasedAt;
      _rating = widget.initialBook!.rating;
      _available = widget.initialBook!.available;
    }
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      firstDate: DateTime(0),
      context: context,
      initialDate: now,
      lastDate: now,
    );

    if (pickedDate != null) {
      final month = pickedDate.month;
      final day = pickedDate.day;
      setState(() {
        _releasedAtController.text =
            "${day < 10 ? '0$day' : day}/${month < 10 ? '0$month' : month}/${pickedDate.year}";
      });
    }
  }

  Future<XFile?> _captureCoverImage() async {
    try {
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final image = await boundary.toImage(
        pixelRatio:
            MediaQuery.of(_boundaryKey.currentContext!).devicePixelRatio,
      );

      final byteData = await image.toByteData(format: ImageByteFormat.png);

      return byteData != null
          ? XFile.fromData(
            byteData.buffer.asUint8List(),
            name: "cover.png",
            mimeType: "image/png",
          )
          : null;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }

  void _onSave(RequestBookModel book) {
    BlocProvider.of<BooksBloc>(
      context,
    ).add(AddBookEvent(storeId: widget.storeId, book: book));
  }

  void _onUpdate(RequestBookModel book) {
    BlocProvider.of<BooksBloc>(context).add(
      UpdateBookEvent(
        storeId: widget.storeId,
        bookId: widget.initialBook!.id,
        book: book,
      ),
    );
  }

  void _onSubmit() async {
    if (_releasedAtController.text.isEmpty) {
      showCustomDialog(context, "Insira uma data de publicação válida.");
      return;
    }
    final RequestBookModel bookModel = RequestBookModel.empty();

    bookModel.title = _titleController.text;
    bookModel.author = _authorController.text;
    bookModel.summary = _summaryController.text;
    bookModel.releasedAt = _releasedAtController.text;
    bookModel.rating = _rating;
    bookModel.available = _available;

    bookModel.cover =
        (widget.initialBook != null
            ? (_editCover ? imageBytes : null)
            : imageBytes);

    if (widget.initialBook != null) {
      _onUpdate(bookModel);
    } else {
      _onSave(bookModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksBloc, BooksStates>(
      listener: (context, state) {
        if (state is BookCreateErrorState) {
          showCustomDialog(
            context,
            "Erro ao cadastrar livro: ${state.message}",
          );
        } else if (state is BookCreateSuccessState) {
          showCustomDialog(context, "Livro cadastrado com sucesso!");

          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context: context, title: "Cadastrar Livro"),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SelectCardWidget(
                                isSelected: _index == 0,
                                title: 'Dados do livro',
                                onTap: () {
                                  _captureCoverImage().then((value) {
                                    imageBytes = value;
                                  });
                                  setState(() => _index = 0);
                                },
                              ),
                            ),
                            Expanded(
                              child: SelectCardWidget(
                                isSelected: _index == 1,
                                title: 'Design do livro',
                                onTap: () {
                                  setState(() => _index = 1);
                                },
                              ),
                            ),
                          ],
                        ),
                        IndexedStack(
                          index: _index,
                          alignment: Alignment.topCenter,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16,
                                children: [
                                  if (_index == 0) ...[
                                    TextFieldWidget(
                                      controller: _titleController,
                                      hint: "Título",
                                    ),
                                    TextFieldWidget(
                                      controller: _authorController,
                                      hint: "Autor",
                                    ),
                                    TextFieldWidget(
                                      maxLength: 255,
                                      controller: _summaryController,
                                      hint: "Sinópse",
                                      maxLines: 3,
                                    ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        await _selectDate();
                                      },
                                      child: Text(
                                        _releasedAtController.text.isEmpty
                                            ? "Data de publicação"
                                            : _releasedAtController.text,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Avaliação",
                                          style: AppFonts.bodySmallMediumFont,
                                        ),
                                        RatingBarWidget(
                                          rating: _rating,
                                          onRatingChanged: (value) {
                                            setState(() {
                                              _rating = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Status",
                                          style: AppFonts.bodySmallMediumFont,
                                        ),
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Switch(
                                              value: _available,
                                              onChanged: (value) {
                                                setState(() {
                                                  _available = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              _available
                                                  ? "Estoque"
                                                  : "Sem estoque",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  LoadingButtonWidget(
                                    isLoading: state is BooksLoadingState,
                                    child: Text("Salvar"),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _onSubmit();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 24,
                              children:
                                  (widget.initialBook != null &&
                                          _editCover == false)
                                      ? ([
                                        (widget.initialBook!.cover != null &&
                                                widget.initialBook!.cover != "")
                                            ? CustomCachedNetworkImage(
                                              imageUrl:
                                                  widget.initialBook!.cover!,
                                            )
                                            : Image.asset(
                                              "assets/book_default.png",
                                              fit: BoxFit.cover,
                                            ),
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              _editCover = true;
                                            });
                                          },
                                          child: Text("Alterar capa"),
                                        ),
                                      ])
                                      : ([
                                        RepaintBoundary(
                                          key: _boundaryKey,
                                          child: SizedBox(
                                            height: 350,
                                            width: 250,
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    _coverColor,
                                                    BlendMode.srcIn,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/book_default.png',
                                                    fit: BoxFit.cover,
                                                    height: 360,
                                                    width: 320,
                                                  ),
                                                ),
                                                if (_coverImage != null)
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Image.memory(
                                                        _coverImage!,
                                                        fit: BoxFit.cover,
                                                        height: 240,
                                                        width: 200,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stack,
                                                            ) =>
                                                                const ErrorImagePlaceholder(),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ColorPickerWidget(
                                          onColorChanged: (color) {
                                            setState(() {
                                              _coverColor = color;
                                            });
                                          },
                                        ),
                                        Column(
                                          spacing: 6,
                                          children: [
                                            ImageFieldWidget(
                                              hint: "Capa do livro",
                                              onChanged: ({
                                                required XFile? imageData,
                                              }) async {
                                                final byteImage =
                                                    await imageData
                                                        ?.readAsBytes();
                                                setState(() {
                                                  _coverImage = byteImage;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        if (widget.initialBook != null)
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                _editCover = false;
                                              });
                                            },
                                            child: Text("Usar capa original"),
                                          ),
                                      ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
