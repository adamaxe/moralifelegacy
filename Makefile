default:
	# Set default make action here
	xcodebuild -target MoraLife -sdk iphonesimulator -configuration Debug clean build
clean:
	-rm -rf build/*
test:
	xcodebuild -target UnitTests -sdk iphonesimulator -configuration Debug build TEST_AFTER_BUILD=YES
