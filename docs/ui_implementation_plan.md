# My Expenses - UI Implementation Plan

> **UI-First Development Approach**  
> Focus on building all screens, widgets, and visual components with mock/static data before implementing business logic.

---

## 📋 Overview

This plan covers the implementation of the UI layer for the My Expenses app. All screens will use **static/mock data** for display purposes, allowing rapid iteration on the visual design before connecting to the data layer.

---

## User Review Required

> [!IMPORTANT]
> This plan focuses **only on UI/visual components** with mock data. No business logic, database, or state management implementation is included.

> [!NOTE]
> Color scheme and design tokens will be established first to ensure visual consistency across all screens.

---

## Proposed Changes

### Phase 1: Core Foundation & Design System

#### [NEW] [app_colors.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/constants/app_colors.dart)
- Primary, secondary, accent colors
- Semantic colors (success, error, warning, info)
- Light and dark theme color variants
- Gradient definitions for cards and backgrounds

#### [NEW] [app_sizes.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/constants/app_sizes.dart)
- Spacing constants (xs, sm, md, lg, xl)
- Border radius values
- Icon sizes
- Standard widget dimensions

#### [NEW] [app_strings.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/constants/app_strings.dart)
- All hardcoded UI strings for labels, buttons, titles
- Placeholder texts

#### [NEW] [app_theme.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/theme/app_theme.dart)
- Material 3 theme configuration
- Light theme data
- Dark theme data
- Custom color scheme extensions

#### [NEW] [text_styles.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/theme/text_styles.dart)
- Typography system (headings, body, captions)
- Font family configuration (Google Fonts)

---

### Phase 2: Shared Widgets Library

#### [NEW] [custom_button.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/custom_button.dart)
- Primary, secondary, outlined button variants
- Loading state support
- Icon button support

#### [NEW] [custom_text_field.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/custom_text_field.dart)
- Standard text input with label
- Prefix/suffix icon support
- Error state styling
- Currency input variant

#### [NEW] [loading_widget.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/loading_widget.dart)
- Circular progress indicator with app styling
- Shimmer loading skeleton variant

#### [NEW] [error_widget.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/error_widget.dart)
- Error message display with icon
- Retry button option

#### [NEW] [empty_state_widget.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/empty_state_widget.dart)
- Illustration/icon placeholder
- Message and action button

---

### Phase 3: App Shell & Navigation

#### [NEW] [route_names.dart](file:///Users/mac/work%20space%20/my_expenses/lib/router/route_names.dart)
- Static route path constants

#### [NEW] [app_router.dart](file:///Users/mac/work%20space%20/my_expenses/lib/router/app_router.dart)
- GoRouter configuration
- Route definitions for all screens
- Shell route with bottom navigation

#### [NEW] [main_shell.dart](file:///Users/mac/work%20space%20/my_expenses/lib/shared/widgets/main_shell.dart)
- Bottom navigation bar scaffold
- Navigation icons and labels (Home, Expenses, Statistics, Settings)

#### [MODIFY] [main.dart](file:///Users/mac/work%20space%20/my_expenses/lib/main.dart)
- Integrate GoRouter
- Apply app theme
- Wrap with ProviderScope (for future Riverpod)

---

### Phase 4: Home Feature

#### [NEW] [home_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/home/screens/home_screen.dart)
- Dashboard layout with greeting
- Summary cards section
- Recent expenses list section
- Floating action button for quick add

#### [NEW] [expense_summary_card.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/home/widgets/expense_summary_card.dart)
- Total spending card
- This month/week spending display
- Animated counter (optional)
- Gradient background styling

#### [NEW] [recent_expenses_list.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/home/widgets/recent_expenses_list.dart)
- Horizontal scrollable or vertical list
- Shows last 5 expenses with mock data
- "See All" button

#### [NEW] [quick_add_fab.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/home/widgets/quick_add_fab.dart)
- Animated floating action button
- Navigation to add expense screen

---

### Phase 5: Expenses Feature

#### [NEW] [expenses_list_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/screens/expenses_list_screen.dart)
- AppBar with search and filter icons
- Date filter chips (Today, This Week, This Month, All)
- Grouped expense list by date
- Empty state when no expenses

