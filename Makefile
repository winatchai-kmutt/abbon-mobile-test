gen:
	@dart run build_runner build --delete-conflicting-outputs


install:
	@dart pub global activate melos

gen-translations:
	@python3.11 tools/generate_dart_class.py ./assets/translations/en-US.json ./lib/utils/codegen_loader.g.dart

refresh:
	@melos run refresh
