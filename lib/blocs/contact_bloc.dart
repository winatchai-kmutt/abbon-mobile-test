import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:copy_with/copy_with.dart';
import 'package:uuid/uuid.dart';

part 'contact_bloc.g.dart';

class Contact extends Equatable {
  final String id;
  final String name;
  final int age;

  const Contact({
    required this.id,
    required this.name,
    required this.age,
  });

  @override
  List<Object> get props => [id, name, age];
}

// Events
abstract class ContactEvent extends Equatable {
  const ContactEvent();
  @override
  List<Object> get props => [];
}

class LoadContactEvent extends ContactEvent {
  @override
  List<Object> get props => [];
}

class AddContactEvent extends ContactEvent {
  final String name;
  final int age;
  const AddContactEvent(this.name, this.age);
  @override
  List<Object> get props => [name, age];
}

class DeleteContactEvent extends ContactEvent {
  final String id;
  const DeleteContactEvent(this.id);
  @override
  List<Object> get props => [id];
}

class SearchContactEvent extends ContactEvent {
  final String query;
  const SearchContactEvent(this.query);
  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends ContactEvent {}

class ChangePageEvent extends ContactEvent {
  final int page;
  const ChangePageEvent(this.page);
  @override
  List<Object> get props => [page];
}

enum Status {
  initial,
  loading,
  loaded,
  failed,
}

// States
@CopyWith()
class ContactState extends Equatable {
  final Status status;
  final List<Contact> contacts;
  final List<Contact> filteredContacts;
  final String searchQuery;
  final bool searchingMode;
  final int currentPage;
  final int searchingCurrentPage;
  final int itemsPerPage;
  final int totalPages;

  const ContactState({
    this.status = Status.initial,
    this.contacts = const [],
    this.filteredContacts = const [],
    this.searchQuery = '',
    this.searchingMode = false,
    this.currentPage = 0,
    this.searchingCurrentPage = 0,
    this.itemsPerPage = 20,
    this.totalPages = 0,
  });

  @override
  List<Object> get props => [
        status,
        contacts,
        filteredContacts,
        searchQuery,
        searchingMode,
        currentPage,
        searchingCurrentPage,
        itemsPerPage,
        totalPages,
      ];
}

// BLoC
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final Uuid uuid = Uuid();
  List<Contact> _contacts = [];
  List<Contact> _searchingContact = [];

  ContactBloc() : super(const ContactState()) {
    on<LoadContactEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<SearchContactEvent>(_onSearchContact);
    on<ClearSearchEvent>(_onClearSearch);
    on<ChangePageEvent>(_onChangePage);
  }

  void _onLoadContacts(LoadContactEvent event, Emitter<ContactState> emit) {
    emit(ContactState(
      status: Status.loading,
    ));
    _contacts = _generateMockContacts(99);
    final totalPages = (_contacts.length / state.itemsPerPage).ceil();

    emit(state.copyWith(
      status: () => Status.loaded,
      contacts: () => _getPaginatedContacts(
        contacts: _contacts,
        currentPage: state.currentPage,
        itemsPerPage: state.itemsPerPage,
      ),
      totalPages: () => totalPages,
    ));
  }

  void _onAddContact(AddContactEvent event, Emitter<ContactState> emit) {
    _contacts.insert(
      0,
      Contact(
        id: uuid.v4(),
        name: event.name,
        age: event.age,
      ),
    );

    final updatedFilterContacts = _filterContacts(contacts: _contacts);
    emit(state.copyWith(
      contacts: () => _getPaginatedContacts(
        contacts: _contacts,
        currentPage: state.currentPage,
        itemsPerPage: state.itemsPerPage,
      ),
      filteredContacts: () => _getPaginatedContacts(
        contacts: updatedFilterContacts,
        currentPage: state.searchingCurrentPage,
        itemsPerPage: state.itemsPerPage,
      ),
    ));
  }

