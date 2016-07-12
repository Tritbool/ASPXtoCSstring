with procedures;    use procedures;
with Gtk.Main;    use Gtk.Main;

procedure WinMain is
   fenetre : t_fenetre;
begin

   Gtk.main.init;
   init(fenetre);
   Gtk.main.Main;

end WinMain;
