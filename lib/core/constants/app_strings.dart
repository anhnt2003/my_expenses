class AppStrings {
  AppStrings._();

  /* App Info */
  static const String appName = 'My Expenses';
  static const String appVersion = '1.0.0';

  /* Navigation */
  static const String navHome = 'Home';
  static const String navExpenses = 'Expenses';
  static const String navStatistics = 'Statistics';
  static const String navCategories = 'Categories';
  static const String navSettings = 'Settings';

  /* Home Screen */
  static const String homeGreeting = 'Welcome back!';
  static const String homeTotalSpending = 'Total Spending';
  static const String homeThisMonth = 'This Month';
  static const String homeThisWeek = 'This Week';
  static const String homeRecentExpenses = 'Recent Expenses';
  static const String homeSeeAll = 'See All';

  /* Expenses Screen */
  static const String expensesTitle = 'Expenses';
  static const String expensesAddNew = 'Add Expense';
  static const String expensesEdit = 'Edit Expense';
  static const String expensesFilterToday = 'Today';
  static const String expensesFilterWeek = 'This Week';
  static const String expensesFilterMonth = 'This Month';
  static const String expensesFilterAll = 'All';
  static const String expensesNoExpenses = 'No expenses yet';
  static const String expensesNoExpensesDesc =
      'Start tracking your expenses by tapping the + button';

  /* Add/Edit Expense Form */
  static const String formTitle = 'Title';
  static const String formTitleHint = 'Enter expense title';
  static const String formAmount = 'Amount';
  static const String formAmountHint = 'Enter amount';
  static const String formCategory = 'Category';
  static const String formCategoryHint = 'Select a category';
  static const String formDate = 'Date';
  static const String formDateHint = 'Select date';
  static const String formNote = 'Note';
  static const String formNoteHint = 'Add a note (optional)';
  static const String formSave = 'Save';
  static const String formCancel = 'Cancel';
  static const String formDelete = 'Delete';

  /* Categories Screen */
  static const String categoriesTitle = 'Categories';
  static const String categoriesAddNew = 'Add Category';
  static const String categoriesEdit = 'Edit Category';
  static const String categoriesName = 'Category Name';
  static const String categoriesNameHint = 'Enter category name';
  static const String categoriesSelectIcon = 'Select Icon';
  static const String categoriesSelectColor = 'Select Color';
  static const String categoriesNoCategories = 'No categories';
  static const String categoriesNoCategoriesDesc =
      'Add categories to organize your expenses';

  /* Statistics Screen */
  static const String statsTitle = 'Statistics';
  static const String statsPeriodWeek = 'Week';
  static const String statsPeriodMonth = 'Month';
  static const String statsPeriodYear = 'Year';
  static const String statsTotal = 'Total';
  static const String statsAverage = 'Average';
  static const String statsHighest = 'Highest';
  static const String statsByCategory = 'By Category';
  static const String statsMonthlyTrend = 'Monthly Trend';

  /* Settings Screen */
  static const String settingsTitle = 'Settings';
  static const String settingsTheme = 'Theme';
  static const String settingsThemeLight = 'Light';
  static const String settingsThemeDark = 'Dark';
  static const String settingsThemeSystem = 'System';
  static const String settingsCurrency = 'Currency';
  static const String settingsExportData = 'Export Data';
  static const String settingsAbout = 'About';
  static const String settingsVersion = 'Version';

  /* Default Categories */
  static const String categoryFood = 'Food & Dining';
  static const String categoryTransport = 'Transportation';
  static const String categoryShopping = 'Shopping';
  static const String categoryEntertainment = 'Entertainment';
  static const String categoryBills = 'Bills & Utilities';
  static const String categoryHealth = 'Health';
  static const String categoryEducation = 'Education';
  static const String categoryOther = 'Other';

  /* Common */
  static const String commonError = 'Something went wrong';
  static const String commonRetry = 'Retry';
  static const String commonLoading = 'Loading...';
  static const String commonEmpty = 'No data available';
  static const String commonOk = 'OK';
  static const String commonYes = 'Yes';
  static const String commonNo = 'No';
  static const String commonConfirmDelete =
      'Are you sure you want to delete this?';

  /* Currency */
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';

  /* Placeholders */
  static const String placeholderSearch = 'Search...';
}
