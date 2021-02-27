#!/bin/bash

set -e

function run_for_framework() {
	framework="$1"

	echo "Exporting coverage and uploading it to Codecov for framework \"$framework\""

	bundle exec slather coverage -x \
		--source-directory "Sources/$framework" \
		--output-directory ".build/Coverage/$framework" \
		--scheme "AllUnitTests" \
		--workspace "QAMenu.xcworkspace" \
		--binary-basename "$framework" \
		--ignore "Tests/*" \
		--ignore "Sources/QAMenuCatalog/*" \
		"QAMenu.xcodeproj"

	bash <(curl -s https://codecov.io/bash) -f ".build/Coverage/$framework/cobertura.xml" -X coveragepy -X gcov -X xcode -F "$framework"
}

run_for_framework "QAMenu"
run_for_framework "QAMenuUIKit"
run_for_framework "QAMenuUtils"

exit 0
