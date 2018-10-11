# 1. Start Visual Studio x86 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "5.11"
$version = "5.11.2"

$qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".zip"
$qt_archive_file = $pwd.Path + "\qt-" + $version + ".zip"
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

$tools_folder = $pwd.Path + "\tools\"
$type = "static-ltcg"
$prefix_base_folder = "qt-" + $version + "-" + $type + "-msvc2017-x86"
$prefix_folder = $pwd.Path + "\" + $prefix_base_folder
$build_folder = $pwd.Path + "\qtbuild-x86"

# OpenSSL
# https://www.npcglib.org/~stathis/blog/precompiled-openssl/
# 1.0.2l
#$openssl_base_folder = "C:\openssl"
#$openssl_include_folder = $openssl_base_folder + "\include"
#$openssl_libs_folder = $openssl_base_folder + "\lib"

# Download Qt sources, unpack.
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

& "$qt_src_base_folder\configure.bat" -release -opensource -confirm-license -platform win32-msvc2017 -opengl desktop -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdeclarative -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtcharts -skip qtgraphicaleffects -skip qtlocation -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtscript -mp -optimize-size -D "JAS_DLL=0" -static -static-runtime -prefix $prefix_folder -ltcg

# -openssl -openssl-linked -I $openssl_include_folder -L $openssl_libs_folder OPENSSL_LIBS="-lUser32 -lAdvapi32 -lGdi32 -llibeay32MD -lssleay32MD"

# Compile.
& "$tools_folder\jom.exe"
nmake install

# Copy qtbinpatcher, OpenSSL.
cp "$tools_folder\qtbinpatcher.*" "$prefix_folder\bin\"
#cp "$openssl_libs_folder\*eay32MT.lib" "$prefix_folder\lib\"

# Fixup OpenSSL DLL paths.
#gci -r -include "*.prl" $prefix_folder | foreach-object { $a = $_.fullname; ( get-content $a ) | foreach-object { $_ -replace "C:\\\\openssl\\\\lib", '$$$$[QT_INSTALL_LIBS]\\' } | set-content $a }

# Remove uneeded files
# * Before 770 MB (uncompressed 3028MB)
# * After 400 MB (uncompressed 1499MB)
Remove-Item -Recurse -Force $prefix_folder/doc/
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QGifPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QICNSPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QICOPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QJpegPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QMinimalIntegrationPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QTgaPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QTiffPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QTuioTouchPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QWbmpPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QWebpPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/cmake/Qt5Gui/Qt5Gui_QWindowsDirect2DIntegrationPlugin.cmake
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5AccessibilitySupport.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5AccessibilitySupport.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Bootstrap.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Bootstrap.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Concurrent.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Concurrent.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Designer.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Designer.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5DesignerComponents.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5DesignerComponents.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5DeviceDiscoverySupport.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5DeviceDiscoverySupport.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5EdidSupport.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5EdidSupport.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5FbSupport.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5FbSupport.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Help.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Help.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Network.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Network.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5OpenGL.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5OpenGL.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5OpenGLExtensions.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5OpenGLExtensions.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5PlatformCompositorSupport.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5PlatformCompositorSupport.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Sql.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Sql.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Svg.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Svg.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5UiTools.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5UiTools.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5WinExtras.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5WinExtras.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Xml.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5Xml.prl
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5XmlPatterns.lib
Remove-Item -Recurse -Force $prefix_folder/lib/Qt5XmlPatterns.prl
Remove-Item -Recurse -Force $prefix_folder/phrasebooks/
Remove-Item -Recurse -Force $prefix_folder/plugins/bearer/
Remove-Item -Recurse -Force $prefix_folder/plugins/generic/
Remove-Item -Recurse -Force $prefix_folder/plugins/iconengines/
Remove-Item -Recurse -Force $prefix_folder/plugins/imageformats/
Remove-Item -Recurse -Force $prefix_folder/plugins/platforms/qdirect2d.lib
Remove-Item -Recurse -Force $prefix_folder/plugins/platforms/qdirect2d.prl
Remove-Item -Recurse -Force $prefix_folder/plugins/platforms/qminimal.lib
Remove-Item -Recurse -Force $prefix_folder/plugins/platforms/qminimal.prl
Remove-Item -Recurse -Force $prefix_folder/plugins/printsupport/
Remove-Item -Recurse -Force $prefix_folder/plugins/sqldrivers/
Remove-Item -Recurse -Force $prefix_folder/translations/

# Create final archive.
& "$tools_folder\7za.exe" a -r "$prefix_base_folder.zip" -w "$prefix_folder" -mem=AES256
