unit formAltaClientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons,unidadCentral,formPrincipal;

type

  { TfrmClientes }

  TfrmClientes = class(TForm)
    btnCANCELAR: TBitBtn;
    btnACEPTAR: TBitBtn;
    edt3: TLabeledEdit;
    edt4: TLabeledEdit;
    edt1: TLabeledEdit;
    edt2: TLabeledEdit;
    procedure btnCANCELARClick(Sender: TObject);
    procedure btnACEPTARClick(Sender: TObject);
  private

  public

  end;

var
frmClientes: TfrmClientes;
c:fileOfClientes;
fOfUsers: fileOfUsuarios;
fOfCliente:fileOfClientes;

implementation

{$R *.lfm}

{ TfrmClientes }

{procedure cargarGrilla();
var
    usuAux:RCliente; i:integer;
begin
   if(archivoAbiertoUsers(fOfUsers) <> 0) then // si se abrio dara un número distinto de 0 y empezamos a trabajar con el archivo en else
    Close(fOfUsers)
  else
  begin
       i:=1;
       frmPrincipal.grillaCuentas.RowCount:=1;
       while not eof(fOfUsers) do //mientras tenga para leer el archivo y no encuentre en usuario
        begin
          frmPrincipal.grillaCuentas.RowCount:=frmPrincipal.grillaCuentas.RowCount+1;
          read(fOfUsers,usuAux);                  // leo
          frmPrincipal.grillaCuentas.Cells[0,i]:=IntToStr(usuAux.id);
          frmPrincipal.grillaCuentas.Cells[1,i]:=IntToStr(usuAux.dni);
          frmPrincipal.grillaCuentas.Cells[2,i]:=usuAux.nombre;
          frmPrincipal.grillaCuentas.Cells[3,i]:=usuAux.rol;
          i:=i+1;
        end;
        close(fOfUsers);
  end;
end; }

procedure crearUsuario(nuevo: RCliente);
var
   usu:RCliente;i,j:integer;  v: Array [1..100] of RCliente;
begin
  i:=2;
       v[1]:=nuevo;
       if archivoAbiertoCliente(c)=0 then //abro archivo para lectura
       begin
            while not eof(c) do
            begin
                 read(c,usu); //recorro y guardo en la variable USU
                 v[i]:=usu;  //lo agrego al vector en la posición i
                 i:=i+1;     //aumento i para tener una siguiente posición en el vector
            end;
            close(c);
            if archivoAbiertoCliente2(c)<>0 then // veo que se pueda abrir el archivo para escritura '2 (dos'
               close(c)
            else
                //ordenarV(v,i);
                for j:=1 to i-1 do // recorro los elementos de mi arreglo
                begin
                     write(c,v[j]); //y los escribo en el archivo
                end;
                close(c);
       end
       else
           ShowMessage('problema');


end;

procedure TfrmClientes.btnCANCELARClick(Sender: TObject);
begin
  close;
end;

procedure TfrmClientes.btnACEPTARClick(Sender: TObject);
var
  newClient: RCliente;
  mensaje:String;

begin
  edt1.Text:=inttostr(generarIdCliente());
   if (edt2.text<>'') and (edt3.text<>'') and (edt4.text<>'')  then
   begin
         newClient.id:=generarIdCliente();
         newClient.dni:=StrToInt(edt3.Text);
         newClient.nombre:=edt2.Text;
         newClient.domicilio:=edt4.Text;
         crearUsuario(newClient);
         mensaje:='Cliente creado con exito YES para continuar';
         frmPrincipal.buscarClick(Sender);
         if MessageDlg(mensaje, mtConfirmation,[mbYes], 0) = mrYes then
         begin
         {borrar();}
         Close;
         end;
     end
   else
        ShowMessage('Por favor rellene todos los campos');

end;

end.


