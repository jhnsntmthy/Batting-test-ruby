class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def black;colorize(30);end;
  def red;colorize(31);end;
  def green;colorize(32);end;
  def yellow;colorize(33);end;
  def blue;colorize(34);end;
  def pink;colorize(35);end;
  def cyan;colorize(36);end;
  def redbg;colorize(41);end;
  def greenbg;colorize(42);end;
  def yellowbg;colorize(43);end;
  def bluebg;colorize(44);end;
  def pinkbg;colorize(45);end;
  def cyanbg;colorize(46);end;
  def greybg;colorize(47);end;
  def darkgrey;colorize(90);end;
  def lightred;colorize(91);end;
  def lightgreen;colorize(92);end;
  def lightyellow;colorize(93);end;
  def lightblue;colorize(94);end;
  def lightmagenta;colorize(95);end;
  def lightcyan;colorize(96);end;
  def lightgreybg;colorize(100);end;
  def underline;colorize(4);end;
  def bold;colorize(1);end;

  def nrml
    self.downcase.gsub(" ","")
  end
end