#### [NEW] [add_expense_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/screens/add_expense_screen.dart)
- Form layout with title, amount, category, date, note fields
- Category selector (grid or dropdown)
- Date picker integration
- Save button

#### [NEW] [expense_tile.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/widgets/expense_tile.dart)
- Category icon with colored background
- Title and amount display
- Date and optional note preview
- Swipe to delete gesture (visual only)

#### [NEW] [expense_form.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/widgets/expense_form.dart)
- Reusable form widget for add/edit
- Form validation UI (visual only)

#### [NEW] [date_picker_field.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/widgets/date_picker_field.dart)
- Tappable field that opens date picker
- Displays formatted selected date

#### [NEW] [category_selector.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/expenses/widgets/category_selector.dart)
- Grid of category icons with labels
- Selected state styling
- Mock categories (Food, Transport, Shopping, etc.)

---

### Phase 6: Categories Feature

#### [NEW] [categories_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/categories/screens/categories_screen.dart)
- List of all categories
- Add category FAB
- Edit/delete actions (visual only)

#### [NEW] [category_tile.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/categories/widgets/category_tile.dart)
- Category icon and color
- Name and expense count
- Edit/delete buttons

#### [NEW] [category_form_dialog.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/categories/widgets/category_form_dialog.dart)
- Modal dialog for add/edit category
- Name input, icon picker, color picker

#### [NEW] [icon_picker.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/categories/widgets/icon_picker.dart)
- Grid of available icons
- Search/filter functionality

#### [NEW] [color_picker.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/categories/widgets/color_picker.dart)
- Preset color palette selection
- Selected indicator

---

### Phase 7: Statistics Feature

#### [NEW] [statistics_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/statistics/screens/statistics_screen.dart)
- Period selector (Week, Month, Year)
- Summary stats cards
- Category pie chart
- Monthly trend bar chart

#### [NEW] [expense_pie_chart.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/statistics/widgets/expense_pie_chart.dart)
- fl_chart pie chart with mock data
- Category legend
- Interactive touch for details

#### [NEW] [monthly_bar_chart.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/statistics/widgets/monthly_bar_chart.dart)
- fl_chart bar chart with mock monthly data
- X-axis with month labels
- Hover/touch for values

#### [NEW] [stats_summary_card.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/statistics/widgets/stats_summary_card.dart)
- Total, average, highest expense display
- Comparison with previous period

---

### Phase 8: Settings Feature

#### [NEW] [settings_screen.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/settings/screens/settings_screen.dart)
- Theme toggle (Light/Dark/System)
- Currency selector
- Export data option (visual only)
- About section
- App version display

#### [NEW] [settings_tile.dart](file:///Users/mac/work%20space%20/my_expenses/lib/feature/settings/widgets/settings_tile.dart)
- Icon, title, subtitle layout
- Trailing widget support (switch, chevron, value)

---

### Phase 9: Mock Data Layer

#### [NEW] [mock_data.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/mock/mock_data.dart)
- Static list of mock expenses
- Static list of mock categories
- Mock statistics data
- Helper methods to get data for UI testing

---

## File Structure Summary

