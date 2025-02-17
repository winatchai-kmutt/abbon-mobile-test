// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ContactStateCopyWithGen on ContactState {
  ContactState copyWith({
    Status Function()? status,
    List<Contact> Function()? contacts,
    List<Contact> Function()? filteredContacts,
    String Function()? searchQuery,
    bool Function()? searchingMode,
    int Function()? currentPage,
    int Function()? searchingCurrentPage,
    int Function()? itemsPerPage,
    int Function()? totalPages,
  }) {
    return ContactState(
      status: status != null ? status() : this.status,
      contacts: contacts != null ? contacts() : this.contacts,
      filteredContacts:
          filteredContacts != null ? filteredContacts() : this.filteredContacts,
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      searchingMode:
          searchingMode != null ? searchingMode() : this.searchingMode,
      currentPage: currentPage != null ? currentPage() : this.currentPage,
      searchingCurrentPage: searchingCurrentPage != null
          ? searchingCurrentPage()
          : this.searchingCurrentPage,
      itemsPerPage: itemsPerPage != null ? itemsPerPage() : this.itemsPerPage,
      totalPages: totalPages != null ? totalPages() : this.totalPages,
    );
  }
}
