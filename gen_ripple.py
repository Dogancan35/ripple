#!/usr/bin/env python3
"""Generate Xcode project for Ripple."""

import os

PROJECT_DIR = "."
SOURCES = [
    "RippleApp.swift",
    "ContentView.swift",
    "RippleItem.swift",
    "RippleCard.swift",
    "HomeView.swift",
    "OpenRippleView.swift",
    "SendRippleView.swift",
    "InboxView.swift",
    "SentView.swift",
]

IDS = {
    "FID1":  "F10000000000000000000001",
    "FID2":  "F10000000000000000000002",
    "FID3":  "F10000000000000000000003",
    "FID4":  "F10000000000000000000004",
    "FID5":  "F10000000000000000000005",
    "FID6":  "F10000000000000000000006",
    "FID7":  "F10000000000000000000007",
    "FID8":  "F10000000000000000000008",
    "FID9":  "F10000000000000000000009",
    "FID10": "F10000000000000000000010",
    "FID11": "F10000000000000000000011",
    "FID12": "F10000000000000000000012",
    "FR1":   "F20000000000000000000001",
    "FR2":   "F20000000000000000000002",
    "FR3":   "F20000000000000000000003",
    "FR4":   "F20000000000000000000004",
    "FR5":   "F20000000000000000000005",
    "FR6":   "F20000000000000000000006",
    "FR7":   "F20000000000000000000007",
    "FR8":   "F20000000000000000000008",
    "FR9":   "F20000000000000000000009",
    "FR10":  "F20000000000000000000010",
    "FR11":  "F20000000000000000000011",
    "FR12":  "F20000000000000000000012",
    "FR17":  "F20000000000000000000017",
    "GRP_MAIN":  "F30000000000000000000001",
    "GRP_SOURCES":"F30000000000000000000002",
    "GRP_RESOURCES":"F30000000000000000000003",
    "GRP_PRODUCTS":"F30000000000000000000004",
    "TARGET": "F30000000000000000000005",
    "PROJECT": "F30000000000000000000006",
    "FRAMEWORKS_PHASE": "F30000000000000000000007",
    "RESOURCES_PHASE": "F30000000000000000000008",
    "SOURCES_PHASE": "F30000000000000000000009",
    "DEBUG_CFG": "F40000000000000000000001",
    "RELEASE_CFG": "F40000000000000000000002",
    "TARGET_DEBUG": "F40000000000000000000003",
    "TARGET_RELEASE": "F40000000000000000000004",
    "PROJ_CONFIGS": "F40000000000000000000005",
    "TARGET_CONFIGS": "F40000000000000000000006",
}

def r(k): return IDS[k]

# Build file / file-ref strings
pbx_files = "\n".join(
    f'\t\t{r(f"FID{i+1}")} /* {f} in Sources */ = {{isa = PBXBuildFile; fileRef = {r(f"FR{i+1}")}; }};'
    for i, f in enumerate(SOURCES)
)
pbx_refs = "\n".join(
    f'\t\t{r(f"FR{i+1}")} /* {f} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {f}; sourceTree = "<group>"; }};'
    for i, f in enumerate(SOURCES)
)
pbx_refs += "\n" + '\n'.join([
    f'\t\t{r("FR9")} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist; path = Info.plist; sourceTree = "<group>"; }};',
    f'\t\t{r("FR10")} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder; path = Assets.xcassets; sourceTree = "<group>"; }};',
    f'\t\t{r("FR11")} /* Ripple.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Ripple.app; sourceTree = BUILT_PRODUCTS_DIR; }};',
])

source_files_refs = " ".join(r(f"FR{i+1}") for i in range(len(SOURCES)))

