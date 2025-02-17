import 'package:abbon_mobile_test/blocs/contact_bloc.dart';
import 'package:abbon_mobile_test/utils/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.contactsPage.tr(context: context)),
      ),
      body: Column(
        children: [
          SearchBar(),
          ContactList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactDialog(context);
        },
        child: Icon(Icons.add_outlined),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    int age = 0;

    String? ageValidator(String? value) {
      if (value == null || value.isEmpty) {
        return LocaleKeys.pleaseEnterAge.tr();
      }
      if (int.tryParse(value) == null) {
        return LocaleKeys.pleaseEnterAValidNumber.tr();
      }
      return null;
    }

    String? nameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return LocaleKeys.pleaseEnterName.tr();
      }
      return null;
    }

    void onSavedName(String? value) {
      name = value!;
    }

    void onSaveAge(String? value) {
      age = int.parse(value!);
    }

    void onTapSubmit() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        context.read<ContactBloc>().add(
              AddContactEvent(name, age),
            );
        context.pop();
      }
    }

    showDialog(
      context: context,
      builder: (dialobContext) {
        return AlertDialog(
          title: Text(LocaleKeys.addNewContact.tr()),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
                  validator: nameValidator,
                  onSaved: onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: LocaleKeys.age.tr()),
                  keyboardType: TextInputType.number,
                  validator: ageValidator,
                  onSaved: onSaveAge,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: onTapSubmit,
              child: Text(LocaleKeys.submit.tr()),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
          ],
        );
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController searchController;
  bool enableSuffixIcon = false;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: LocaleKeys.search.tr(),
          suffixIcon: Visibility(
            visible: enableSuffixIcon,
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                FocusScope.of(context).unfocus();
                setState(() {
                  enableSuffixIcon = false;
                });
                context.read<ContactBloc>().add(ClearSearchEvent());
              },
            ),
          ),
        ),
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          setState(() {
            enableSuffixIcon = false;
          });
        },
        onTap: () {
          setState(() {
            enableSuffixIcon = true;
          });
        },
        onChanged: (value) {
          context.read<ContactBloc>().add(SearchContactEvent(value));
        },
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});
  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    context.read<ContactBloc>().add(LoadContactEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (BuildContext context, state) {},
      builder: (context, state) {
        if (state.status == Status.loaded) {
          final contacts =
              state.searchingMode ? state.filteredContacts : state.contacts;
          final currentPage = state.searchingMode
              ? state.searchingCurrentPage
              : state.currentPage;
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        title: Text(contact.name),
                        subtitle: Text(
                          LocaleKeys.ageAndNumber.tr(
                            args: [contact.age.toString()],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<ContactBloc>().add(
                                  DeleteContactEvent(contact.id),
                                );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: currentPage > 0
                            ? () {
                                context.read<ContactBloc>().add(ChangePageEvent(
                                      currentPage - 1,
                                    ));
                              }
                            : null,
                      ),
                      Text(
                        LocaleKeys.page.tr(
                          args: [
                            '${currentPage + 1}',
                            '${state.totalPages}',
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: currentPage < state.totalPages - 1
                            ? () {
                                context
                                    .read<ContactBloc>()
                                    .add(ChangePageEvent(currentPage + 1));
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
