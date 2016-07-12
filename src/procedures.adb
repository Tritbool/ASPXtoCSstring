package body procedures is


   procedure init(tf: in out t_fenetre) is
      icon : Gdk_Pixbuf;
      err : Gerror;
      begin
        tf := new fenetre;
        Gdk_New_From_File(Pixbuf   => icon,
                                Filename => "icon.gif",
                                Error    => err);

      Gtk_New (tf.all.Win);
      tf.all.win.Set_Title(Title => "ASPXToString");
      tf.all.win.Set_Icon(icon);
        tf.all.Win.Set_Default_Size (300, 100);

        --  Create a box to organize vertically the contents of the window
        Gtk_New_Vbox (tf.all.Box);
        tf.all.Win.Add (tf.all.Box);

      tf.all.ok := Gtk_button_new_with_label(Label => "Ok!");
      tf.all.Ok.hide;

         Gtk_New(tf.all.Msg, tf.all.Win, Modal, Message_Error, Buttons_Ok, "Merci de selectionner un fichier a traiter !") ;
        --  Add a label
        Gtk_New (tf.all.Label, "Choisir un fichier");
        tf.all.Box.Add (tf.all.Label);
        tf.all.chooser:=Gtk_File_Chooser_Button_New("", Action => Action_Open);
        tf.all.chooser.Set_Tooltip_Text(Text => "Choisir un fichier");
        tf.all.Box.Add(tf.all.chooser);
        tf.all.Box.Add(tf.all.ok);
        p_callback.connect(tf.all.win, "destroy", Stop_Program'access,tf) ;
        F_Callback.connect(tf.all.chooser,"file-set", parse_file'access,tf);
        Ok_Callback.connect(tf.all.ok,"clicked",parse_file_ok'access,tf);
        tf.all.Win.Show_all;



      end init;

   function is_line (l : in string) return boolean is

   begin
      for i in l'range loop
         if((character'pos(l(i))>=97 and then character'pos(l(i))<= 122)
            or else (character'pos(l(i))>=65 and then character'pos(l(i))<=90))then
            return true;
         end if;
      end loop;
      return false;
   end is_line;

   function process_quotes(l : in string)return integer is
      cpt : integer := 2;
   begin
      for i in l'range loop
         if(l(i) ='"')then
            cpt := cpt + 1;
         end if;
      end loop;
      return cpt;
   end process_quotes;

   function parseline(l : in string; eof : in boolean)return  string is
      j : integer := 1;
      ll : integer := l'length + process_quotes(l);
      end_line : integer;

   begin
      if(eof)then
         end_line := 1;
      else
         end_line := 2;
      end if;

      declare
              lo :string(1..ll+end_line);
         begin
           if(not is_line(l))then
             return "";
           else
             lo(j) := '"';
             j := j+1;
             for i in l'range loop
               if(l(i)='"')then
                 lo(j) := '\';
                 j := j+1;
                 lo(j) := l(i);
                 j := j+1;
               else
                 lo(j) := l(i);
                 j := j+1;
               end if;
             end loop;
             lo(j) := '"';
             if(not eof)then
               lo(j+1) := '+';
               lo(j+2):=Ascii.LF;
             else
               lo(j+1) := ';';
             end if;
             return lo;
           end if;
         end;
   end parseline;


   procedure filetostring(s : in string)is
      f : File_Type;
      fname_loc : integer := s'last;
   begin
      open(f,in_file, s);

      while(s(fname_loc) /= '/' and s(fname_loc) /= '\')loop
            fname_loc := fname_loc - 1;
      end loop;
      fname_loc := fname_loc + 1;
      declare
         l,lo : unbounded_string;
         fo : File_Type;
         so : string(fname_loc..s'last);
      begin
         for i in fname_loc..s'last loop
            so(i) := s(i);
         end loop;

            create(fo, Out_File, so&"_stringed.txt");
            while(not end_of_file(f))loop
               l:= To_Unbounded_String(get_line(f));
               lo := To_Unbounded_String(parseline(To_String(l),End_Of_File(f)));
               put_line(fo,to_string(lo));
         end loop;
            close(fo);
            Main_Quit;
      end;

      close(f);
   end filetostring;

 procedure Stop_Program(Emetteur : access Gtk_Window_Record'class; F : t_fenetre) IS
      PRAGMA Unreferenced (Emetteur);
   BEGIN
      Main_Quit;
   END Stop_Program ;


  procedure parse_file(chooser : access Gtk_File_Chooser_Button_record'Class; F : t_fenetre) IS
   BEGIN
         F.all.Label.Set_Text("Fichier choisi : "&F.all.chooser.Get_Filename);
   END parse_file ;


   procedure parse_file_Ok(Ok :access Gtk_button_Record'class; F : t_fenetre)is

   begin
      if(F.all.chooser.Get_Filename /= "")then
         filetostring(F.all.chooser.Get_Filename);
      else
         if F.all.msg.Run = Gtk_Response_OK then
            f.all.msg.hide;
         end if;
      end if;
   end parse_file_Ok;
end procedures;