content = f"""// !$*UTF8*$!
{{
\tarchiveVersion = 1;
\tclasses = {{
\t}};
\tobjectVersion = 56;
\tobjects = {{

/* Begin PBXBuildFile section */
{pbx_files}
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
{pbx_refs}
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t{r('FRAMEWORKS_PHASE')} = {{isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t{r('GRP_MAIN')} = {{isa = PBXGroup; children = ({r('GRP_SOURCES')}, {r('GRP_RESOURCES')}, {r('GRP_PRODUCTS')}); sourceTree = "<group>"; }};
\t\t{r('GRP_SOURCES')} = {{isa = PBXGroup; children = ({source_files_refs}); sourceTree = "<group>"; }};
\t\t{r('GRP_RESOURCES')} = {{isa = PBXGroup; children = ({r('FR9')}, {r('FR10')}); sourceTree = "<group>"; }};
\t\t{r('GRP_PRODUCTS')} = {{isa = PBXGroup; children = ({r('FR17')}); name = Products; sourceTree = "<group>"; }};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t{r('TARGET')} = {{isa = PBXNativeTarget; buildConfigurationList = {r('TARGET_CONFIGS')}; buildPhases = ({r('SOURCES_PHASE')}, {r('FRAMEWORKS_PHASE')}, {r('RESOURCES_PHASE')}); buildRules = (); dependencies = (); name = Ripple; productName = Ripple; productReference = {r('FR17')}; productType = "com.apple.product-type.application"; }};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t{r('PROJECT')} = {{isa = PBXProject; buildConfigurationList = {r('PROJ_CONFIGS')}; compatibilityVersion = "Xcode 14.0"; developmentRegion = en; hasScannedForEncodings = 0; knownRegions = (en, Base); mainGroup = {r('GRP_MAIN')}; productRefGroup = {r('GRP_PRODUCTS')}; projectDirPath = ""; projectRoot = ""; targets = ({r('TARGET')}); }};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t{r('RESOURCES_PHASE')} = {{isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = ({r('FID9')}, {r('FID10')}); runOnlyForDeploymentPostprocessing = 0; }};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t{r('SOURCES_PHASE')} = {{isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = ({source_files_refs}); runOnlyForDeploymentPostprocessing = 0; }};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t{r('DEBUG_CFG')} = {{isa = XCBuildConfiguration; buildSettings = {{ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ANALYZER_NONLOCALIZED = YES; CLANG_CXX_LANGUAGE_STANDARD = "gnu++20"; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CODE_SIGN_STYLE = Automatic; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = dwarf; ENABLE_STRICT_OBJC_MSGSEND = YES; ENABLE_TESTABILITY = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE; ONLY_ACTIVE_ARCH = YES; SDKROOT = iphoneos; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; SWIFT_OPTIMIZATION_LEVEL = "-Onone"; }}; name = Debug; }};
\t\t{r('RELEASE_CFG')} = {{isa = XCBuildConfiguration; buildSettings = {{ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ANALYZER_NONLOCALIZED = YES; CLANG_CXX_LANGUAGE_STANDARD = "gnu++20"; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CODE_SIGN_STYLE = Automatic; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym"; ENABLE_NS_ASSERTIONS = NO; ENABLE_STRICT_OBJC_MSGSEND = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MTL_ENABLE_DEBUG_INFO = NO; SDKROOT = iphoneos; SWIFT_COMPILATION_MODE = wholemodule; SWIFT_OPTIMIZATION_LEVEL = "-O"; VALIDATE_PRODUCT = YES; }}; name = Release; }};
\t\t{r('TARGET_DEBUG')} = {{isa = XCBuildConfiguration; buildSettings = {{ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_CFBundleDisplayName = "Ripple"; INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES; INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES; INFOPLIST_KEY_UILaunchScreen_Generation = YES; INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait"; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MARKETING_VERSION = 1.0.0; CURRENT_PROJECT_VERSION = 1; PRODUCT_BUNDLE_IDENTIFIER = com.skilachi.ripple; PRODUCT_NAME = "$(TARGET_NAME)"; SKIP_INSTALL = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = "1"; CODE_SIGN_IDENTITY = "-"; CODE_SIGNING_REQUIRED = NO; CODE_SIGNING_ALLOWED = NO; }}; name = Debug; }};
\t\t{r('TARGET_RELEASE')} = {{isa = XCBuildConfiguration; buildSettings = {{ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_CFBundleDisplayName = "Ripple"; INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES; INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES; INFOPLIST_KEY_UILaunchScreen_Generation = YES; INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait"; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MARKETING_VERSION = 1.0.0; CURRENT_PROJECT_VERSION = 1; PRODUCT_BUNDLE_IDENTIFIER = com.skilachi.ripple; PRODUCT_NAME = "$(TARGET_NAME)"; SKIP_INSTALL = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = "1"; CODE_SIGN_IDENTITY = "-"; CODE_SIGNING_REQUIRED = NO; CODE_SIGNING_ALLOWED = NO; }}; name = Release; }};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t{r('PROJ_CONFIGS')} = {{isa = XCConfigurationList; buildConfigurations = ({r('DEBUG_CFG')}, {r('RELEASE_CFG')}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};
\t\t{r('TARGET_CONFIGS')} = {{isa = XCConfigurationList; buildConfigurations = ({r('TARGET_DEBUG')}, {r('TARGET_RELEASE')}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};
/* End XCConfigurationList section */

\t}};
\trootObject = {r('PROJECT')};
}}
"""

os.makedirs(os.path.join(PROJECT_DIR, "Ripple.xcodeproj"), exist_ok=True)
path = os.path.join(PROJECT_DIR, "Ripple.xcodeproj", "project.pbxproj")
with open(path, "w") as f:
    f.write(content)
print(f"Written: {path}")