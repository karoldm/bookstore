import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
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
  const BookFormScreen({super.key, required this.storeId});

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
  Widget build(BuildContext context) {
    return BlocListener<BooksBloc, BooksStates>(
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
      child: Scaffold(
        appBar: appBarWidget(context: context, title: "Cadastrar Livro"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              onChanged: (value) {
                                setState(() {
                                  bookModel.year = int.parse(value);
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Avaliação"),
                                RatingBarWidget(
                                  rating: bookModel.rating,
                                  onRatingChanged: (value) {
                                    _ratingController.text = value.toString();
                                    setState(() {
                                      bookModel.rating = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status"),
                                Switch(
                                  value: bookModel.available,
                                  onChanged: (value) {
                                    setState(() {
                                      bookModel.available = value;
                                    });
                                  },
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
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.labelColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                LoadingButtonWidget(
                  isLoading: false,
                  child: Text("Salvar"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<BooksBloc>(context).add(
                        AddBookEvent(storeId: widget.storeId, book: bookModel),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
