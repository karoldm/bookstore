import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/ui/_core/theme/app_fonts.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/image_field_widget.dart';
import 'package:mybookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';
import 'package:mybookstore/ui/books/widgets/select_card_widget.dart';

class BookFormScreen extends StatefulWidget {
  final int storeId;
  final BookModel? initialBook;
  const BookFormScreen({super.key, required this.storeId, this.initialBook});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _index = 0;

  final RequestBookModel bookModel = RequestBookModel.empty();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialBook != null) {
      _titleController.text = widget.initialBook!.title;
      _authorController.text = widget.initialBook!.author;
      _synopsisController.text = widget.initialBook!.synopsis;
      _yearController.text = widget.initialBook!.year.toString();
      _ratingController.text = widget.initialBook!.rating.toString();

      bookModel.title = widget.initialBook!.title;
      bookModel.author = widget.initialBook!.author;
      bookModel.synopsis = widget.initialBook!.synopsis;
      bookModel.year = widget.initialBook!.year;
      bookModel.rating = widget.initialBook!.rating;
      bookModel.available = widget.initialBook!.available;
      bookModel.cover = widget.initialBook!.cover;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksBloc, BooksStates>(
      listener: (context, state) {
        if (state is BookCreateErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erro ao cadastrar livro")));
        } else if (state is BookCreateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Livro cadastrado com sucesso!")),
          );

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 32,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SelectCardWidget(
                                isSelected: _index == 0,
                                title: 'Dados do livro',
                                onTap: () {
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
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 16,
                                children: [
                                  if (_index == 0) ...[
                                    TextFieldWidget(
                                      controller: _titleController,
                                      hint: "Título",
                                      onChanged: (value) {
                                        setState(() {
                                          bookModel.title = value;
                                        });
                                      },
                                    ),
                                    TextFieldWidget(
                                      controller: _authorController,
                                      hint: "Autor",
                                      onChanged: (value) {
                                        setState(() {
                                          bookModel.author = value;
                                        });
                                      },
                                    ),
                                    TextFieldWidget(
                                      controller: _synopsisController,
                                      hint: "Sinópse",
                                      maxLines: 3,
                                      onChanged: (value) {
                                        setState(() {
                                          bookModel.synopsis = value;
                                        });
                                      },
                                    ),
                                    TextFieldWidget(
                                      controller: _yearController,
                                      digitsOnly: true,
                                      hint: "Ano de publicação",
                                      validator: (value) {
                                        if (int.tryParse(value) == null) {
                                          return "Somente números";
                                        }
                                        if (int.parse(value) < 0) {
                                          return "Ano inválido";
                                        }
                                        if (int.parse(value) >
                                            DateTime.now().year) {
                                          return "Ano inválido";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.isEmpty) {
                                            bookModel.year = 0;
                                          } else {
                                            bookModel.year = int.parse(value);
                                          }
                                        });
                                      },
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
                                          rating: bookModel.rating,
                                          onRatingChanged: (value) {
                                            _ratingController.text =
                                                value.toString();
                                            setState(() {
                                              bookModel.rating = value;
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
                                              value: bookModel.available,
                                              onChanged: (value) {
                                                setState(() {
                                                  bookModel.available = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              bookModel.available
                                                  ? "Estoque"
                                                  : "Sem estoque",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            Column(
                              spacing: 6,
                              children: [
                                ImageFieldWidget(
                                  hint: "Capa do livro",
                                  onChanged: ({required String imageBase64}) {
                                    setState(() {
                                      bookModel.cover = imageBase64;
                                    });
                                  },
                                ),
                                Text(
                                  "Tamanho máximo:  124 X 176. Formato: PNG, JPEG",
                                  style: AppFonts.bodySmallMediumFont,
                                ),
                              ],
                            ),
                          ],
                        ),
                        LoadingButtonWidget(
                          isLoading: state is BooksLoadingState,
                          child: Text("Salvar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.initialBook != null) {
                                BlocProvider.of<BooksBloc>(context).add(
                                  UpdateBookEvent(
                                    storeId: widget.storeId,
                                    bookId: widget.initialBook!.id,
                                    book: bookModel,
                                  ),
                                );
                              } else {
                                BlocProvider.of<BooksBloc>(context).add(
                                  AddBookEvent(
                                    storeId: widget.storeId,
                                    book: bookModel,
                                  ),
                                );
                              }
                            }
                          },
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