  void _onDeleteContact(DeleteContactEvent event, Emitter<ContactState> emit) {
    _contacts.removeWhere((contact) => contact.id == event.id);
    final updatedFilterContacts = _filterContacts(contacts: _contacts);

    emit(state.copyWith(
      contacts: () => _getPaginatedContacts(
        contacts: _contacts,
        currentPage: state.currentPage,
        itemsPerPage: state.itemsPerPage,
      ),
      filteredContacts: () => _getPaginatedContacts(
        contacts: updatedFilterContacts,
        currentPage: state.searchingCurrentPage,
        itemsPerPage: state.itemsPerPage,
      ),
    ));
  }

  void _onSearchContact(SearchContactEvent event, Emitter<ContactState> emit) {
    final searchQuery = event.query;
    if (event.query.length >= 3) {
      _searchingContact = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
    } else {
      _searchingContact = _contacts;
    }

    final totalPages = (_searchingContact.length / state.itemsPerPage).ceil();

    emit(
      state.copyWith(
        filteredContacts: () => _getPaginatedContacts(
          contacts: _searchingContact,
          currentPage: state.searchingCurrentPage,
          itemsPerPage: state.itemsPerPage,
        ),
        searchQuery: () => searchQuery,
        totalPages: () => totalPages,
        searchingCurrentPage: () => 0,
        searchingMode: () => true,
      ),
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<ContactState> emit) {
    final totalPages = (_contacts.length / state.itemsPerPage).ceil();

    emit(
      state.copyWith(
        searchQuery: () => '',
        totalPages: () => totalPages,
        searchingCurrentPage: () => 0,
        searchingMode: () => false,
      ),
    );
  }

  void _onChangePage(ChangePageEvent event, Emitter<ContactState> emit) {
    if (state.searchingMode) {
      emit(state.copyWith(
        searchingCurrentPage: () => event.page,
        filteredContacts: () => _getPaginatedContacts(
          contacts: _searchingContact,
          currentPage: event.page,
          itemsPerPage: state.itemsPerPage,
        ),
      ));
    } else {
      emit(state.copyWith(
        currentPage: () => event.page,
        contacts: () => _getPaginatedContacts(
          contacts: _contacts,
          currentPage: event.page,
          itemsPerPage: state.itemsPerPage,
        ),
      ));
    }
  }

  List<Contact> _filterContacts({required List<Contact> contacts}) {
    if (state.searchQuery.isNotEmpty) {
      return contacts.where((contact) {
        return contact.name
            .toLowerCase()
            .contains(state.searchQuery.toLowerCase());
      }).toList();
    } else {
      return contacts;
    }
  }

  List<Contact> _getPaginatedContacts({
    required List<Contact> contacts,
    required int currentPage,
    required int itemsPerPage,
  }) {
    if (contacts.isEmpty) {
      return contacts;
    }
    if (contacts.length < 20) {
      return contacts;
    }

    final startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + state.itemsPerPage;
    if (endIndex >= contacts.length) {
      endIndex = contacts.length - 1;
    }
    return contacts.sublist(startIndex, endIndex);
  }

  List<Contact> _generateMockContacts(int count) {
    final List<Contact> mockContacts = [];
    final List<String> firstNames = [
      'John',
      'John',
      'John',
      'John',
      'John',
      'Diana',
      'Eva',
      'Frank',
      'Grace',
      'Henry'
    ];
    final List<String> lastNames = [
      'Doe',
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia',
      'Miller',
      'Davis',
      'Wilson'
    ];

    for (int i = 0; i < count; i++) {
      final String firstName = firstNames[i % firstNames.length] + i.toString();
      final String lastName = lastNames[i % lastNames.length] + i.toString();
      final int age = 20 + (i % 20);
      mockContacts.add(
        Contact(
          id: uuid.v4(),
          name: '$firstName $lastName',
          age: age,
        ),
      );
    }

    return mockContacts;
  }
}
