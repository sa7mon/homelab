{lib, stdenv, fetchFromGitHub, cups}:

stdenv.mkDerivation {
  pname = "cups-rollo-thermal";
  version = "2023-11-15";

  src = fetchFromGitHub {
    owner = "sa7mon";
    repo = "rollo-thermal";
    rev = "91207ea";
    sha256 = "08fk5a2vvvcvg0xwvimh6q8sca1grzxk9sdljxg2x2ak2vqjni51";
  };

  buildInputs = [ cups ];

  installPhase = ''
    install -D rastertolabel $out/lib/cups/filter/rastertolabel
    install -D Printer_ThermalPrinter.ppd $out/share/cups/model/rollo/rollo-thermal.ppd
  '';

  meta = with lib; {
    description = "CUPS filter for Rollo thermal printer";
    homepage = "https://github.com/sa7mon/rollo-thermal";
    platforms = platforms.linux;
    maintainers = with maintainers; [  ];
    license = licenses.bsd2;
  };
}
