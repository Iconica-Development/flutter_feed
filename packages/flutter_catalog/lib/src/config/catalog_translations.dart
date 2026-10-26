/// A class that holds all the overridable translations for the catalog user
/// story.
class CatalogTranslations {
  /// Creates an instance of [CatalogTranslations].
  const CatalogTranslations({
    this.overviewTitle,
    this.searchHint,
    this.itemCreatePageTitle,
    this.itemEditPageTitle,
    this.itemCreatePageTitleHint,
    this.itemCreatePageDescriptionHint,
    this.itemCreatePageTitleRequiredError,
    this.itemCreatePageAddImagesButton,
    this.itemCreatePageSaveChangesButton,
    this.itemCreatePageSavingChangesButton,
    this.itemCreatePageDeleteItemButton,
    this.itemCreatePageDeleteConfirmationTitle,
    this.itemCreatePageDeleteConfirmationMessage,
    this.itemCreatePageDeleteConfirmationConfirm,
    this.itemCreatePageDeleteConfirmationCancel,
    this.itemCreatePageGenericError,
    this.itemCreatePageItemDeletedSuccess,
    this.itemCreatePageItemDeleteError,
  });

  /// Creates an empty instance of [CatalogTranslations] with all fields set to
  /// `null`. This is useful for providing default values in the consuming app.
  const CatalogTranslations.empty({
    this.overviewTitle,
    this.searchHint,
    this.itemCreatePageTitle,
    this.itemEditPageTitle,
    this.itemCreatePageTitleHint,
    this.itemCreatePageDescriptionHint,
    this.itemCreatePageTitleRequiredError,
    this.itemCreatePageAddImagesButton,
    this.itemCreatePageSaveChangesButton,
    this.itemCreatePageSavingChangesButton,
    this.itemCreatePageDeleteItemButton,
    this.itemCreatePageDeleteConfirmationTitle,
    this.itemCreatePageDeleteConfirmationMessage,
    this.itemCreatePageDeleteConfirmationConfirm,
    this.itemCreatePageDeleteConfirmationCancel,
    this.itemCreatePageGenericError,
    this.itemCreatePageItemDeletedSuccess,
    this.itemCreatePageItemDeleteError,
  });

  /// The title for the catalog overview screen.
  final String? overviewTitle;

  /// The hint text for the search field in the catalog overview screen.
  final String? searchHint;

  /// The title for the item creation page.
  final String? itemCreatePageTitle;

  /// The title for the item editing page.
  final String? itemEditPageTitle;

  /// The hint text for the title input field on the create/edit page.
  final String? itemCreatePageTitleHint;

  /// The hint text for the description input field on the create/edit page.
  final String? itemCreatePageDescriptionHint;

  /// The error message shown when the title is empty.
  final String? itemCreatePageTitleRequiredError;

  /// The text for the button to add images on the create/edit page.
  final String? itemCreatePageAddImagesButton;

  /// The text for the save button on the create/edit page.
  final String? itemCreatePageSaveChangesButton;

  /// The text for the save button when it is in a loading state.
  final String? itemCreatePageSavingChangesButton;

  /// The text for the delete button on the edit page.
  final String? itemCreatePageDeleteItemButton;

  /// The title for the delete confirmation dialog.
  final String? itemCreatePageDeleteConfirmationTitle;

  /// The message for the delete confirmation dialog.
  final String? itemCreatePageDeleteConfirmationMessage;

  /// The text for the confirm button in the delete confirmation dialog.
  final String? itemCreatePageDeleteConfirmationConfirm;

  /// The text for the cancel button in the delete confirmation dialog.
  final String? itemCreatePageDeleteConfirmationCancel;

  /// The generic error message for snackbars.
  final String? itemCreatePageGenericError;

  /// The success message when an item is deleted.
  final String? itemCreatePageItemDeletedSuccess;

  /// The error message when an item fails to delete.
  final String? itemCreatePageItemDeleteError;

  /// Creates a copy of this object with the given fields replaced.
  CatalogTranslations copyWith({
    String? overviewTitle,
    String? searchHint,
    String? itemCreatePageTitle,
    String? itemEditPageTitle,
    String? itemCreatePageTitleHint,
    String? itemCreatePageDescriptionHint,
    String? itemCreatePageTitleRequiredError,
    String? itemCreatePageSaveChangesButton,
    String? itemCreatePageSavingChangesButton,
    String? itemCreatePageDeleteItemButton,
    String? itemCreatePageDeleteConfirmationTitle,
    String? itemCreatePageDeleteConfirmationMessage,
    String? itemCreatePageDeleteConfirmationConfirm,
    String? itemCreatePageDeleteConfirmationCancel,
    String? itemCreatePageGenericError,
    String? itemCreatePageAddImagesButton,
    String? itemCreatePageItemDeletedSuccess,
    String? itemCreatePageItemDeleteError,
  }) =>
      CatalogTranslations(
        overviewTitle: overviewTitle ?? this.overviewTitle,
        searchHint: searchHint ?? this.searchHint,
        itemCreatePageTitle: itemCreatePageTitle ?? this.itemCreatePageTitle,
        itemEditPageTitle: itemEditPageTitle ?? this.itemEditPageTitle,
        itemCreatePageTitleHint:
            itemCreatePageTitleHint ?? this.itemCreatePageTitleHint,
        itemCreatePageDescriptionHint:
            itemCreatePageDescriptionHint ?? this.itemCreatePageDescriptionHint,
        itemCreatePageTitleRequiredError: itemCreatePageTitleRequiredError ??
            this.itemCreatePageTitleRequiredError,
        itemCreatePageSaveChangesButton: itemCreatePageSaveChangesButton ??
            this.itemCreatePageSaveChangesButton,
        itemCreatePageSavingChangesButton: itemCreatePageSavingChangesButton ??
            this.itemCreatePageSavingChangesButton,
        itemCreatePageDeleteItemButton: itemCreatePageDeleteItemButton ??
            this.itemCreatePageDeleteItemButton,
        itemCreatePageDeleteConfirmationTitle:
            itemCreatePageDeleteConfirmationTitle ??
                this.itemCreatePageDeleteConfirmationTitle,
        itemCreatePageDeleteConfirmationMessage:
            itemCreatePageDeleteConfirmationMessage ??
                this.itemCreatePageDeleteConfirmationMessage,
        itemCreatePageDeleteConfirmationConfirm:
            itemCreatePageDeleteConfirmationConfirm ??
                this.itemCreatePageDeleteConfirmationConfirm,
        itemCreatePageDeleteConfirmationCancel:
            itemCreatePageDeleteConfirmationCancel ??
                this.itemCreatePageDeleteConfirmationCancel,
        itemCreatePageGenericError:
            itemCreatePageGenericError ?? this.itemCreatePageGenericError,
        itemCreatePageItemDeletedSuccess: itemCreatePageItemDeletedSuccess ??
            this.itemCreatePageItemDeletedSuccess,
        itemCreatePageItemDeleteError:
            itemCreatePageItemDeleteError ?? this.itemCreatePageItemDeleteError,
        itemCreatePageAddImagesButton:
            itemCreatePageAddImagesButton ?? this.itemCreatePageAddImagesButton,
      );
}
