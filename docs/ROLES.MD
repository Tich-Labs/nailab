# Admin & Editor Management System

## Role-Based Access Control

- **Updated User Model**: Added `editor` role alongside existing `founder`, `mentor`, and `admin` roles.
- **New Methods**:
  - `editor?` method for checking editor role.
  - `staff` scope for admin/editor users.
- **Distinct Permissions**:
  - **Admins**: Full system access, including managing other admins and editors.
  - **Editors**: Content management access (marketing pages to be implemented later).

## Admin Interface Enhancements

### 1. Admin & Editors Section (`/admin/admin_staffs`)

- **Dedicated Management Page**: Separate from regular users.
- **Full CRUD Operations**: Create, edit, delete admin/editor accounts.
- **Role Management**: Switch between admin and editor roles.
- **Account Confirmation**: Confirm user accounts with one click.
- **Batch Actions**: Bulk confirm accounts and change roles.
- **Profile Management**: Edit user profiles with full details.

### 2. Updated Users Section (`/admin/users`)

- **Filtered View**: Displays only founders and mentors.
- **Role Badges**: Updated styling with distinct colors:
  - 🔴 **Admin**: Red badge (`bg-red-600`)
  - 🟠 **Editor**: Orange badge (`bg-orange-500`)
  - 🟣 **Founder**: Purple badge (existing)
  - 🔵 **Mentor**: Blue badge (existing)

### 3. Navigation Updates

- **New Menu Item**: "Admin & Editors" under the Users section.
- **Organized Structure**:
  - **Users**: Founders & Mentors.
  - **Admin & Editors**: Staff Management.
  - **Founders**: Detailed view.
  - **Admin Users**: ActiveAdmin authentication.

## Sample Data

- **Admin User**: `admin@nailab.com` - Full system administrator.
- **Editor User**: `editor@nailab.com` - Content manager for marketing pages.

## Key Features

- ✅ **Role Separation**: Clear distinction between admin and editor permissions.
- ✅ **Staff Management**: Admins can create and manage other staff accounts.
- ✅ **Account Confirmation**: Easy account activation workflow.
- ✅ **Profile Integration**: Full user profile management.
- ✅ **Batch Operations**: Efficient bulk management tools.
- ✅ **Navigation Integration**: Seamlessly integrated into the admin menu.

## Future Content Management (Editor Role)

The `editor` role is now ready for implementing marketing page content management. Editors will be able to:

- Manage static pages.
- Update marketing content.
- Handle resource publishing.
- Moderate content (to be determined).
