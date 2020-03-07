{ stdenv, fetchurl, makeDesktopItem, appimageTools }:

let
  pname = "sia-ui";
  version = "1.4.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://sia.tech/releases/Sia-UI-v${version}.AppImage";
    sha256 = "3ab7905f9075dd6a80953d1427bbc99ce1fc48f60d135bcfb136dcd267b11671";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/sia-ui.desktop $out/share/applications/sia-ui.desktop
    install -m 444 -D ${appimageContents}/sia-ui.png $out/share/icons/hicolor/512x512/apps/sia-ui.png
    substituteInPlace $out/share/applications/sia-ui.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with stdenv.lib; {
    description = "A electron webapp to manage and interface with the Sia daemon";
    homepage = "https://sia.tech/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
