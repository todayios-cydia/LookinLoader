ARCHS = arm64
THEOS_DEVICE_IP = localhost -p 2222
TARGET = iphone:clang:13.7 # 注意 theos 的 SDK 内是否有相应的版本
include ${THEOS}/makefiles/common.mk

BUNDLE_NAME = LookinLoaderPrefs
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = AltList
$(BUNDLE_NAME)_FILES = RootListController.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk