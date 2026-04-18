# My Bricks

Custom Mason bricks for Flutter projects.

## bricks

### init_project
Initializes a new Flutter project with:
- Full `lib/core/` folder structure with all utilities, services, widgets, etc.
- Empty `lib/features/` folder
- Assets folders (images, icons, fonts)
- pubspec.yaml with all required dependencies

### make_feature
Creates a new feature module with:
- `lib/features/{feature_name}/widget/`
- `lib/features/{feature_name}/providers/`
- `lib/features/{feature_name}/repositories/`
- `lib/features/{feature_name}/models/`

---

## How to Use

### Option 1: Use from GitHub (Recommended after publishing)

Add bricks from GitHub in your project's `mason.yaml`:

```yaml
bricks:
  init_project:
    git:
      url: https://github.com/YOUR_USERNAME/my_bricks.git
      path: bricks/init_project
  make_feature:
    git:
      url: https://github.com/YOUR_USERNAME/my_bricks.git
      path: bricks/make_feature
```

Then run:
```bash
mason get
```

### Option 2: Use Locally

If working on bricks locally, add path to local bricks:

```bash
cd your_flutter_project
mason add init_project --path /Users/arun/Desktop/Xcenter/my_bricks/bricks/init_project
mason add make_feature --path /Users/arun/Desktop/Xcenter/my_bricks/bricks/make_feature
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

# 3. Add and run init_project brick
mason add init_project --path /path/to/my_bricks/bricks/init_project
# OR after adding to mason.yaml with git:
mason get
mason make init_project
# Enter project name when prompted (e.g., my_tv_app)

# 4. Follow printed instructions:
flutter pub get
dart run build_runner build -d
```

### Add a New Feature

```bash
# After init_project is set up
mason make make_feature
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

- Run `flutter pub get` after generating with `init_project`
- Run `dart run build_runner build -d` to generate freezed/riverpod code
- After first use with git URL, just run `mason get` to update bricks