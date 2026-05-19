# My Bricks

Custom Mason bricks for Flutter projects.

## bricks

### directories
Initializes a new Flutter project with:
- Full `lib/core/` folder structure with all utilities, services, widgets, etc.
- Empty `lib/features/` folder
- Assets folders (images, icons, fonts)
- pubspec.yaml with all required dependencies

### feature
Creates a new feature module with:
- `lib/features/{feature_name}/widget/`
- `lib/features/{feature_name}/providers/`
- `lib/features/{feature_name}/repositories/`
- `lib/features/{feature_name}/models/`

---

## How to Use

### Option 1: Use from GitHub 

Add bricks from GitHub in your project's `mason.yaml`:

```yaml
bricks:
  directories:
    git:
      url: https://github.com/github_USERNAME/my_bricks.git
      path: bricks/directories
  feature:
    git:
      url: https://github.com/github_USERNAME/my_bricks.git
      path: bricks/feature
```

Then run:
```bash
mason get
```

### Option 2: Use Locally

If working on bricks locally, add path to local bricks:

```bash
cd your_flutter_project
mason add directories --path /Users/...../bricks/directories
mason add feature --path /Users/..../bricks/feature
```

---

## Commands

### Initialize a New Project

```bash
# 1. Create new Flutter project
flutter create my_tv_app
cd my_tv_app

# 2. Initialize mason
mason init

# 3. Add and run directories brick
mason add directories --path /path/to/my_bricks/bricks/directories
# OR after adding to mason.yaml with git:
mason get
mason make directories
# Enter project name when prompted (e.g., my_tv_app)

# 4. Follow printed instructions:
flutter pub get
dart run build_runner build -d
```

### Add a New Feature

```bash
# After directories is set up
mason make feature
# Enter feature name when prompted (e.g., settings, profile, home)
```

---

## Directory Structure After Use

```
my_tv_app/
├── lib/
│   ├── core/
│   │   ├── providers/
│   │   ├── enums/
│   │   ├── utils/
│   │   ├── models/
│   │   ├── exceptions/
│   │   ├── styles/
│   │   ├── configs/
│   │   ├── services/
│   │   └── widgets/
│   └── features/
│       └── {feature_name}/
│           ├── widget/
│           ├── providers/
│           ├── repositories/
│           └── models/
├── assets/
│   ├── images/
│   ├── icons/snackbar/
│   └── fonts/
└── pubspec.yaml
```

---

## Notes

- Run `flutter pub get` after generating with `directories`
- Run `dart run build_runner build -d` to generate freezed/riverpod code
- After first use with git URL, just run `mason get` to update bricks