```
lib/
├── main.dart                              [MODIFY]
├── core/
│   ├── constants/
│   │   ├── app_colors.dart               [NEW]
│   │   ├── app_sizes.dart                [NEW]
│   │   └── app_strings.dart              [NEW]
│   ├── theme/
│   │   ├── app_theme.dart                [NEW]
│   │   └── text_styles.dart              [NEW]
│   └── mock/
│       └── mock_data.dart                [NEW]
├── shared/
│   └── widgets/
│       ├── custom_button.dart            [NEW]
│       ├── custom_text_field.dart        [NEW]
│       ├── loading_widget.dart           [NEW]
│       ├── error_widget.dart             [NEW]
│       ├── empty_state_widget.dart       [NEW]
│       └── main_shell.dart               [NEW]
├── router/
│   ├── route_names.dart                  [NEW]
│   └── app_router.dart                   [NEW]
├── feature/
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart          [NEW]
│   │   └── widgets/
│   │       ├── expense_summary_card.dart [NEW]
│   │       ├── recent_expenses_list.dart [NEW]
│   │       └── quick_add_fab.dart        [NEW]
│   ├── expenses/
│   │   ├── screens/
│   │   │   ├── expenses_list_screen.dart [NEW]
│   │   │   └── add_expense_screen.dart   [NEW]
│   │   └── widgets/
│   │       ├── expense_tile.dart         [NEW]
│   │       ├── expense_form.dart         [NEW]
│   │       ├── date_picker_field.dart    [NEW]
│   │       └── category_selector.dart    [NEW]
│   ├── categories/
│   │   ├── screens/
│   │   │   └── categories_screen.dart    [NEW]
│   │   └── widgets/
│   │       ├── category_tile.dart        [NEW]
│   │       ├── category_form_dialog.dart [NEW]
│   │       ├── icon_picker.dart          [NEW]
│   │       └── color_picker.dart         [NEW]
│   ├── statistics/
│   │   ├── screens/
│   │   │   └── statistics_screen.dart    [NEW]
│   │   └── widgets/
│   │       ├── expense_pie_chart.dart    [NEW]
│   │       ├── monthly_bar_chart.dart    [NEW]
│   │       └── stats_summary_card.dart   [NEW]
│   └── settings/
│       ├── screens/
│       │   └── settings_screen.dart      [NEW]
│       └── widgets/
│           └── settings_tile.dart        [NEW]
```

**Total: 35+ new files, 1 modified file**

---

## Verification Plan

### Visual Testing (Manual)

1. **Run the app locally**
   ```bash
   cd "/Users/mac/work space /my_expenses"
   flutter run
   ```

2. **Navigation Flow**
   - Verify bottom navigation works between all 4 tabs
   - Verify navigation to add expense screen from FAB
   - Verify back navigation behavior

3. **Screen-by-Screen Review**
   - [ ] Home Screen: Summary cards display, recent expenses list renders
   - [ ] Expenses List: Date filters visible, expense tiles display correctly
   - [ ] Add Expense: All form fields visible and interactive
   - [ ] Categories: Category list displays, add dialog opens
   - [ ] Statistics: Charts render with mock data
   - [ ] Settings: All settings tiles visible, theme toggle works

4. **Theme Testing**
   - Toggle between light and dark theme
   - Verify all colors adapt correctly

5. **Responsive Testing**
   - Test on different screen sizes using Flutter DevTools
   - Verify layouts don't overflow

---

## Implementation Order

| Order | Phase | Priority | Estimated Effort |
|-------|-------|----------|------------------|
| 1 | Core Foundation & Design System | High | 2-3 files |
| 2 | Shared Widgets Library | High | 5 files |
| 3 | App Shell & Navigation | High | 4 files |
| 4 | Home Feature | High | 4 files |
| 5 | Expenses Feature | High | 6 files |
| 6 | Categories Feature | Medium | 5 files |
| 7 | Statistics Feature | Medium | 4 files |
| 8 | Settings Feature | Low | 2 files |
| 9 | Mock Data Layer | Medium | 1 file |

---

## Design References

### Color Palette Suggestion

| Color | Usage | Hex |
|-------|-------|-----|
| Primary | Main actions, FAB | `#6366F1` (Indigo) |
| Secondary | Accents | `#8B5CF6` (Purple) |
| Success | Income, positive | `#10B981` (Green) |
| Error | Expense, delete | `#EF4444` (Red) |
| Background | Dark mode | `#1F2937` (Gray 800) |
| Surface | Cards | `#374151` (Gray 700) |

### Mock Categories to Include

| Category | Icon | Color |
|----------|------|-------|
| Food & Dining | 🍽️ restaurant | Orange |
| Transportation | 🚗 directions_car | Blue |
| Shopping | 🛍️ shopping_bag | Pink |
| Entertainment | 🎬 movie | Purple |
| Bills & Utilities | 📱 receipt | Gray |
| Health | 💊 medical_services | Green |
| Education | 📚 school | Indigo |
| Other | 📦 category | Teal |

---

## Notes

- All screens will use **ConsumerWidget** or **ConsumerStatefulWidget** for future Riverpod integration
- Widget keys will be added following the widget guide
- const constructors used wherever possible
- Accessibility labels will be included for screen readers
