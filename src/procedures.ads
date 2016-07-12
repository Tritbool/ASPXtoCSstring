with ada.Text_IO;    use ada.Text_IO;

with ada.strings.Unbounded;    use ada.strings.Unbounded;

with gnat.spitbol;    use gnat.spitbol;

with Glib.Object;    use Glib.Object;

WITH Gtk.Main;    USE Gtk.Main ;

WITH Gtk.Window ;        USE Gtk.Window ;

with Gtk.Label;       use Gtk.Label;

with Gtk.File_Chooser_Button; use Gtk.File_Chooser_Button;

with gtk.box;    use gtk.box;

with gtk.button;    use gtk.button;

with gtk.File_Chooser;    use gtk.File_Chooser;

with gtk.Message_Dialog;    use gtk.Message_Dialog;

with gtk.dialog;    use gtk.dialog;

with gdk.Pixbuf;    use gdk.Pixbuf;

with Glib.Error;    use Glib.Error;

with gtk.handlers;

package procedures is

      type fenetre;

   type t_fenetre is access fenetre;


   PACKAGE P_Callback IS NEW Gtk.Handlers.user_Callback(Gtk_Window_Record, t_fenetre) ;
   use P_Callback;

   PACKAGE F_Callback IS NEW Gtk.Handlers.user_Callback(Gtk_File_Chooser_Button_Record, t_fenetre) ;
   use F_Callback;

    PACKAGE Ok_Callback IS NEW Gtk.Handlers.user_Callback(Gtk_Button_Record, t_fenetre) ;
   use Ok_Callback;

   type fenetre is record
      Win   : Gtk_Window;
      Label : Gtk_Label;
      Box   : Gtk_Vbox;
      chooser : Gtk_File_Chooser_Button;
      action : Gtk_File_Chooser_Action := Action_Open;
      ok : gtk_button;
      Msg : GTK_Message_Dialog ;
   end record;

   procedure init(tf: in out t_fenetre);

   function process_quotes(l : in string)return integer;

   function is_line (l : in string) return boolean;

   function parseline(l : in string; eof : in boolean)return  string;

   procedure filetostring(s : in string);

   procedure Stop_Program(Emetteur : access Gtk_Window_Record'class; F : t_fenetre);

   procedure parse_file(chooser : access Gtk_File_Chooser_Button_Record'Class; F: T_fenetre);

   procedure parse_file_Ok(Ok : access Gtk_Button_Record'Class; F: T_fenetre);

end procedures;
