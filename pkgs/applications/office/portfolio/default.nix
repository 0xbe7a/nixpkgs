{ stdenv, glibc, gcc-unwrapped, autoPatchelfHook, fetchurl, libsecret, jre, makeWrapper, makeDesktopItem }:

let
  metadata = assert stdenv.hostPlatform.system == "x86_64-linux";
  { arch = "x86_64"; sha256 = "b0cc728e5b8bc516ecbc7ddda6d17ac25739307376a758f029d2ea9cf12585c9"; };
  desktopItem = makeDesktopItem {
    name = "Portfolio";
    exec = "portfolio";
    icon = "portfolio";
    comment = "Calculate Investment Portfolio Performance";
    desktopName = "Portfolio Performance";
    categories = "Application;Office;";
  };
in
stdenv.mkDerivation rec {
  pname = "PortfolioPerformance";
  version = "0.46.1";

  src = fetchurl {
    url = "https://github.com/buchen/portfolio/releases/download/0.43.1/PortfolioPerformance-${version}-linux.gtk.${metadata.arch}.tar.gz";
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    glibc
    gcc-unwrapped
    libsecret
  ];

  installPhase = ''
    mkdir -p $out/portfolio
    cp -av ./* $out/portfolio

    makeWrapper $out/portfolio/PortfolioPerformance $out/bin/portfolio \
      --prefix PATH : ${jre}/bin

    # Create desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/portfolio/icon.xpm $out/share/pixmaps/portfolio.xpm
  '';

  meta = with stdenv.lib; {
    description = "A simple tool to calculate the overall performance of an investment portfolio.";
    homepage = "https://www.portfolio-performance.info/";
    license = licenses.epl10;
    maintainers = [ maintainers.elohmeier ];
  };
}